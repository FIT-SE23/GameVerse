package main

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"io"
	"math"
	"mime/multipart"
	"net/http"
	"slices"
	"sort"
	"strconv"
	"strings"
	"time"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/postgrest-go"
	"github.com/supabase-community/supabase-go"
)

func addResources(client *supabase.Client, userID string, gameID string, bucketId string, files []*multipart.FileHeader, resourceType string) []string {
	errFiles := []string{}
	h := sha256.New()
	for _, file := range files {
		src, err := file.Open()
		if err != nil {
			errFiles = append(errFiles, file.Filename)
			fmt.Println("Read file failed", file.Filename, err)
			continue
		}
		defer src.Close()
		if _, err := io.Copy(h, src); err != nil {
			errFiles = append(errFiles, file.Filename)
			fmt.Println("Calculate checksum", err)
			continue
		}

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
			"userid":   userID,
			"url":      signedURL.SignedURL,
			"type":     resourceType,
			"checksum": hex.EncodeToString(h.Sum(nil)),
		}
		h.Reset()
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

func deleteResources(client *supabase.Client, bucketId string, resourceIDs []string) []string {
	var errorResources []string
	var toDelete []string

	rep, _, err := client.From("Resource").Select("resourceid, url", "", false).In("resourceid", resourceIDs).ExecuteString()
	if err != nil {
		fmt.Println("Error: Could not fetch resource data:", err)
		return resourceIDs
	}

	var resources []map[string]string
	if err := json.Unmarshal([]byte(rep), &resources); err != nil {
		fmt.Println("Error: Could not parse resource data:", err)
		return resourceIDs
	}

	resourceURLMap := make(map[string]string)
	for _, res := range resources {
		resourceURLMap[res["resourceid"]] = res["url"]
	}

	for _, resID := range resourceIDs {
		urlStr, ok := resourceURLMap[resID]
		if !ok {
			fmt.Println("Warning: Resource not found in database: ", resID)
			errorResources = append(errorResources, resID)
			continue
		}

		prefix := "/storage/v1/object/sign/" + bucketId + "/"
		pathIndex := strings.Index(urlStr, prefix)
		if pathIndex == -1 {
			fmt.Println("Error: Invalid URL format for resource: ", resID)
			errorResources = append(errorResources, resID)
			continue
		}

		pathWithQuery := urlStr[pathIndex+len(prefix):]
		filePath := pathWithQuery
		if queryIndex := strings.Index(pathWithQuery, "?"); queryIndex != -1 {
			filePath = pathWithQuery[:queryIndex]
		}
		_, err := client.Storage.RemoveFile(bucketId, []string{filePath})
		if err != nil {
			fmt.Printf("Error: Failed to delete file %s from storage: %v\n", filePath, err)
			errorResources = append(errorResources, resID)
			continue
		}

		toDelete = append(toDelete, resID)
	}

	if len(toDelete) > 0 {
		_, _, err := client.From("Resource").Delete("", "").In("resourceid", toDelete).Execute()
		if err != nil {
			fmt.Println("Error: Files deleted from storage, but not in database:", err)
			errorResources = append(errorResources, toDelete...)
		} else {
			fmt.Println("Successfully deleted from database:", toDelete)
		}
	}

	return errorResources
}

func addGame(c echo.Context, client *supabase.Client, bucketId string) error {
	userid, err := verifyUserToken(c)
	if err != nil {
		fmt.Println(err.Error())
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}
	publisherID := userid
	if publisherID == "" {
		return jsonResponse(c, http.StatusBadRequest, "Require publisherID", "")
	}

	// TODO: Check game's name length
	gameName := c.FormValue("gamename")
	description := c.FormValue("description")
	price := c.FormValue("price")

	game := map[string]string{
		"publisherid": publisherID,
		"name":        gameName,
		"description": description,
		"price":       price,
	}
	_, _, err = client.From("Game").Insert(game, false, "", "", "").ExecuteString()
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
	errFiles := addResources(client, userID, gameID["gameid"], bucketId, files, "binary")
	if len(errFiles) > 0 {
		return jsonResponse(c, http.StatusBadRequest, "Upload failed. Maybe the files do not exist or have been added or cannot link gameid with resourceid", errFiles)
	}

	files = form.File["media"]
	errFiles = addResources(client, userID, gameID["gameid"], bucketId, files, "media")
	if len(errFiles) > 0 {
		return jsonResponse(c, http.StatusBadRequest, "Upload failed. Maybe the files do not exist or have been added or cannot link gameid with resourceid", errFiles)
	}

	files = form.File["media_header"]
	errFiles = addResources(client, userID, gameID["gameid"], bucketId, files, "media_header")
	if len(errFiles) > 0 {
		return jsonResponse(c, http.StatusBadRequest, "Upload failed. Maybe the files do not exist or have been added or cannot link gameid with resourceid", errFiles)
	}

	files = form.File["executable"]
	errFiles = addResources(client, userID, gameID["gameid"], bucketId, files, "executable")
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
	columns := "*, Category(categoryname), Resource(url, type), Game_Sale(*)"
	_, err := verifyUserToken(c)
	if err == nil {
		columns += ", User_Game(status)"
	}

	gameID := c.Param("id")

	// TODO: check game status if user already signed in
	filter := client.From("Game").Select(columns, "", false).Eq("gameid", gameID).In("Resource.type", []string{"media_header", "media"})
	rep, _, err := filter.ExecuteString()
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
	sortBy := c.QueryParam("sortby")
	limit, err := strconv.Atoi(c.QueryParam("limit"))
	if err != nil {
		limit = 0
		err = nil
	}

	filter := client.From("Game").Select("*, Category(categoryname), Resource(url, type), Game_Sale(*)", "", false).Like("name", "%"+gamename+"%").In("Resource.type", []string{"media_header", "media"}).Limit(limit, "")

	var rep string
	if sortBy == "price" {
		limit := map[string]int{
			"lim": limit,
		}
		rep = client.Rpc("sortgamebyprice", "", limit)
		var raw []map[string]string
		err = json.Unmarshal([]byte(rep), &raw)
		if err != nil {
			return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
		}

		gameids := []string{}
		for _, info := range raw {
			gameids = append(gameids, info["gameid"])
		}
		rep, _, err = client.From("Game").Select("*, Category(categoryname), Resource(url, type), Game_Sale(*)", "", false).In("gameid", gameids).In("Resource.type", []string{"media_header", "media"}).ExecuteString()
		// return jsonResponse(c, http.StatusOK, "", resp)
	} else if sortBy == "date" {
		rep, _, err = filter.Order("releasedate", &postgrest.OrderOpts{Ascending: false}).ExecuteString()
	} else if sortBy == "recommend" {
		rep, _, err = filter.Order("recommend", &postgrest.OrderOpts{Ascending: false}).ExecuteString()
	} else {
		rep, _, err = filter.ExecuteString()
	}

	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}
	var games []map[string]any
	err = json.Unmarshal([]byte(rep), &games)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	if sortBy == "price" {
		calcuateNewPrice := func(game map[string]any) float64 {
			price, ok := game["price"].(float64)
			if !ok {
				price = math.MaxFloat64
			} else if game["Game_Sale"] != nil {
				gameSale := game["Game_Sale"].(map[string]any)
				discount, ok := gameSale["discountpercentage"].(float64)
				if ok {
					price = price * (100 - discount) / 100
				}
			}
			return price
		}
		sort.Slice(games, func(i, j int) bool {
			priceI := calcuateNewPrice(games[i])
			priceJ := calcuateNewPrice(games[j])
			return priceI < priceJ
		})
	}

	return jsonResponse(c, http.StatusOK, "", games)
}

