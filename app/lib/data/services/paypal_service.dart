import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

class PayPalService {
  // PayPal Configuration - Replace with your actual sandbox credentials
  static final String? _clientId = dotenv.env['PAYPAL_CLIENT_ID'];
  static final String? _clientSecret = dotenv.env['PAYPAL_CLIENT_SECRET'];
  static const bool _isSandbox = true;

  static Future<PayPalResult> makePayment({
    required BuildContext context,
    required double amount,
    required String description,
  }) async {
    try {
      PayPalResult? result;
      
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => PaypalCheckoutView(
            sandboxMode: _isSandbox,
            clientId: _clientId,
            secretKey: _clientSecret,
            transactions: [
              {
                "amount": {
                  "total": amount.toStringAsFixed(2),
                  "currency": "USD",
                  "details": {
                    "subtotal": amount.toStringAsFixed(2),
                    "tax": '0',
                    "shipping": '0',
                    "handling_fee": '0',
                    "shipping_discount": '0',
                    "insurance": '0'
                  }
                },
                "description": description,
                "payment_options": {
                  "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
                },
                "item_list": {
                  "items": [
                    {
                      "name": description,
                      "quantity": 1,
                      "price": amount.toStringAsFixed(2),
                      "currency": "USD"
                    }
                  ],
                }
              }
            ],
            note: "Contact us for any questions on your order.",
            onSuccess: (Map params) {
              print("PayPal Payment Success: $params");
              result = PayPalResult.success(params, amount);
              context.pop();
            },
            onError: (error) {
              print("PayPal Payment Error: $error");
              result = PayPalResult.error('Payment failed: $error');
              context.pop();
            },
            onCancel: () {
              print('PayPal Payment Cancelled');
              result = PayPalResult.cancelled();
              context.pop();
            },
          ),
        ),
      );
      return result ?? PayPalResult.cancelled();
    } catch (e) {
      print('PayPal Exception: $e');
      return PayPalResult.error('Payment failed: $e');
    }
  }
}

class PayPalResult {
  final bool success;
  final String message;
  final Map<dynamic, dynamic>? data;
  final double? amount;

  PayPalResult._({
    required this.success,
    required this.message,
    this.data,
    this.amount,
  });

  factory PayPalResult.success(Map<dynamic, dynamic> data, double amount) {
    return PayPalResult._(
      success: true,
      message: 'Payment completed successfully',
      data: data,
      amount: amount,
    );
  }

  factory PayPalResult.cancelled() {
    return PayPalResult._(
      success: false,
      message: 'Payment was cancelled',
    );
  }

  factory PayPalResult.error(String message) {
    return PayPalResult._(
      success: false,
      message: message,
    );
  }
}