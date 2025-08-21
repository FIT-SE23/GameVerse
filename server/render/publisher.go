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

	rep, _, err := client.From("Publisher").Select("*", "", false).Eq("publisherid", publisherid).Single().ExecuteString()
	fmt.Println(rep)
	var publisher map[string]any
	err = json.Unmarshal([]byte(rep), &publisher)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, "Invalid publisherid", "")
	}
	publisher["game"] = []any{}

	rep, _, err = client.From("Game").Select("*, Category(*), Resource(*)", "", false).Eq("publisherid", publisherid).ExecuteString()
	if err == nil {
		var games []map[string]any
		err = json.Unmarshal([]byte(rep), &games)
		if err != nil {
			return jsonResponse(c, http.StatusBadRequest, "Invalid publisherid" /*err.Error()*/, "")
		}
		publisher["game"] = games
	}

	return jsonResponse(c, http.StatusOK, "", publisher)
}

func addPublisher(c echo.Context, client *supabase.Client) error {
	userid, err := verifyUserToken(c)
	if err != nil {
		fmt.Println(err.Error())
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}
	paymentMethodID := c.FormValue("paymentmethodid")
	description := c.FormValue("description")
	paymentCadtNumber := c.FormValue("paymentcardnumber")

	publisher := map[string]any{
		"publisherid":       userid,
		"paymentmethodid":   paymentMethodID,
		"description":       description,
		"paymentcardnumber": paymentCadtNumber,
		"isverified":        false,
	}
	_, _, err = client.From("Publisher").Insert(publisher, false, "", "", "").ExecuteString()
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
	paymentCardNumber := c.FormValue("paymentcardnumber")
	isVerified := c.FormValue("isverified")

	if paymentMethodID == "" && description == "" && paymentCardNumber == "" && isVerified == "" {
		return jsonResponse(c, http.StatusBadRequest, "Nothing to update", "")
	}

	updates := map[string]any{}
	if paymentMethodID != "" {
		updates["paymentmethodid"] = paymentMethodID
	}
	if description != "" {
		updates["description"] = description
	}
	if paymentCardNumber != "" {
		updates["paymentcardnumber"] = paymentCardNumber
	}
	if isVerified != "" {
		updates["isverified"] = isVerified == "1"
	}

	_, _, err = client.From("Publisher").Update(updates, "", "").Eq("publisherid", publisherID).ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	return jsonResponse(c, http.StatusOK, "", "")
}
