import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/PforT/services.dart';
import 'package:shopping_app/db/products.dart';
import 'package:shopping_app/models/cards.dart';
import 'package:shopping_app/pages/home.dart';
import 'package:shopping_app/provider/app_provider.dart';
import 'package:shopping_app/provider/user_provider.dart';
import 'package:shopping_app/services/purchases.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ExistingCardsPage extends StatefulWidget {
  final nom ;
  final prix;
  final dhPrix;
  final couleur;
  final quantite;
  ExistingCardsPage({Key key, this.nom, this.prix, this.dhPrix, this.couleur, this.quantite}) : super(key: key);

  @override
  ExistingCardsPageState createState() => ExistingCardsPageState();
}

class ExistingCardsPageState extends State<ExistingCardsPage> {
  @override
  initState()  {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      loadCards(appProvider, user.uid);
      super.initState();
    });
  }

  payViaExistingCard(BuildContext context, {int mois, int annee, String num }) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(
        message: 'Please wait...'
    );
    await dialog.show();
    CreditCard stripeCard = CreditCard(
      number: num,
      expMonth: mois,
      expYear: annee,
    );
    var response = await StripeService.payViaExistingCard(
        amount: widget.prix,
        currency: 'eur',
        card: stripeCard
    );
    final user = Provider.of<UserProvider>(context);
    await dialog.hide();

    if(response.success){
      Firestore.instance
          .collection('Utilisateurs')
          .document(user.user.uid)
          .collection('ProdsAchetés')
          .getDocuments().then((snapshot){
        snapshot.documents.first.reference.delete();
      });
      AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
      loadPurchases(appProvider, user.user.uid);
      appProvider.Achats.clear();
      PurchaseServices purchaseServices = PurchaseServices();
      //print("--------+++++++++--------->${response.Cid} ");
      purchaseServices.createPurchase(id: response.Pid, amount: widget.dhPrix, cardId: response.Cid, userId: user.user.uid, productName: widget.nom, color: widget.couleur, quantity: widget.quantite);
      user.hasCard();
      user.loadCardsAndPurchase(userId: user.user.uid);
    }

    Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          duration: new Duration(milliseconds: 1200),
        )
    ).closed.then((_) {
      Navigator.pop(context, MaterialPageRoute(builder:(context)=> new HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    final user = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Choose existing card'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: appProvider.Cards.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                payViaExistingCard(context, mois: appProvider.Cards[index].mois_exp, annee: appProvider.Cards[index].an_exp, num: appProvider.Cards[index].num_carte);
              },
              child: CreditCardWidget(
                cardNumber: "0000 0000 0000 ${appProvider.Cards[index].num_carte.replaceAll(RegExp(r"\s+\b|\b\s"), "").toString().substring(11)}",
                expiryDate: "${appProvider.Cards[index].mois_exp} / ${appProvider.Cards[index].an_exp}",
                cvvCode: "***",
                showBackView: false,
                cardHolderName: user.userModel.name,
              ),
            );
          },
        ),
      ),
    );
  }
}