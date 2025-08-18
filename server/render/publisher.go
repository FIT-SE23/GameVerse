package main

import (
	"encoding/json"
	"fmt"
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
	userid, err := verifyUserToken(c)
	if err != nil {
		fmt.Println(err.Error())
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}
	paymentMethodID := c.FormValue("paymentmethodid")
	description := c.FormValue("description")

	publisher := map[string]string{
		"publisherid":     userid,
		"paymentmethodid": paymentMethodID,
		"description":     description,
	}
	_, _, err = client.From("Publisher").Insert(publisher, false, "", "", "").ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	_, _, err = client.From("User").Update(map[string]string{"type": "publisher"}, "", "").Eq("userid", userid).ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	return jsonResponse(c, http.StatusOK, "", "")
}

func updatePublisher(c echo.Context, client *supabase.Client) error {
	publisherID := c.Param("id")

	_, _, err := client.From("Publisher").Select("publisherid", "", false).Eq("publisherid", publisherID).Single().ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	paymentMethodID := c.FormValue("paymentmethodid")
	description := c.FormValue("description")

	if paymentMethodID == "" && description == "" {
		return jsonResponse(c, http.StatusBadRequest, "Nothing to update", "")
	}

	updates := map[string]any{}
	if paymentMethodID != "" {
		updates["paymentmethodid"] = paymentMethodID
	}
	if description != "" {
		updates["description"] = description
	}

	_, _, err = client.From("Publisher").Update(updates, "", "").Eq("publisherid", publisherID).ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	return jsonResponse(c, http.StatusOK, "", "")
}
