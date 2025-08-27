package model

import (
	"encoding/json"
	"net/http"
	"render/config"
	"time"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

type Transaction struct {
	TransactionID   string    `json:"transactionid" db:"transactionid"`
	PaymentMethodID string    `json:"paymentmethodid" db:"paymentmethodid"`
	SenderID        string    `json:"senderid" db:"senderid"`
	GameID          string    `json:"gameid" db:"gameid"`
	MoneyAmount     int       `json:"moneyamount" db:"moneyamount"`
	TransactionDate time.Time `json:"transactiondate" db:"transactiondate"`
	IsRefundable    bool      `json:"isrefuncdable" db:"isrefuncdable"`
}

func GetTransactions(c echo.Context, client *supabase.Client, userid string) error {
	rep, _, err := client.From("Transaction").Select("", "", false).Eq("senderid", userid).ExecuteString()
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	var transactions []map[string]any
	err = json.Unmarshal([]byte(rep), &transactions)
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	return config.JsonResponse(c, http.StatusOK, "", transactions)
}
