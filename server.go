package main

import (
	"flag"
	"log"
	"net/http"
	"os"
)

func main() {
	defer Close()

	flag.Parse()

	// check if an admin user should be created, and if so, if we have all necessary information #######################
	if *createAdminUser == true {
		if adminToBeCreated.UserName != "" && *newAdminPwd != "" {
			if err := StoreUserInDb(&adminToBeCreated, *newAdminPwd); err != nil {
				log.Printf("Could not store new admin user in the database: %v\n", err)
				os.Exit(1)
			}

			os.Exit(0)
		}
	}
	// #################################################################################################################

	mux := http.NewServeMux()

	mux.Handle("/", fileHandler("./dist"))
	mux.Handle("/userInfo", handle(ensureAuth, userInfoRoute))
	mux.Handle("/token", handle(tokenRoute))
	mux.Handle("/logout", handle(logoutRoute))
	mux.Handle("/allUsers", handle(ensureAuth, ensureGroup([]string{"admin"}), allUsersRoute))
	mux.Handle("/updateUser", handle(ensureAuth, ensureGroup([]string{"admin"}), updateUserRoute))
	mux.Handle("/addUser", handle(ensureAuth, ensureGroup([]string{"admin"}), addUserRoute))
	mux.Handle("/deleteUser", handle(ensureAuth, ensureGroup([]string{"admin"}), deleteUserRoute))
	mux.Handle("/changePwd", handle(ensureAuth, changePwdRoute))
	mux.Handle("/resetPwd", handle(ensureAuth, ensureGroup([]string{"admin"}), resetPwdRoute))

	muxWithLogAndUserInfo := addUserInfo(addLog(mux))

	log.Println("Server is about to listen at port 10443.")

	if err := http.ListenAndServeTLS(":10443", "cert.pem", "key.pem", muxWithLogAndUserInfo); err != nil {
		log.Printf("Could not start server at port 10443: %v\n", err)
	}
}
