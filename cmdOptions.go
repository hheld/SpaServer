package main

import (
	"flag"
)

var adminToBeCreated = User{
	Roles: []string{"admin", "user"},
}

var (
	createAdminUser = flag.Bool("createAdmin", false, "Create a new admin user in the database.")
	newAdminPwd     = flag.String("pwd", "", "Password for the new admin user.")
)

func init() {
	flag.StringVar(&adminToBeCreated.FirstName, "firstName", "", "First name of the new admin user to be created.")
	flag.StringVar(&adminToBeCreated.LastName, "lastName", "", "Last name of the new admin user to be created.")
	flag.StringVar(&adminToBeCreated.UserName, "userName", "", "User name of the new admin user to be created.")
	flag.StringVar(&adminToBeCreated.Email, "email", "", "Email of the new admin user to be created.")
}
