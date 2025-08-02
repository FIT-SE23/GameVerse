package main

import (
	"encoding/json"
	"fmt"
	"mime/multipart"
	"net/http"
	"slices"
	"strings"
	"time"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

func addResources(c echo.Context, client *supabase.Client, userID string, gameID string, bucketId string, files []*multipart.FileHeader, resourceType string) []string {
	errFiles := []string{}
	for _, file := range files {
		src, err := file.Open()
		if err != nil {
			errFiles = append(errFiles, file.Filename)
			fmt.Println("Read file failed", file.Filename, err)
			continue
		}
		defer src.Close()

		filepath := userID + "/res/" + strings.ReplaceAll(time.Now().UTC().Format(time.RFC3339), ":", "-") + file.Filename
		_, uplErr := client.Storage.UploadFile(bucketId, filepath, src)
		if uplErr != nil {
			errFiles = append(errFiles, file.Filename)
			fmt.Println("Upload failed", file.Filename, uplErr)
			continue
		}

		signedURL, err := client.Storage.CreateSignedUrl(bucketId, filepath, 365*24*60*60)
		if err != nil {
			errFiles = append(errFiles, file.Filename)
			fmt.Println("Create signed url failed", file.Filename, err)
			continue
		}

		resource := map[string]string{
			"userid": userID,
			"url":    signedURL.SignedURL,
			"type":   resourceType,
		}
		_, _, err = client.From("Resource").Insert(resource, false, "", "", "").ExecuteString()
		if err != nil {
			fmt.Println("Insert into Resource table failed", file.Filename, err)
			errFiles = append(errFiles, file.Filename)
			continue
		}

		rep, _, err := client.From("Resource").Select("resourceid", "", false).Eq("url", resource["url"]).Single().ExecuteString()
		if err != nil {
			fmt.Println("Select from Resource table failed", file.Filename, err)
			errFiles = append(errFiles, file.Filename)
			continue
		}
		var resourceid map[string]any
		err = json.Unmarshal([]byte(rep), &resourceid)
		if err != nil {
			fmt.Println("Resource uploaded but database does not return the id", err.Error())
			errFiles = append(errFiles, file.Filename)
			continue
		}
		gameResource := map[string]any{
			"gameid":     gameID,
			"resourceid": resourceid["resourceid"],
		}
		_, _, err = client.From("Game_Resource").Insert(gameResource, false, "", "", "").ExecuteString()
		if err != nil {
			fmt.Println("Insert into Game_Resource table failed", file.Filename, err)
			errFiles = append(errFiles, file.Filename)
		}
	}

	return errFiles
}

func addGame(c echo.Context, client *supabase.Client, bucketId string) error {
	publisherID := c.FormValue("publisherid")
	if publisherID == "" {
		return jsonResponse(c, http.StatusBadRequest, "Require publisherID", "")
	}

	// TODO: Check game's name length
	gameName := c.FormValue("gamename")
	description := c.FormValue("description")

	game := map[string]string{
		"publisherid": publisherID,
		"name":        gameName,
		"description": description,
	}
	_, _, err := client.From("Game").Insert(game, false, "", "", "").ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}
	rep, _, err := client.From("Game").Select("gameid", "", false).Eq("publisherid", publisherID).Eq("name", gameName).Single().ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}
	var gameID map[string]string
	err = json.Unmarshal([]byte(rep), &gameID)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, "Game uploaded but database does not return the id" /*err.Error()*/, "")
	}
	userID := publisherID

	// https://echo.labstack.com/docs/cookbook/file-upload
	form, err := c.MultipartForm()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	files := form.File["binary"]
	errFiles := addResources(c, client, userID, gameID["gameid"], bucketId, files, "binary")
	if len(errFiles) > 0 {
		return jsonResponse(c, http.StatusBadRequest, "Upload failed. Maybe the files do not exist or have been added or cannot link gameid with resourceid", errFiles)
	}

	files = form.File["media"]
	errFiles = addResources(c, client, userID, gameID["gameid"], bucketId, files, "media")
	if len(errFiles) > 0 {
		return jsonResponse(c, http.StatusBadRequest, "Upload failed. Maybe the files do not exist or have been added or cannot link gameid with resourceid", errFiles)
	}

	files = form.File["executable"]
	errFiles = addResources(c, client, userID, gameID["gameid"], bucketId, files, "executable")
	if len(errFiles) > 0 {
		return jsonResponse(c, http.StatusBadRequest, "Upload failed. Maybe the files do not exist or have been added or cannot link gameid with resourceid", errFiles)
	}

	rep, _, err = client.From("Category").Select("", "", false).ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}
	var knownCategories []map[string]any
	err = json.Unmarshal([]byte(rep), &knownCategories)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	categories := strings.Split(c.FormValue("categories"), ",")
	errCat := []string{}

	for _, category := range categories {
		index := slices.IndexFunc(knownCategories, func(knownCategory map[string]any) bool {
			return knownCategory["categoryname"] == category
		})
		if index == -1 {
			errCat = append(errCat, category)
			continue
		}

		pair := map[string]any{
			"gameid":     gameID["gameid"],
			"categoryid": knownCategories[index]["categoryid"],
		}

		_, _, err = client.From("Game_Category").Insert(pair, true, "", "", "").ExecuteString()
		if err != nil {
			errCat = append(errCat, category)
			continue
		}
	}

	if len(errCat) > 0 {
		return jsonResponse(c, http.StatusBadRequest, "Unknown categories", errCat)
	}

	forum := map[string]string{
		"forumid": gameID["gameid"],
	}
	_, _, err = client.From("Forum").Insert(forum, false, "", "", "").ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	return jsonResponse(c, http.StatusOK, "", "")
}

func getGame(c echo.Context, client *supabase.Client) error {
	fmt.Println(c.Response().Header())
	// userid := c.Get("userid").(*jwt.Token)
	// claims := userid.Claims.(jwt.MapClaims)
	gameID := c.Param("id")
	// userid := c.Param("id")

	// TODO: check game status if user already signed in
	rep, _, err := client.From("Game").Select("publisherid, name, description, Category(categoryname), Resource(url, type)", "", false).Eq("gameid", gameID).ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}
	var gameBasicInfo []map[string]any
	err = json.Unmarshal([]byte(rep), &gameBasicInfo)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, "Invalid gameid or the return value datatype does not match with gameBasicInfo datatype" /*err.Error()*/, "")
	}

	return jsonResponse(c, http.StatusOK, "", gameBasicInfo)
}

func searchGames(c echo.Context, client *supabase.Client) error {
	gamename := c.QueryParam("gamename")
	rep, _, err := client.From("Game").Select("*, Category(categoryname), Resource(url)", "", false).Like("name", "%"+gamename+"%").ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}
	var games []map[string]any
	err = json.Unmarshal([]byte(rep), &games)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	return jsonResponse(c, http.StatusOK, "", games)
}
