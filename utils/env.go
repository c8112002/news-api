package utils

import (
	"github.com/joho/godotenv"
	"os"
)

type Env int

const (
	Development Env = iota
	Production
)

var AppEnv Env

func Init() error {
	if err := loadEnv(); err != nil {
		return err
	}

	setEnv()

	return nil
}

func loadEnv() error {

	env := os.Getenv("APP_ENV")
	if "" == env {
		env = "development"
	}

	_ = godotenv.Load(".env." + env + ".local")
	if "test" != env {
		_ = godotenv.Load(".env.local")
	}
	_ = godotenv.Load(".env." + env)
	_ = godotenv.Load() // The Original .env

	return nil
}

func setEnv() {
	switch os.Getenv("APP_ENV") {
	case "development":
		AppEnv = Development
	default:
		AppEnv = Production
	}
}

