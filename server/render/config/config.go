package config

import (
	"fmt"
	"runtime"

	"github.com/labstack/echo/v4"
)

func _jsonResponse(c echo.Context, code int, message string, returnVal any) error {
	jsonData := map[string]any{
		"message": message,
		"return":  returnVal,
	}
	return c.JSON(code, jsonData)
}

func JsonResponse(c echo.Context, code int, message string, returnVal any) error {
	_, filename, line, _ := runtime.Caller(1)
	fmt.Println(filename, line)
	return _jsonResponse(c, code, message, returnVal)
}
