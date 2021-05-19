import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:shopping_app/pages/home.dart';
import 'package:shopping_app/provider/user_provider.dart';
import 'package:shopping_app/screens/manage_cards.dart';
import 'package:shopping_app/services/stripe.dart';
import 'package:provider/provider.dart';

import '../common.dart';

class CreditCard extends StatefulWidget {
  CreditCard({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CreditCardState createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused, //true when you want to show cvv(back) view
              ),
              CreditCardForm(
                themeColor: Colors.red,
                onCreditCardModelChange: (CreditCardModel data) {
                  setState(() {
                    cardNumber = data.cardNumber;
                    expiryDate = data.expiryDate;
                    cardHolderName = data.cardHolderName;
                    cvvCode = data.cvvCode;
                    isCvvFocused = data.isCvvFocused;
                  });
                },
              ),
              RaisedButton(
                //color: Colors.black12,
                onPressed: ()  async{
                    int cvc = int.tryParse(cvvCode);
                    String carNo = cardNumber;
                    int exp_year = int.tryParse(expiryDate.substring(3,5));
                    int exp_month = int.tryParse(expiryDate.substring(0,2));

                    print("cvc num: ${cvc.toString()}");
                    print("card num: ${carNo.toString()}");
                    print("exp year: ${exp_year.toString()}");
                    print("exp month: ${exp_month.toString()}");
                    print(cardNumber.replaceAll(RegExp(r"\s+\b|\b\s"), ""));

                    StripeServices stripeServices = StripeServices();

                    if(user.userModel.stripeId == null){
                      String stripeID = await stripeServices.createStripeCustomer(email: user.userModel.email, userId: user.user.uid);
                      print("stripe id: $stripeID");
                      print("stripe id: $stripeID");
                      print("stripe id: $stripeID");
                      print("stripe id: $stripeID");

                      stripeServices.addCard(stripeId: stripeID, month: exp_month, year: exp_year, cvc: cvc, cardNumber: carNo, userId: user.user.uid);
                    }else{
                      stripeServices.addCard(stripeId: user.userModel.stripeId, month: exp_month, year: exp_year, cvc: cvc, cardNumber: carNo, userId: user.user.uid);
                    }
                    user.hasCard();
                    user.loadCardsAndPurchase(userId: user.user.uid);

                   changeScreen(context, HomePage());

                },
                child: new Text("Confirmer"),
              ),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}