package main

import (
	"context"
	"crypto/hmac"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"log"
	"net/http"
	"time"

	jwt "github.com/dgrijalva/jwt-go"
)

type handler func(w http.ResponseWriter, r *http.Request) error

func addLog(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		ctx := r.Context()
		userInfo, ok := ctx.Value("userInfo").(User)

		if ok == false {
			log.Printf("%s -- %s (No user)\n", r.Method, r.URL)
		} else {
			log.Printf("%s -- %s (User: %s)\n", r.Method, r.URL, userInfo.UserName)
		}

		next.ServeHTTP(w, r)
	})
}

func addUserInfo(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		tokenStr, err := r.Cookie("token")

		if err != nil {
			next.ServeHTTP(w, r)
			return
		}

		token, err := jwt.Parse(tokenStr.Value, func(token *jwt.Token) (interface{}, error) {
			if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
				return nil, errors.New("Signing method for token doesn't match: " + token.Header["alg"].(string))
			}

			return []byte(secretString), nil
		})

		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			return
		}

		if token == nil {
			err = errors.New("No authorization token specified!")
			w.WriteHeader(http.StatusUnauthorized)
			return
		}

		if !token.Valid {
			err = errors.New("Token is not valid!")
			w.WriteHeader(http.StatusUnauthorized)
			return
		}

		claims := token.Claims

		if int64(claims.(jwt.MapClaims)["exp"].(float64)) < time.Now().Unix() {
			err = errors.New("Token expired!")
			w.WriteHeader(http.StatusUnauthorized)
			return
		}

		// add new context containing user information #####################################################################

		ctx := r.Context()
		userInfoFromClaims := claims.(jwt.MapClaims)["userInfo"]

		extractUserProp := func(userProp string) string {
			return userInfoFromClaims.(map[string]interface{})[userProp].(string)
		}

		extractUserPropList := func(userProp string) []string {
			rolesAsInterface := userInfoFromClaims.(map[string]interface{})[userProp].([]interface{})

			var roles []string = make([]string, len(rolesAsInterface))

			for i, r := range rolesAsInterface {
				roles[i] = r.(string)
			}

			return roles
		}

		userInfo := User{
			UserName:  extractUserProp("userName"),
			FirstName: extractUserProp("firstName"),
			LastName:  extractUserProp("lastName"),
			Email:     extractUserProp("email"),
			Roles:     extractUserPropList("roles"),
		}

		ctx = context.WithValue(ctx, "userInfo", userInfo)

		next.ServeHTTP(w, r.WithContext(ctx))
	})
}

func handle(handlers ...handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		for _, handler := range handlers {
			err := handler(w, r)
			if err != nil {
				log.Printf("There was an error: %v", err)
				return
			}
		}
	})
}

func ensureAuth(w http.ResponseWriter, req *http.Request) (err error) {
	tokenStr, err := req.Cookie("token")

	if err != nil {
		w.WriteHeader(http.StatusUnauthorized)
		return
	}

	token, err := jwt.Parse(tokenStr.Value, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, errors.New("Signing method for token doesn't match: " + token.Header["alg"].(string))
		}

		return []byte(secretString), nil
	})

	if err != nil {
		w.WriteHeader(http.StatusUnauthorized)
		return
	}

	if token == nil {
		err = errors.New("No authorization token specified!")
		w.WriteHeader(http.StatusUnauthorized)
		return
	}

	if !token.Valid {
		err = errors.New("Token is not valid!")
		w.WriteHeader(http.StatusUnauthorized)
		return
	}

	claims := token.Claims

	if int64(claims.(jwt.MapClaims)["exp"].(float64)) < time.Now().Unix() {
		err = errors.New("Token expired!")
		w.WriteHeader(http.StatusUnauthorized)
		return
	}

	// protect from CSRF ###############################################################################################
	jti := claims.(jwt.MapClaims)["jti"]

	mac := hmac.New(sha256.New, []byte(secretString))
	mac.Write([]byte(jti.(string)))
	expectedMAC := mac.Sum(nil)
	xsrfToken, err := hex.DecodeString(req.Header.Get("X-Csrf-Token"))

	if err != nil {
		w.WriteHeader(http.StatusUnauthorized)
		return
	}

	if !hmac.Equal(xsrfToken, expectedMAC) {
		err = errors.New("XSRF token is invalid")
		w.WriteHeader(http.StatusUnauthorized)
		return
	}
	// #################################################################################################################

	return
}
