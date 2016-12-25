package main

import (
	"errors"

	"github.com/boltdb/bolt"
)

var db *bolt.DB

const (
	databaseFile = "data.db"
)

func init() {
	var err error

	db, err = bolt.Open(databaseFile, 0600, nil)

	if err != nil {
		panic(err)
	}
}

// Close the database, e.g. at program exit.
func Close() {
	db.Close()
}

// CreateCollection creates a collection (bucket) in the underlying database if one with the given name collectionName
// doesn't exist yet.
func CreateCollection(collectionName string) error {
	return db.Update(func(tx *bolt.Tx) error {
		_, err := tx.CreateBucketIfNotExists([]byte(collectionName))

		return err
	})
}

// AddDataToCollection adds given data to a collection for a given key. The collection has to exist already.
func AddDataToCollection(collectionName string, key, data []byte) error {
	return db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(collectionName))

		if b == nil {
			return errors.New("The database does not contain a collection named '" + collectionName + "'")
		}

		return b.Put(key, data)
	})
}

// GetDataFromCollection tries to retrieve data from the given collection for the given key.
func GetDataFromCollection(collectionName string, key []byte) (v []byte, err error) {
	err = db.View(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(collectionName))

		if b == nil {
			return errors.New("The database does not contain a collection named '" + collectionName + "'")
		}

		v = b.Get(key)

		if v == nil {
			return errors.New("There is no data for the given key in the database")
		}

		return nil
	})

	return
}

// GetAllDataFromCollection reads all data from the database in a given collection.
func GetAllDataFromCollection(collectionName string) (data map[string][]byte, err error) {
	err = db.View(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(collectionName))

		if b == nil {
			return errors.New("The database does not contain a collection named '" + collectionName + "'")
		}

		c := b.Cursor()

		data = make(map[string][]byte)

		for k, v := c.First(); k != nil; k, v = c.Next() {
			data[string(k)] = v
		}

		return nil
	})

	return
}

// DeleteDataFromCollection deletes data with the given key from the given collection.
func DeleteDataFromCollection(collectionName string, key []byte) error {
	return db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(collectionName))

		if b == nil {
			return errors.New("The database does not contain a collection named '" + collectionName + "'")
		}

		return b.Delete(key)
	})
}
