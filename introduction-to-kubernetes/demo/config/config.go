package config

import (
	"encoding/json"
	"fmt"
	"os"
	"time"

	"github.com/gin-gonic/gin"
)

type CustomConfig struct {
	LogMiddlewareFormatter string
}

// custom formatter based on gin.defaultLogFormatter
var defaultCustomLogFormatter = func(param gin.LogFormatterParams) string {

	var statusColor, methodColor, resetColor string
	if param.IsOutputColor() {
		statusColor = param.StatusCodeColor()
		methodColor = param.MethodColor()
		resetColor = param.ResetColor()
	}

	if param.Latency > time.Minute {
		// Truncate in a golang < 1.8 safe way
		param.Latency = param.Latency - param.Latency%time.Second
	}

	if os.Getenv("LOG_LEVEL") == "DEBUG" {
		return fmt.Sprintf("[DEBUG] %v |%s %3d %s| %13v | %15s |%s %-7s %s %#v\n%s",
			param.TimeStamp.Format("2006/01/02 - 15:04:05"),
			statusColor, param.StatusCode, resetColor,
			param.Latency,
			param.ClientIP,
			methodColor, param.Method, resetColor,
			param.Path,
			param.ErrorMessage,
		)
	} else if os.Getenv("LOG_LEVEL") == "INFO" {
		return fmt.Sprintf("[INFO] %v |%s %3d %s| %15s | %-7s %#v\n",
			param.TimeStamp.Format("2006/01/02 - 15:04:05"),
			statusColor, param.StatusCode, resetColor,
			param.ClientIP,
			param.Method,
			param.Path,
		)
	} else {
		// We assume default is WARN
		return fmt.Sprintf("[WARN] %v | %3d\n",
			param.TimeStamp.Format("2006/01/02 - 15:04:05"),
			param.StatusCode,
		)

	}
}

func NewRouter() *gin.Engine {
	file, err := os.ReadFile(os.Getenv("CONFIG_PATH"))

	configMap := map[string]gin.LogFormatter{
		"defaultCustomLogFormatter": defaultCustomLogFormatter,
	}
	data := CustomConfig{}

	_ = json.Unmarshal(file, &data)

	// gin router used by application
	var newRouter *gin.Engine

	if err != nil {
		newRouter = gin.Default()
	} else {
		newRouter = gin.New()

		// Set logger
		newRouter.Use(gin.LoggerWithFormatter(configMap[data.LogMiddlewareFormatter]))
		// newRouter.Use(gin.LoggerWithFormatter(defaultCustomLogFormatter))

		newRouter.Use(gin.Recovery())
	}

	return newRouter
}
