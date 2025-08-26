package main

import (
	"fmt"
	"net/http"
	"os"
	"render/config"
	"render/model"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"github.com/supabase-community/supabase-go"
)

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
	e.Use(middleware.CORS())
	e.Static("/static", "assets")

	e.POST("/login", func(c echo.Context) error {
		return model.Login(c, client)
	})

	e.POST("/register", func(c echo.Context) error {
		return model.AddUser(c, client)
	})

	e.GET("/recover", func(c echo.Context) error {
		return model.RecoverPassword(c, client)
	})
	e.GET("/verify", func(c echo.Context) error {
		user := model.VerifyPasswordResetToken(c, client)
		if user == nil {
			return config.JsonResponse(c, http.StatusBadRequest, "Failed to verify otp. Try again", "")
		}

		return config.JsonResponse(c, http.StatusOK, "", user)
	})

	e.GET("/user/:id", func(c echo.Context) error {
		return model.GetUser(c, client)
	})
	e.PATCH("/user/:id", func(c echo.Context) error {
		return model.UpdateUser(c, client)
	})
	e.GET("/user/:id/library", func(c echo.Context) error {
		userid := c.Param("id")
		return model.GetGamesWithStatus(c, client, userid, "In library")
	})
	e.GET("/user/:id/wishlist", func(c echo.Context) error {
		userid := c.Param("id")
		return model.GetGamesWithStatus(c, client, userid, "In wishlist")
	})
	e.GET("/user/:id/post", func(c echo.Context) error {
		userid := c.Param("id")
		return model.GetOwnedPost(c, client, userid)
	})
	e.POST("/user/cart", func(c echo.Context) error {
		userid, err := model.VerifyUserToken(c)
		if err != nil {
			// TODO: Redirect to login page
			return config.JsonResponse(c, http.StatusUnauthorized, "Please login", "")
		}
		return model.GetGamesWithStatus(c, client, userid, "In cart")
	})

	e.POST("/user/playtime", func(c echo.Context) error {
		return model.AddPlaytimeData(c, client)
	})
	e.GET("/user/playtime", func(c echo.Context) error {
		userid, err := model.VerifyUserToken(c)
		if err != nil {
			return config.JsonResponse(c, http.StatusUnauthorized, "Please login", "")
		}
		return model.GetPlaytimeData(c, client, userid)
	})

	e.POST("/addgameto", func(c echo.Context) error {
		userid, err := model.VerifyUserToken(c)
		if err != nil {
			// TODO: Redirect to login page
			return config.JsonResponse(c, http.StatusUnauthorized, "Please login", "")
		}

		status := c.FormValue("status")
		if status != "In library" && status != "In wishlist" && status != "In cart" {
			return config.JsonResponse(c, http.StatusBadRequest, "Allow add games to library/wishlist/cart only", "")
		}

		gameid := c.FormValue("gameid")
		userGame := map[string]string{
			"userid": userid,
			"gameid": gameid,
			"status": status,
		}

		return model.AddGameWithStatus(c, client, userGame)
	})

	e.POST("/removegamefrom", func(c echo.Context) error {
		userid, err := model.VerifyUserToken(c)
		if err != nil {
			// TODO: Redirect to login page
			return config.JsonResponse(c, http.StatusUnauthorized, "Please login", "")
		}

		status := c.FormValue("status")
		if status != "In wishlist" && status != "In cart" {
			return config.JsonResponse(c, http.StatusBadRequest, "Allow remove games from wishlist/cart only", "")
		}

		gameid := c.FormValue("gameid")
		userGame := map[string]string{
			"userid": userid,
			"gameid": gameid,
			"status": status,
		}

		return model.RemoveGameWithStatus(c, client, userGame)
	})

	e.POST("/game", func(c echo.Context) error {
		return model.AddGame(c, client, bucketId)
	})
	e.GET("/game/:id", func(c echo.Context) error {
		return model.GetGame(c, client)
	})
	e.PATCH("/game/:id", func(c echo.Context) error {
		return model.UpdateGame(c, client, bucketId)
	})
	e.POST("/game/requests", func(c echo.Context) error {
		return model.GetGameRequests(c, client)
	})
	e.POST("/game/verify", func(c echo.Context) error {
		return model.VerifyGame(c, client)
	})
	e.POST("/download/game", func(c echo.Context) error {
		userid, err := model.VerifyUserToken(c)
		if err != nil {
			return err
		}

		return model.DownloadGame(c, client, userid)
	})

	e.GET("/search", func(c echo.Context) error {
		entity := c.QueryParam("entity")

		switch entity {
		case "user":
			{
				return model.SearchUsers(c, client)
			}
		case "game":
			{
				return model.SearchGames(c, client)
			}
		case "post":
			{
				return model.SearchPosts(c, client)
			}
		}

		return config.JsonResponse(c, http.StatusBadRequest, "Unsupported entity", "")
	})

	e.POST("/category", func(c echo.Context) error {
		return model.AddCategory(c, client)
	})
	e.GET("/categories", func(c echo.Context) error {
		return model.GetCategories(c, client)
	})

	e.POST("/payment", func(c echo.Context) error {
		return model.AddPaymentMethod(c, client)
	})
	e.GET("/payment", func(c echo.Context) error {
		return model.GetPaymentMethods(c, client)
	})

	e.POST("/publisher", func(c echo.Context) error {
		return model.AddPublisher(c, client)
	})
	e.GET("/publisher/:id", func(c echo.Context) error {
		return model.GetPublisher(c, client)
	})
	e.PATCH("/publisher/:id", func(c echo.Context) error {
		return model.UpdatePublisher(c, client)
	})
	e.POST("/publisher/requests", func(c echo.Context) error {
		return model.GetPublisherRequests(c, client)
	})
	e.POST("/publisher/verify", func(c echo.Context) error {
		return model.VerifyPublisher(c, client)
	})

	e.POST("/transactions", func(c echo.Context) error {
		userid, err := model.VerifyUserToken(c)
		if err != nil {
			return config.JsonResponse(c, http.StatusUnauthorized, "Please login", "")
		}

		return model.GetTransactions(c, client, userid)
	})
	e.POST("/paypal/create", func(c echo.Context) error {
		userid, err := model.VerifyUserToken(c)
		if err != nil {
			// TODO: Redirect to login page
			return config.JsonResponse(c, http.StatusUnauthorized, "Please login", "")
		}

		return model.CreatePaypalReceipt(c, client, userid)
	})
	e.GET("/paypal/cancel", func(c echo.Context) error {
		return c.String(http.StatusOK, "No")
	})
	e.GET("/paypal/return", func(c echo.Context) error {
		code, msg := model.CheckoutVnpay(c, client)
		if code == http.StatusBadRequest {
			return c.HTML(code, "Invalid request")
		} else if code == http.StatusInternalServerError {
			return c.HTML(code, "Internal server error")
		}

		msg["paymentmethod"] = "Paypal"
		return c.HTML(http.StatusOK, model.GenCheckoutPage(msg))
	})

	e.POST("/vnpay/create", func(c echo.Context) error {
		userid, err := model.VerifyUserToken(c)
		if err != nil {
			return config.JsonResponse(c, http.StatusUnauthorized, "Please login", "")
		}

		return model.CreateVnpayReceipt(c, client, userid)
	})
	e.GET("/vnpay/return", func(c echo.Context) error {
		code, msg := model.CheckoutVnpay(c, client)
		if code == http.StatusBadRequest {
			return c.HTML(code, "Invalid request")
		} else if code == http.StatusInternalServerError {
			return c.HTML(code, "Internal server error")
		}

		msg["paymentmethod"] = "VNPay"
		return c.HTML(http.StatusOK, model.GenCheckoutPage(msg))
	})

	e.POST("/recommend/game", func(c echo.Context) error {
		userid, err := model.VerifyUserToken(c)
		if err != nil {
			return err
		}
		return model.RecommendGame(c, client, userid)
	})

	e.GET("/recommend/game/:id", func(c echo.Context) error {
		gameid := c.Param("id")
		userid, err := model.VerifyUserToken(c)
		if err != nil {
			return err
		}
		return model.IsRecommended(c, client, userid, gameid)
	})

	e.POST("/post", func(c echo.Context) error {
		userid, err := model.VerifyUserToken(c)
		if err != nil {
			return err
		}
		return model.AddPost(c, client, userid)
	})

	e.GET("/post/:id", func(c echo.Context) error {
		return model.GetPost(c, client)
	})

	e.PATCH("/post/:id", func(c echo.Context) error {
		userid, err := model.VerifyUserToken(c)
		if err != nil {
			return err
		}
		return model.UpdatePost(c, client, userid)
	})

	e.POST("/recommend/post", func(c echo.Context) error {
		userid, err := model.VerifyUserToken(c)
		if err != nil {
			return err
		}
		return model.RecommendPost(c, client, userid)
	})

	e.GET("/recommend/post/:id", func(c echo.Context) error {
		postid := c.Param("id")
		userid, err := model.VerifyUserToken(c)
		if err != nil {
			return err
		}
		return model.IsPostRecommended(c, client, userid, postid)
	})

	e.DELETE("/post/:id", func(c echo.Context) error {
		userid, err := model.VerifyUserToken(c)
		if err != nil {
			return err
		}
		return model.DeletePost(c, client, userid)
	})

	e.GET("/post/:id/comment", func(c echo.Context) error {
		postid := c.Param("id")
		return model.ListComments(c, client, postid)
	})

	e.POST("/comment", func(c echo.Context) error {
		userid, err := model.VerifyUserToken(c)
		if err != nil {
			return err
		}
		return model.AddComment(c, client, userid)
	})

	e.GET("/comment/:id", func(c echo.Context) error {
		return model.GetComment(c, client)
	})

	e.PATCH("/comment/:id", func(c echo.Context) error {
		userid, err := model.VerifyUserToken(c)
		if err != nil {
			return err
		}
		return model.UpdateComment(c, client, userid)
	})

	e.POST("/recommend/comment", func(c echo.Context) error {
		userid, err := model.VerifyUserToken(c)
		if err != nil {
			return err
		}
		return model.RecommendComment(c, client, userid)
	})

	e.GET("/recommend/comment/:id", func(c echo.Context) error {
		commentid := c.Param("id")
		userid, err := model.VerifyUserToken(c)
		if err != nil {
			return err
		}
		return model.IsCommentRecommended(c, client, userid, commentid)
	})

	e.DELETE("/comment/:id", func(c echo.Context) error {
		userid, err := model.VerifyUserToken(c)
		if err != nil {
			return err
		}
		return model.DeleteComment(c, client, userid)
	})

	e.GET("/forum", func(c echo.Context) error {
		return model.GetAllForums(c, client)
	})
	e.GET("/forum/:id", func(c echo.Context) error {
		return model.GetForum(c, client)
	})

	e.POST("/verify-oauth-token", func(c echo.Context) error {
		return model.VerifyOAuthToken(c, client)
	})
	e.POST("/verify-user-token", func(c echo.Context) error {
		return model.VerifyToken(c)
	})

	e.POST("/messages/game", func(c echo.Context) error {
		return model.AddGameMessage(c, client)
	})
	e.GET("/messages/game", func(c echo.Context) error {
		return model.GetGameMessage(c, client)
	})
	e.POST("/messages/publisher", func(c echo.Context) error {
		return model.AddPublisherMessage(c, client)
	})
	e.GET("/messages/publisher", func(c echo.Context) error {
		return model.GetPublisherMessage(c, client)
	})

	e.Logger.Fatal(e.Start(":1323"))
}
