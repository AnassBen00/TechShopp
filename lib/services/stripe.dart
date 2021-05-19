import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/services/cards.dart';
import 'package:shopping_app/services/purchases.dart';
import 'package:shopping_app/services/user.dart';
import 'package:uuid/uuid.dart';


class StripeServices{
  static const PUBLISHABLE_KEY = "pk_test_3LyKQe5mtNfOTw1e287oxiyl002t8D7c7x";
  static const SECRET_KEY = "sk_test_uEeqiH726YoKO2TjN3KFi5lJ00vFoSe2ND";
  static const PAYMENT_METHOD_URL = "https://api.stripe.com/v1/payment_methods";
  static const CUSTOMERS_URL = "https://api.stripe.com/v1/customers";
  static const CHARGE_URL = "https://api.stripe.com/v1/charges";
  static const PAYMENT_INTENTS = "https://api.stripe.com/v1/payment_intents";

  Map<String, String> headers = {
    'Authorization': "Bearer  $SECRET_KEY",
    "Content-Type": "application/x-www-form-urlencoded"
  };

  Future<String> createStripeCustomer({String email, String userId})async{
    Map<String, String> body = {
      'email': email,
    };

    String stripeId = await http.post(CUSTOMERS_URL, body: body, headers: headers).then((response){
      String stripeId = jsonDecode(response.body)["id"];
      print("The stripe id is: $stripeId");
      UserService userService = UserService();
      userService.updateDetails({
        "uid": userId,
        "stripeId": stripeId
      });
      return stripeId;
    }).catchError((err){
      print("==== THERE WAS AN ERROR ====: ${err.toString()}");
      return null;
    });

    return stripeId;
  }

  Future<void> addCard({String cardNumber, int month, int year, int cvc, String stripeId, String userId})async{
    Map body = {
      "type": "card",
      "card[number]": cardNumber,
      "card[exp_month]": month,
      "card[exp_year]":year,
      "card[cvc]":cvc
    };
    Dio().post(PAYMENT_METHOD_URL, data: body, options: Options(contentType: Headers.formUrlEncodedContentType, headers: headers)).then((response){
      print(response);
      String paymentMethod = response.data["id"];
      print("=== The payment mathod id is ===: $paymentMethod");
      http.post("https://api.stripe.com/v1/payment_methods/$paymentMethod/attach", body: {
        "customer": stripeId
      },
          headers: headers
      ).catchError((err){
        print("ERROR ATTACHING CARD TO CUSTOMER");
        print("ERROR: ${err.toString()}");

      });

      CardServices cardServices = CardServices();
      cardServices.createCard(id: paymentMethod, last4: cardNumber, exp_month: month, exp_year: year, userId: userId);
    });
  }

  Future<bool> charge({String customer, int amount, String userId, String cardId, String productName})async{
    Map<String, dynamic> data2 ={
      "amount": amount,
     "currency": 'eur',
     "payment_method_types": ['card'],
      "payment_method": cardId,
      "customer": customer
    };
    try{
      Dio().post(PAYMENT_INTENTS, data: data2, options: Options(contentType: Headers.formUrlEncodedContentType, headers: headers)).then((response2){
        print(response2.toString());

      Map<String, dynamic> data ={
        "amount": amount,
        "currency": "eur",
        "source": cardId,
        "customer": customer
      };

      Dio().post(CHARGE_URL, data: data, options: Options(contentType: Headers.formUrlEncodedContentType, headers: headers)).then((response){
        print(response.toString());
      });
    });
      PurchaseServices purchaseServices = PurchaseServices();
      var uuid = Uuid();
      var purchaseId = uuid.v1();
      purchaseServices.createPurchase(id: purchaseId, amount: amount, cardId: cardId, userId: userId, productName: productName);
      return true;
    }catch(e){
      print("there was an error charging the customer: ${e.toString()}");
      return false;
    }
  }

}