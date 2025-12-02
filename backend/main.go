package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"

	_ "github.com/joho/godotenv/autoload"
	_ "modernc.org/sqlite"

	"github.com/pressly/goose/v3"
)

var DB *sql.DB

func main() {
	// connect to db
	db, err := sql.Open("sqlite", os.Getenv("DB"))
	if err != nil {
		log.Fatalf("%s", err.Error())
	}
	defer func() {
		if closeError := db.Close(); closeError != nil {
			fmt.Println("Error closing database", closeError)
			if err == nil {
				err = closeError
			}
		}
	}()

	DB = db

	// migrate to database
	goose.SetDialect("sqlite3")

	// Apply all "up" migrations
	err = goose.Up(DB, "migrations")
	if err != nil {
		log.Fatalf("Failed to auth apply migrations: %v", err)
	}

	log.Println("Migrations applied successfully!")
}
