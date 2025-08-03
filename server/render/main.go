package main

import (
	"fmt"
	"net/http"
	"os"
	"runtime"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

func _jsonResponse(c echo.Context, code int, message string, returnVal any) error {
	jsonData := map[string]any{
		"message": message,
		"return":  returnVal,
	}
	return c.JSON(code, jsonData)
}

func jsonResponse(c echo.Context, code int, message string, returnVal any) error {
	_, filename, line, _ := runtime.Caller(1)
	fmt.Println(filename, line)
	return _jsonResponse(c, code, message, returnVal)
}

func main() {
	supabaseURL := os.Getenv("SUPABASE_URL")
	supabaseKEY := os.Getenv("SUPABASE_KEY")
	client, err := supabase.NewClient(supabaseURL, supabaseKEY, nil)
	if err != nil {
		fmt.Println("cannot initalize client", err)
		return
	}

	bucketId := "root"

	e := echo.New()

	e.POST("/login", func(c echo.Context) error {
		return login(c, client)
	})

	e.POST("/user", func(c echo.Context) error {
		return addUser(c, client)
	})

	e.GET("/user/:id", func(c echo.Context) error {
		return getUser(c, client)
	})
	e.PATCH("/user/:id", func(c echo.Context) error {
		return jsonResponse(c, http.StatusBadRequest, "Unsupported request", "")
	})
	e.GET("/user/:id/library", func(c echo.Context) error {
		userid := c.Param("id")
		return getGamesWithStatus(c, client, userid, "In library")
	})
	e.GET("/user/:id/wishlist", func(c echo.Context) error {
		userid := c.Param("id")
		return getGamesWithStatus(c, client, userid, "In wishlist")
	})
	e.POST("/user/cart", func(c echo.Context) error {
		token := c.FormValue("token")
		err := verifyUserToken(token)
		if err != nil {
			// TODO: Redirect to login page
			return jsonResponse(c, http.StatusBadRequest, "Invalid token", "")
		}

		userid := c.FormValue("userid")
		return getGamesWithStatus(c, client, userid, "In cart")
	})

	e.POST("/addtolibrary", func(c echo.Context) error {
		token := c.FormValue("token")
		err := verifyUserToken(token)
		if err != nil {
			// TODO: Redirect to login page
			return jsonResponse(c, http.StatusBadRequest, "Invalid token", "")
		}

		userid := c.FormValue("userid")
		gameid := c.FormValue("gameid")

		userGame := map[string]string{
			"userid": userid,
			"gameid": gameid,
			"status": "In library",
		}

		return addGameWithStatus(c, client, userGame)
	})
	e.POST("/addtowishlist", func(c echo.Context) error {
		token := c.FormValue("token")
		err := verifyUserToken(token)
		if err != nil {
			// TODO: Redirect to login page
			return jsonResponse(c, http.StatusBadRequest, "Invalid token", "")
		}

		userid := c.FormValue("userid")
		gameid := c.FormValue("gameid")
		userGame := map[string]string{
			"userid": userid,
			"gameid": gameid,
			"status": "In wishlist",
		}

		return addGameWithStatus(c, client, userGame)
	})
	e.POST("/addtocart", func(c echo.Context) error {
		token := c.FormValue("token")
		err := verifyUserToken(token)
		if err != nil {
			// TODO: Redirect to login page
			return jsonResponse(c, http.StatusBadRequest, "Invalid token", "")
		}

		userid := c.FormValue("userid")
		gameid := c.FormValue("gameid")
		userGame := map[string]string{
			"userid": userid,
			"gameid": gameid,
			"status": "In cart",
		}

		return addGameWithStatus(c, client, userGame)
	})

	e.POST("/game", func(c echo.Context) error {
		return addGame(c, client, bucketId)
	})

	e.GET("/game/:id", func(c echo.Context) error {
		return getGame(c, client)
	})
	e.PATCH("/game/:id", func(c echo.Context) error {
		return updateGame(c, client, bucketId)
	})

	e.GET("/search", func(c echo.Context) error {
		entity := c.QueryParam("entity")

		switch entity {
		case "user":
			{
				return searchUsers(c, client)
			}
		case "game":
			{
				return searchGames(c, client)
			}
		}

		return jsonResponse(c, http.StatusBadRequest, "Unsupported entity", "")
	})

	e.POST("category", func(c echo.Context) error {
		return addCategory(c, client)
	})

	e.POST("payment", func(c echo.Context) error {
		return addPaymentMethod(c, client)
	})

	e.POST("publisher", func(c echo.Context) error {
		return addPublisher(c, client)
	})
	e.GET("/publisher/:id", func(c echo.Context) error {
		return getPublisher(c, client)
	})
	e.PATCH("/publisher/:id", func(c echo.Context) error {
		return updatePublisher(c, client)
	})

	e.POST("/checkout/create", func(c echo.Context) error {
		return jsonResponse(c, http.StatusBadRequest, "Unsupported method", "")
	})
	e.GET("/checkout/cancel", func(c echo.Context) error {
		return c.String(http.StatusOK, "No")
	})
	e.GET("/checkout/return", func(c echo.Context) error {
		return approvePayment(c)
	})

	e.Logger.Fatal(e.Start(":1323"))
}
