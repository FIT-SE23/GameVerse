package main

import (
	"encoding/json"
	"net/http"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

// Function to get all forums Ids
func getAllForums(c echo.Context, client *supabase.Client) error {
	rep, _, err := client.
		From("Forum").
		Select("forumid", "", false).
		ExecuteString()

	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	var forums []map[string]any
	err = json.Unmarshal([]byte(rep), &forums)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, "Invalid forums" /*err.Error()*/, "")
	}
	return jsonResponse(c, http.StatusOK, "", forums)
}

func getForum(c echo.Context, client *supabase.Client) error {
	columns := "gameid, name, briefdescription, Resource(url, type)"

	gameID := c.Param("id")

	// TODO: check game status if user already signed in
	filter := client.From("Game").Select(columns, "", false).Eq("gameid", gameID).In("Resource.type", []string{"media_header"})
	rep, _, err := filter.ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}
	var gameBasicInfo []map[string]any
	err = json.Unmarshal([]byte(rep), &gameBasicInfo)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, "Invalid gameid or the return value datatype does not match with gameBasicInfo datatype" /*err.Error()*/, "")
	}

	// Change the resource in gameBasicInfo to a name header image and delete the resource field
	for i := range gameBasicInfo {
		if len(gameBasicInfo[i]["Resource"].([]any)) > 0 {
			gameBasicInfo[i]["headerimage"] = gameBasicInfo[i]["Resource"].([]any)[0].(map[string]any)["url"]
		} else {
			gameBasicInfo[i]["headerimage"] = ""
		}
		delete(gameBasicInfo[i], "Resource")
	}

	return jsonResponse(c, http.StatusOK, "", gameBasicInfo)
}
