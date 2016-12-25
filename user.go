package main

import (
	"bytes"
	"crypto/sha1"
	"encoding/gob"
	"errors"

	"golang.org/x/crypto/bcrypt"
)

const userCollection = "users"

// User defines the type of user information that is stored in the database.
type User struct {
	FirstName string
	LastName  string
	UserName  string // This has to be unique
	Email     string
	Roles     []string
}

type user struct {
	User
	ID           []byte // This is sha1 sum of UserName
	PasswordHash []byte
}

func (u *user) encode() (data []byte, err error) {
	var buf bytes.Buffer

	enc := gob.NewEncoder(&buf)

	err = enc.Encode(*u)
	data = buf.Bytes()

	return
}

func (u *user) decode(data []byte) error {
	buf := bytes.NewBuffer(data)
	dec := gob.NewDecoder(buf)

	return dec.Decode(u)
}

func init() {
	if err := CreateCollection(userCollection); err != nil {
		panic("Could not create collection '" + userCollection + "' in the database.")
	}
}

// GetUserID returns the given user's ID that is used in the database.
func GetUserID(u *User) []byte {
	return GetUserIDFromName(u.UserName)
}

// GetUserIDFromName returns the user's ID from its user name.
func GetUserIDFromName(userName string) []byte {
	id := sha1.Sum([]byte(userName))
	return id[:]
}

// StoreUserInDb stores a given user in the database.
func StoreUserInDb(u *User, password string) error {
	hashedPwd, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)

	if err != nil {
		return err
	}

	userInfo := user{
		User: User{
			FirstName: u.FirstName,
			LastName:  u.LastName,
			UserName:  u.UserName,
			Email:     u.Email,
			Roles:     u.Roles,
		},
	}

	userInfo.PasswordHash = hashedPwd
	userInfo.ID = GetUserID(u)

	// Check if there already is a user with this ID in the database
	v, _ := GetDataFromCollection(userCollection, userInfo.ID)

	if v != nil {
		return errors.New("There already is a user with the name '" + u.UserName + "' in the database.")
	}

	userData, err := userInfo.encode()

	if err != nil {
		return err
	}

	return AddDataToCollection(userCollection, userInfo.ID, userData)
}

// UpdateData updates data of an existing user in the database.
func UpdateData(oldData, newData *User) error {
	// check if the username is supposed to be changed ... that only works if the new user name doesn't exist already in the db
	if oldData.UserName != newData.UserName {
		rawData, _ := GetDataFromCollection(userCollection, GetUserID(newData))

		if rawData != nil {
			return errors.New("Could not update user data since the desired new user name already exists.")
		}

		// now the user name changes and the new name is OK, i.e. unique
		rawData, _ = GetDataFromCollection(userCollection, GetUserID(oldData))
		err := DeleteDataFromCollection(userCollection, GetUserID(oldData))

		if err != nil {
			return err
		}

		var u user
		err = u.decode(rawData)

		if err != nil {
			return err
		}

		u.User = *newData
		uRaw, err := u.encode()

		if err != nil {
			return err
		}

		err = AddDataToCollection(userCollection, GetUserID(&u.User), uRaw)

		if err != nil {
			return err
		}

		return nil
	}

	// in this case, the user name remains the same, we just have to update the data
	rawData, _ := GetDataFromCollection(userCollection, GetUserID(oldData))

	if rawData == nil {
		return errors.New("Could not find the old data in the database")
	}

	var userInfo user
	userInfo.decode(rawData)
	userInfo.User = *newData

	rawData, err := userInfo.encode()

	if err != nil {
		return errors.New("Could not encode user object")
	}

	return AddDataToCollection(userCollection, GetUserID(&userInfo.User), rawData)
}

// GetAllUsersInDb returns all users contained in the database.
func GetAllUsersInDb() (data []User, err error) {
	allRawUsers, err := GetAllDataFromCollection(userCollection)

	if err != nil {
		return
	}

	data = make([]User, len(allRawUsers))

	i := 0

	for _, rawUser := range allRawUsers {
		var u user
		err = u.decode(rawUser)

		if err != nil {
			return
		}

		data[i] = u.User

		i++
	}

	return
}

// ValidateUser checks if a given user exists in the database and if its password matches.
func ValidateUser(u *User, password string) (validated bool, err error) {
	rawUser, err := GetDataFromCollection(userCollection, GetUserID(u))

	if err != nil {
		return false, errors.New("Could not find user '" + u.UserName + "' in the database.")
	}

	var userInfo user
	userInfo.decode(rawUser)

	err = bcrypt.CompareHashAndPassword(userInfo.PasswordHash, []byte(password))

	validated = err == nil

	return
}

//GetUser looks for a user with the given user name in the database and returns the corresponding user information.
func GetUser(userName string) (userInfo *User, err error) {
	rawUserData, err := GetDataFromCollection(userCollection, GetUserIDFromName(userName))

	var u user
	err = u.decode(rawUserData)

	if err != nil {
		return
	}

	userInfo = &u.User

	return
}

func getRawUser(userName string) (userInfo *user, err error) {
	rawUserData, err := GetDataFromCollection(userCollection, GetUserIDFromName(userName))

	userInfo = new(user)
	err = userInfo.decode(rawUserData)

	return
}

// DeleteUser deletes a user from the database.
func DeleteUser(userName string) error {
	return DeleteDataFromCollection(userCollection, GetUserIDFromName(userName))
}

// ChangePassword changes the given user's password, if the given old password is correct.
func ChangePassword(userName, oldPassword, newPassword string) error {
	u, err := getRawUser(userName)

	if err != nil {
		return err
	}

	ok, err := ValidateUser(&u.User, oldPassword)

	if err != nil {
		return err
	}

	if ok == false {
		return errors.New("The given old password is not correct for the desired user")
	}

	hashedPwd, err := bcrypt.GenerateFromPassword([]byte(newPassword), bcrypt.DefaultCost)

	if err != nil {
		return err
	}

	u.PasswordHash = hashedPwd

	updatedRawUser, err := u.encode()

	if err != nil {
		return err
	}

	return AddDataToCollection(userCollection, GetUserID(&u.User), updatedRawUser)
}
