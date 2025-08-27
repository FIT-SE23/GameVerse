package model

import (
	"encoding/json"
	"fmt"
	"net/http"
	"render/config"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

// Function to get all forums Ids
func GetAllForums(c echo.Context, client *supabase.Client) error {
	rep, _, err := client.
		From("Forum").
		Select("forumid, Game!inner(isverified)", "", false).
		Eq("Game.isverified", "true").
		ExecuteString()
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	var forums []map[string]any
	err = json.Unmarshal([]byte(rep), &forums)
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, "Invalid forums" /*err.Error()*/, "")
	}
	return config.JsonResponse(c, http.StatusOK, "", forums)
}

func GetForum(c echo.Context, client *supabase.Client) error {
	columns := "gameid, name, briefdescription, Resource(url, type)"

	gameID := c.Param("id")

	// TODO: check game status if user already signed in
	filter := client.From("Game").Select(columns, "", false).Eq("gameid", gameID).Eq("isverified", "true").In("Resource.type", []string{"media_header"})
	rep, _, err := filter.ExecuteString()
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}
	var gameBasicInfo []map[string]any
	err = json.Unmarshal([]byte(rep), &gameBasicInfo)
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, "Invalid gameid or the return value datatype does not match with gameBasicInfo datatype" /*err.Error()*/, "")
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
	fmt.Println(gameBasicInfo)

	return config.JsonResponse(c, http.StatusOK, "", gameBasicInfo)
}
