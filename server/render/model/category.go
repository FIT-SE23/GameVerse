package model

import (
	"encoding/json"
	"net/http"
	"render/config"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

func AddCategory(c echo.Context, client *supabase.Client) error {
	categoryName := c.FormValue("categoryname")
	isSensitive := c.FormValue("issensitive")

	category := map[string]any{
		"categoryname": categoryName,
		"issensitive":  isSensitive != "",
	}
	_, _, err := client.From("Category").Insert(category, false, "", "", "").ExecuteString()
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	return config.JsonResponse(c, http.StatusOK, "", "")
}

func GetCategories(c echo.Context, client *supabase.Client) error {
	rep, _, err := client.From("Category").Select("", "", false).ExecuteString()
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	var categories []map[string]any
	err = json.Unmarshal([]byte(rep), &categories)
	if err != nil {
		return config.JsonResponse(c, http.StatusInternalServerError, "Failed to get categories", "")
	}
	return config.JsonResponse(c, http.StatusOK, "", categories)
}
