package main

import (
	"lognolog/logger"
	"lognolog/profile"

	"github.com/gin-gonic/gin"
)

func main() {
	logger.New()

	r := gin.New()
	r.POST("/logs", profile.Log)

	r.Run()
}
