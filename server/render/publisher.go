package main

import (
	"encoding/json"
	"net/http"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

func getPublisher(c echo.Context, client *supabase.Client) error {
	publisherid := c.Param("id")

	rep, _, err := client.From("Publisher").Select("description, Game(*)", "", false).Eq("publisherid", publisherid).Single().ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	var user map[string]any
	err = json.Unmarshal([]byte(rep), &user)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, "Invalid publisherid" /*err.Error()*/, "")
	}
	return jsonResponse(c, http.StatusOK, "", user)
}

func addPublisher(c echo.Context, client *supabase.Client) error {
	userID := c.FormValue("userid")
	paymentMethodID := c.FormValue("paymentmethodid")
	description := c.FormValue("description")

	publisher := map[string]string{
		"publisherid":     userID,
		"paymentmethodid": paymentMethodID,
		"description":     description,
	}
	_, _, err := client.From("Publisher").Insert(publisher, false, "", "", "").ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	return jsonResponse(c, http.StatusOK, "", "")
}
