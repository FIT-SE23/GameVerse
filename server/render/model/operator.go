package model

import (
	"encoding/json"
	"net/http"
	"render/config"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

func GetGameRequests(c echo.Context, client *supabase.Client) error {
	_, err := VerifyUserToken(c)
	if err != nil {
		// TODO: check user is operator
		return config.JsonResponse(c, http.StatusBadRequest, "Please login as operator", "")
	}
	rep, _, err := client.From("Game").Select("*, Category(*), Resource(*)", "", false).Eq("isverified", "false").ExecuteString()
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, err.Error() /*err.Error()*/, "")
	}

	var games []map[string]any
	err = json.Unmarshal([]byte(rep), &games)
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, "Could not get requests" /*err.Error()*/, "")
	}

	return config.JsonResponse(c, http.StatusOK, "", games)
}

func VerifyGame(c echo.Context, client *supabase.Client) error {
	_, err := VerifyUserToken(c)
	if err != nil {
		// TODO: check user is operator
		return config.JsonResponse(c, http.StatusBadRequest, "Please login as operator", "")
	}

	gameid := c.FormValue("gameid")
	isApprove := c.FormValue("isapprove") == "1"

	if isApprove {
		_, _, err := client.From("Game").Update(map[string]bool{"isverified": true}, "", "").Eq("gameid", gameid).ExecuteString()
		if err != nil {
			return config.JsonResponse(c, http.StatusBadRequest, err.Error(), "")
		}
	} else {
		_, _, err := client.From("Game").Delete("", "").Eq("gameid", gameid).ExecuteString()
		if err != nil {
			return config.JsonResponse(c, http.StatusBadRequest, err.Error(), "")
		}
	}
	return config.JsonResponse(c, http.StatusOK, "", "")
}

func GetGameMessage(c echo.Context, client *supabase.Client) error {
	publisherid := c.QueryParam("publisherid")
	rep, _, err := client.From("Game_Message").Select("*", "", false).Eq("publisherid", publisherid).ExecuteString()
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, err.Error() /*err.Error()*/, "")
	}

	var messages []map[string]any
	err = json.Unmarshal([]byte(rep), &messages)
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}
	return config.JsonResponse(c, http.StatusOK, "", messages)
}

func AddGameMessage(c echo.Context, client *supabase.Client) error {
	_, err := VerifyUserToken(c)
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}
	publisherid := c.FormValue("publisherid")
	gamename := c.FormValue("gamename")
	message := c.FormValue("message")

	rep, _, err := client.From("Game_Message").Insert(map[string]string{"publisherid": publisherid, "gamename": gamename, "message": message}, false, "", "", "").ExecuteString()
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, err.Error() /*err.Error()*/, "")
	}

	var messages []map[string]any
	err = json.Unmarshal([]byte(rep), &messages)
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}
	return config.JsonResponse(c, http.StatusOK, "", messages)
}

func GetPublisherMessage(c echo.Context, client *supabase.Client) error {
	userid := c.QueryParam("userid")
	rep, _, err := client.From("Publisher_Message").Select("*", "", false).Eq("userid", userid).ExecuteString()
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, err.Error() /*err.Error()*/, "")
	}

	var messages []map[string]any
	err = json.Unmarshal([]byte(rep), &messages)
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}
	return config.JsonResponse(c, http.StatusOK, "", messages)
}

func AddPublisherMessage(c echo.Context, client *supabase.Client) error {
	_, err := VerifyUserToken(c)
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}
	userid := c.FormValue("userid")
	message := c.FormValue("message")

	rep, _, err := client.From("Publisher_Message").Insert(map[string]string{"userid": userid, "message": message}, false, "", "", "").ExecuteString()
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, err.Error() /*err.Error()*/, "")
	}

	var messages []map[string]any
	err = json.Unmarshal([]byte(rep), &messages)
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}
	return config.JsonResponse(c, http.StatusOK, "", messages)
}

func GetPublisherRequests(c echo.Context, client *supabase.Client) error {
	_, err := VerifyUserToken(c)
	if err != nil {
		// TODO: check user is operator
		return config.JsonResponse(c, http.StatusBadRequest, "Please login as operator", "")
	}
	rep, _, err := client.From("Publisher").
		Select("*, User(username, email), PaymentMethod(*)", "", false).
		Eq("isverified", "false").
		ExecuteString()
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, err.Error() /*err.Error()*/, "")
	}

	var users []map[string]any
	err = json.Unmarshal([]byte(rep), &users)
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, "Could not get requests" /*err.Error()*/, "")
	}
	return config.JsonResponse(c, http.StatusOK, "", users)
}

func VerifyPublisher(c echo.Context, client *supabase.Client) error {
	_, err := VerifyUserToken(c)
	if err != nil {
		// TODO: check user is operator
		return config.JsonResponse(c, http.StatusBadRequest, "Please login as operator", "")
	}

	publisherid := c.FormValue("publisherid")
	isApprove := c.FormValue("isapprove") == "1"

	if isApprove {
		_, _, err := client.From("Publisher").Update(map[string]bool{"isverified": true}, "", "").Eq("publisherid", publisherid).ExecuteString()
		if err != nil {
			return config.JsonResponse(c, http.StatusBadRequest, err.Error(), "")
		}
	} else {
		_, _, err := client.From("Publisher").Delete("", "").Eq("publisherid", publisherid).ExecuteString()
		if err != nil {
			return config.JsonResponse(c, http.StatusBadRequest, err.Error(), "")
		}
	}
	return config.JsonResponse(c, http.StatusOK, "", "")
}
