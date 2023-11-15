package profile

import (
	"lognolog/logger"
	"net/http"
	"runtime"

	"github.com/gin-gonic/gin"
)

func Log(c *gin.Context) {
	var req AuditLog
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": err.Error(),
		})
		return
	}

	logger.InfoObject(req)
}
