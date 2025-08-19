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

func getPublisherRequests(c echo.Context, client *supabase.Client) error {
	_, err := verifyUserToken(c)
	if err != nil {
		// TODO: check user is operator
		return jsonResponse(c, http.StatusBadRequest, "Please login", "")
	}
	rep, _, err := client.From("Publisher").Select("*", "", false).Eq("isverified", "false").ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error() /*err.Error()*/, "")
	}

	var users []map[string]any
	err = json.Unmarshal([]byte(rep), &users)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, "Could not get requests" /*err.Error()*/, "")
	}
	return jsonResponse(c, http.StatusOK, "", users)
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

	// _, _, err = client.From("User").Update(map[string]string{"type": "publisher"}, "", "").Eq("userid", userid).ExecuteString()
	// if err != nil {
	// 	return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	// }

	return jsonResponse(c, http.StatusOK, "", "")
}

func verifyPublisher(c echo.Context, client *supabase.Client) error {
	_, err := verifyUserToken(c)
	if err != nil {
		// TODO: check user is operator
		return jsonResponse(c, http.StatusBadRequest, "Please login", "")
	}

	publisherid := c.FormValue("publisherid")
	isApprove := c.FormValue("isapprove") == "1"

	if isApprove {
		_, _, err := client.From("Publisher").Update(map[string]bool{"isverified": true}, "", "").Eq("publisherid", publisherid).ExecuteString()
		if err != nil {
			return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
		}
	} else {
		_, _, err := client.From("Publisher").Delete("", "").Eq("publisherid", publisherid).ExecuteString()
		if err != nil {
			return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
		}
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
