package main

import (
	"net/http"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

func addCategory(c echo.Context, client *supabase.Client) error {
	categoryName := c.FormValue("categoryname")
	isSensitive := c.FormValue("issensitive")

	category := map[string]any{
		"categoryname": categoryName,
		"issensitive":  isSensitive != "",
	}
	_, _, err := client.From("Category").Insert(category, false, "", "", "").ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	return jsonResponse(c, http.StatusOK, "", "")
}
