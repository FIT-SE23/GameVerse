package main

import (
	"encoding/json"
	"net/http"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

func getGameRequests(c echo.Context, client *supabase.Client) error {
	_, err := verifyUserToken(c)
	if err != nil {
		// TODO: check user is operator
		return jsonResponse(c, http.StatusBadRequest, "Please login as operator", "")
	}
	rep, _, err := client.From("Game").Select("*, Category(*), Resource(*)", "", false).Eq("isverified", "false").ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error() /*err.Error()*/, "")
	}

	var games []map[string]any
	err = json.Unmarshal([]byte(rep), &games)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, "Could not get requests" /*err.Error()*/, "")
	}

	return jsonResponse(c, http.StatusOK, "", games)
}

func verifyGame(c echo.Context, client *supabase.Client) error {
	_, err := verifyUserToken(c)
	if err != nil {
		// TODO: check user is operator
		return jsonResponse(c, http.StatusBadRequest, "Please login as operator", "")
	}

	gameid := c.FormValue("gameid")
	isApprove := c.FormValue("isapprove") == "1"

	if isApprove {
		_, _, err := client.From("Game").Update(map[string]bool{"isverified": true}, "", "").Eq("gameid", gameid).ExecuteString()
		if err != nil {
			return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
		}
	} else {
		_, _, err := client.From("Game").Delete("", "").Eq("gameid", gameid).ExecuteString()
		if err != nil {
			return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
		}
	}
	return jsonResponse(c, http.StatusOK, "", "")
}

func getGameMessage(c echo.Context, client *supabase.Client) error {
	publisherid := c.QueryParam("publisherid")
	rep, _, err := client.From("Game_Message").Select("*", "", false).Eq("publisherid", publisherid).ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error() /*err.Error()*/, "")
	}

	var messages []map[string]any
	err = json.Unmarshal([]byte(rep), &messages)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}
	return jsonResponse(c, http.StatusOK, "", messages)
}

func addGameMessage(c echo.Context, client *supabase.Client) error {
	publisherid, err := verifyUserToken(c)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}
	gamename := c.FormValue("gamename")
	message := c.FormValue("message")

	rep, _, err := client.From("Game_Message").Insert(map[string]string{"publisherid": publisherid, "gamename": gamename, "message": message}, false, "", "", "").ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error() /*err.Error()*/, "")
	}

	var messages []map[string]any
	err = json.Unmarshal([]byte(rep), &messages)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}
	return jsonResponse(c, http.StatusOK, "", messages)
}

func getPublisherMessage(c echo.Context, client *supabase.Client) error {
	userid := c.QueryParam("userid")
	rep, _, err := client.From("Publisher_Message").Select("*", "", false).Eq("userid", userid).ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error() /*err.Error()*/, "")
	}

	var messages []map[string]any
	err = json.Unmarshal([]byte(rep), &messages)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}
	return jsonResponse(c, http.StatusOK, "", messages)
}

func addPublisherMessage(c echo.Context, client *supabase.Client) error {
	userid, err := verifyUserToken(c)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}
	message := c.FormValue("message")

	rep, _, err := client.From("Publisher_Message").Insert(map[string]string{"userid": userid, "message": message}, false, "", "", "").ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error() /*err.Error()*/, "")
	}

	var messages []map[string]any
	err = json.Unmarshal([]byte(rep), &messages)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}
	return jsonResponse(c, http.StatusOK, "", messages)
}

func getPublisherRequests(c echo.Context, client *supabase.Client) error {
	_, err := verifyUserToken(c)
	if err != nil {
		// TODO: check user is operator
		return jsonResponse(c, http.StatusBadRequest, "Please login as operator", "")
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

func verifyPublisher(c echo.Context, client *supabase.Client) error {
	_, err := verifyUserToken(c)
	if err != nil {
		// TODO: check user is operator
		return jsonResponse(c, http.StatusBadRequest, "Please login as operator", "")
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
