package main

import (
	"crypto/rand"
	"encoding/hex"
	"time"

	jwt "github.com/dgrijalva/jwt-go"
)

// secretString defines a secret string used for token generation. Change that to something only you know!!
const secretString = "putyoursecretstringhere"

func generateToken(userInfo *User) ([]byte, string, error) {
	token := jwt.New(jwt.SigningMethodHS256)
	claims := make(jwt.MapClaims)

	claims["exp"] = time.Now().Add(24 * 7 * time.Hour).Unix()
	claims["iat"] = time.Now().Unix()

	id := make([]byte, 32)
	_, err := rand.Read(id)

	if nil != err {
		return nil, "", err
	}

	clientID := hex.EncodeToString(id)

	claims["jti"] = clientID

	claims["userInfo"] = map[string]interface{}{
		"userName":  userInfo.UserName,
		"email":     userInfo.Email,
		"firstName": userInfo.FirstName,
		"lastName":  userInfo.LastName,
		"roles":     userInfo.Roles,
	}

	token.Claims = claims

	tokenString, err := token.SignedString([]byte(secretString))

	return []byte(tokenString), clientID, err
}