func updateGame(c echo.Context, client *supabase.Client, bucketId string) error {
	gameID := c.Param("id")

	rep, _, err := client.From("Game").Select("publisherid", "", false).Eq("gameid", gameID).Single().ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusNotFound, "Game not found!", err.Error())
	}

	var gameData map[string]interface{}
	if err := json.Unmarshal([]byte(rep), &gameData); err != nil {
		return jsonResponse(c, http.StatusInternalServerError, "Failed to parse game data!", err.Error())
	}

	userID, ok := gameData["publisherid"].(string)
	if !ok || userID == "" {
		return jsonResponse(c, http.StatusInternalServerError, "Could not determine the publisher of this game!", nil)
	}

	errorReport := make(map[string]interface{})

	updates := map[string]any{}
	name := c.FormValue("gamename")
	desc := c.FormValue("description")
	if name != "" {
		updates["name"] = name
	}
	if desc != "" {
		updates["description"] = desc
	}
	if len(updates) > 0 {
		_, _, err := client.From("Game").Update(updates, "", "").Eq("gameid", gameID).ExecuteString()
		if err != nil {
			return jsonResponse(c, http.StatusInternalServerError, "Failed to update game metadata!", err.Error())
		}
	}

	catsRaw := c.FormValue("categories")
	if catsRaw != "" {
		newCats := slices.DeleteFunc(strings.Split(catsRaw, ","), func(s string) bool { return strings.TrimSpace(s) == "" })
		_, _, _ = client.From("Game_Category").Delete("", "").Eq("gameid", gameID).ExecuteString()

		if len(newCats) > 0 {
			rep, _, err := client.From("Category").Select("", "", false).ExecuteString()
			if err != nil {
				return jsonResponse(c, http.StatusInternalServerError, "Failed to fetch categories!", err.Error())
			}

			var knownCategories []map[string]any
			err = json.Unmarshal([]byte(rep), &knownCategories)
			if err != nil {
				return jsonResponse(c, http.StatusInternalServerError, "Failed to parse categories!", err.Error())
			}

			errCat := []string{}

			for _, category := range newCats {
				categoryName := strings.TrimSpace(category)
				index := slices.IndexFunc(knownCategories, func(knownCategory map[string]any) bool { return knownCategory["categoryname"] == categoryName })
				if index == -1 {
					errCat = append(errCat, categoryName)
					continue
				}

				pair := map[string]any{
					"gameid":     gameID,
					"categoryid": knownCategories[index]["categoryid"],
				}

				_, _, err := client.From("Game_Category").Insert(pair, true, "", "", "").ExecuteString()
				if err != nil {
					errCat = append(errCat, categoryName)
					continue
				}
			}
			if len(errCat) > 0 {
				errorReport["failed_categories"] = errCat
			}
		}
	}

	replaceRaw := c.FormValue("resourceids")
	var toDelete []string

	if replaceRaw != "" {
		err := json.Unmarshal([]byte(replaceRaw), &toDelete)
		if err != nil {
			return jsonResponse(c, http.StatusBadRequest, "Invalid resourceids format", err.Error())
		}
		if len(toDelete) > 0 {
			// Verify resources belong to this game before deletion
			rep, _, err := client.From("Game_Resource").Select("resourceid", "", false).Eq("gameid", gameID).In("resourceid", toDelete).ExecuteString()
			if err != nil {
				errorReport["verification_failed"] = "Could not verify resource ownership"
			} else {
				var gameResources []map[string]string
				json.Unmarshal([]byte(rep), &gameResources)

				toDelete := make([]string, 0, len(gameResources))
				for _, res := range gameResources {
					toDelete = append(toDelete, res["resourceid"])
				}

				if len(toDelete) > 0 {
					failed := deleteResources(client, bucketId, toDelete)
					if len(failed) > 0 {
						errorReport["failed_deletions"] = failed
					}
				}
			}
		}
	}

	form, err := c.MultipartForm()
	if err != nil && err != http.ErrNotMultipart {
		return jsonResponse(c, http.StatusBadRequest, "Failed to parse form data!", err.Error())
	}
	if form != nil {
		files := form.File["binary"]
		if len(files) > 0 {
			errFiles := addResources(client, userID, gameID, bucketId, files, "binary")
			if len(errFiles) > 0 {
				errorReport["failed_binary"] = errFiles
			}
		}

		files = form.File["media"]
		if len(files) > 0 {
			errFiles := addResources(client, userID, gameID, bucketId, files, "media")
			if len(errFiles) > 0 {
				errorReport["failed_media"] = errFiles
			}
		}

		files = form.File["executable"]
		if len(files) > 0 {
			errFiles := addResources(client, userID, gameID, bucketId, files, "executable")
			if len(errFiles) > 0 {
				errorReport["failed_executable"] = errFiles
			}
		}
	}

	if len(errorReport) > 0 {
		return jsonResponse(c, http.StatusPartialContent, "Some errors occur", errorReport)
	}

	return jsonResponse(c, http.StatusOK, "", "")
}

func recommendGame(c echo.Context, client *supabase.Client, userID string) error {
	gameID := c.FormValue("gameid")
	if gameID == "" {
		return jsonResponse(c, http.StatusBadRequest, "Missing game ID", "")
	}

	vote := map[string]string{
		"userid": userID,
		"gameid": gameID,
	}

	_, _, err := client.
		From("Game_Recommend").
		Select("*", "", false).
		Match(vote).
		Single().
		ExecuteString()

	if err == nil {
		_, _, err = client.
			From("Game_Recommend").
			Delete("", "").
			Match(vote).
			ExecuteString()
		if err != nil {
			return jsonResponse(c, http.StatusInternalServerError, "Failed to remove recommend", err.Error())
		}
		return jsonResponse(c, http.StatusOK, "", "")
	}

	_, _, err = client.
		From("Game_Recommend").
		Insert(vote, false, "", "", "").
		ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusInternalServerError, "Failed to add recommend", err.Error())
	}
	return jsonResponse(c, http.StatusOK, "", "")
}
