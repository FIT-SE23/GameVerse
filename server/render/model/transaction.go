package model

import (
	"encoding/json"
	"net/http"
	"render/config"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

func GetTransactions(c echo.Context, client *supabase.Client, userid string) error {
	rep, _, err := client.From("Transaction").Select("", "", false).Eq("senderid", userid).ExecuteString()
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	var transactions []map[string]any
	err = json.Unmarshal([]byte(rep), &transactions)
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	return config.JsonResponse(c, http.StatusOK, "", transactions)
}
