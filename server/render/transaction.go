package main

import (
	"encoding/json"
	"net/http"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

func getTransactions(c echo.Context, client *supabase.Client, userid string) error {
	rep, _, err := client.From("Transaction").Select("", "", false).Eq("senderid", userid).ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	var transactions []map[string]any
	err = json.Unmarshal([]byte(rep), &transactions)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	return jsonResponse(c, http.StatusOK, "", transactions)
}
