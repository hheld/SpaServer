package main

import (
	"crypto/hmac"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"log"
	"net/http"
	"time"
)

func userInfoRoute(w http.ResponseWriter, r *http.Request) (err error) {
	ctx := r.Context()
	userInfo := ctx.Value("userInfo").(User)

	// Note that I deliberately return the data from the database here.
	// The logged-in user's data could have been changed, but as long as the
	// token is valid, the information in it is no longer correct! Only the
	// database information is. If the user name should change, this will not work
	// at all any more, so in that case, I still return the token information.
	userFromDb, err := GetUser(userInfo.UserName)

	if err != nil {
		return json.NewEncoder(w).Encode(&userFromDb)
	}

	return json.NewEncoder(w).Encode(&userFromDb)
}

func updateUserRoute(w http.ResponseWriter, r *http.Request) (err error) {
	if r.Method != "POST" {
		return errors.New("Update user endpoint only accepts POST requesets")
	}

	userData := struct {
		OldData User
		NewData User
	}{}

	decoder := json.NewDecoder(r.Body)
	decoder.Decode(&userData)

	return UpdateData(&userData.OldData, &userData.NewData)
}

func fileHandler(rootDir string) http.Handler {
	return http.FileServer(http.Dir(rootDir))
}

func tokenRoute(w http.ResponseWriter, req *http.Request) (err error) {
	if req.Method != "POST" {
		err = errors.New("Token endpoint only accepts POST requests!")
		return
	}

	var ud = struct {
		UserName string `json:"userName"`
		Password string `json:"password"`
	}{}

	decoder := json.NewDecoder(req.Body)
	decoder.Decode(&ud)

	userInfo, err := GetUser(ud.UserName)

	if err != nil {
		w.WriteHeader(http.StatusUnauthorized)
		log.Printf("Authorization failed for user '%s' : %s", ud.UserName, err)
		return
	}

	_, err = ValidateUser(userInfo, ud.Password)

	if err != nil {
		w.WriteHeader(http.StatusUnauthorized)
		log.Printf("Authorization failed for user '%s' : %s", ud.UserName, err)
		return
	}

	token, id, err := generateToken(userInfo)

	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		log.Printf("Could not generate token for user '%s': %s", ud.UserName, err)
		return
	}

	http.SetCookie(w, &http.Cookie{
		Secure:   true,
		HttpOnly: true,
		Name:     "token",
		Value:    string(token),
		MaxAge:   3600 * 24 * 7,
	})

	mac := hmac.New(sha256.New, []byte(secretString))
	mac.Write([]byte(id))

	http.SetCookie(w, &http.Cookie{
		Secure:   true,
		HttpOnly: false,
		Name:     "Csrf-token",
		Value:    hex.EncodeToString(mac.Sum(nil)),
		MaxAge:   3600 * 24 * 7,
	})

	w.WriteHeader(http.StatusOK)

	_ = json.NewEncoder(w).Encode(struct {
		IDToken string `json:"id_token"`
	}{
		IDToken: string(token),
	})

	return
}

func logoutRoute(w http.ResponseWriter, req *http.Request) (err error) {
	http.SetCookie(w, &http.Cookie{
		Secure:   true,
		HttpOnly: true,
		Name:     "token",
		Value:    "",
		Expires:  time.Now().Add(-1 * time.Hour),
	})

	http.SetCookie(w, &http.Cookie{
		Secure:   true,
		HttpOnly: false,
		Name:     "Csrf-token",
		Value:    "",
		Expires:  time.Now().Add(-1 * time.Hour),
	})

	_ = json.NewEncoder(w).Encode(struct {
		Msg []byte `json:"msg"`
	}{
		Msg: []byte("Logged out successfully"),
	})

	return
}

func allUsersRoute(w http.ResponseWriter, req *http.Request) (err error) {
	if req.Method != "GET" {
		return errors.New("All users endpoint only accepts GET requests!")
	}

	users, err := GetAllUsersInDb()

	if err != nil {
		return
	}

	return json.NewEncoder(w).Encode(users)
}

func addUserRoute(w http.ResponseWriter, req *http.Request) (err error) {
	if req.Method != "POST" {
		return errors.New("Add user endpoint only accepts POST requests!")
	}

	userData := struct {
		User     User
		Password string
	}{}

	decoder := json.NewDecoder(req.Body)
	decoder.Decode(&userData)

	return StoreUserInDb(&userData.User, userData.Password)
}

func deleteUserRoute(w http.ResponseWriter, req *http.Request) (err error) {
	if req.Method != "POST" {
		return errors.New("Delete user endpoint only accepts POST requests!")
	}

	var ud = struct {
		UserName string
	}{}

	decoder := json.NewDecoder(req.Body)
	decoder.Decode(&ud)

	return DeleteUser(ud.UserName)
}

func changePwdRoute(w http.ResponseWriter, req *http.Request) (err error) {
	if req.Method != "POST" {
		return errors.New("Update password endpoint only accepts POST requests!")
	}

	pwdData := struct {
		UserName   string
		NewPwd     string
		CurrentPwd string
	}{}

	decoder := json.NewDecoder(req.Body)
	decoder.Decode(&pwdData)

	err = ChangePassword(pwdData.UserName, pwdData.CurrentPwd, pwdData.NewPwd)

	return
}

func resetPwdRoute(w http.ResponseWriter, req *http.Request) (err error) {
	if req.Method != "POST" {
		return errors.New("Reset password endpoint only accepts POST requests!")
	}

	data := struct {
		UserName string
	}{}

	decoder := json.NewDecoder(req.Body)
	decoder.Decode(&data)

	err = ResetPassword(data.UserName)

	return
}
