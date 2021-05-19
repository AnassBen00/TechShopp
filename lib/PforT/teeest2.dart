import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/PforT/existingCard.dart';
import 'package:shopping_app/PforT/services.dart';
import 'package:shopping_app/common.dart';
import 'package:shopping_app/db/products.dart';
import 'package:shopping_app/pages/cart.dart';
import 'package:shopping_app/pages/home.dart';
import 'package:shopping_app/provider/app_provider.dart';
import 'package:shopping_app/provider/user_provider.dart';
import 'package:shopping_app/services/cards.dart';
import 'package:shopping_app/services/purchases.dart';

import 'PaimentInDelevery.dart';


class Page1 extends StatefulWidget {
  final loc;
  final name;
  final price;
  final dhPrice;
  final color;
  final quantity;
  Page1({Key key, this.name, this.price, this.dhPrice, this.color, this.quantity, this.loc}) : super(key: key);

  @override
  Page1State createState() => Page1State();
}
class Page1State extends State<Page1> {

  onItemPress(BuildContext context, int index) async {
    switch(index) {
      case 0:
        payViaNewCard(context);
        break;
      case 1:
        Navigator.of(context).push(new MaterialPageRoute(
          // passing the values of the product to product detail
            builder: (context) =>
            new ExistingCardsPage(
              nom : widget.name,
              prix: widget.price,
              dhPrix : widget.dhPrice,
              couleur: widget.color,
              quantite: widget.quantity,
            )));
        break;
      case 2:
        Navigator.of(context).push(new MaterialPageRoute(
          // passing the values of the product to product detail
            builder: (context) =>
            new paiment_in_delevery(
              nom : widget.name,
              prix: widget.price,
              dhPrix : widget.dhPrice,
              quantite: widget.quantity,
              loc: widget.loc,
              couleur: widget.color,
            )));
       //print("------------------>${widget.loc} ");
        break;
    }
  }

  payViaNewCard(BuildContext context) async {
    final user = Provider.of<UserProvider>(context);
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(
        message: "S'il vous plaît, attendez..."
    );
    await dialog.show();
    var response = await StripeService.payWithNewCard(
        amount: widget.price,
        currency: 'eur',
    );

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
      purchaseServices.createPurchase(id: response.Pid, amount: widget.dhPrice, cardId: response.Cid, userId: user.user.uid, productName: widget.name, color: widget.color, quantity: widget.quantity );
      user.hasCard();
      user.loadCardsAndPurchase(userId: user.user.uid);
    }
    Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          duration: new Duration(milliseconds: response.success == true ? 1200 : 3000),
        )
    ).closed.then((_) {
      Navigator.pop(context, MaterialPageRoute(builder:(context)=> new HomePage()));
    });
  }

  @override
  void initState() {
   /* AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context);
    getLocations(appProvider, user.user.uid);*/
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Methode de paiement'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.separated(
            itemBuilder: (context, index) {
              Icon icon;
              Text text;

              switch(index) {
                case 0:
                  icon = Icon(Icons.add_circle, );
                  text = Text('Payer via une nouvelle carte');
                  break;
                case 1:
                  icon = Icon(Icons.credit_card, );
                  text = Text('Payer via une carte existante');
                  break;
                case 2:
                  icon = Icon(Icons.local_shipping, );
                  text = Text("Payer à la livraison");
                  break;
              }

              return InkWell(
                onTap: () {
                  onItemPress(context, index);
                },
                child: ListTile(
                  title: text,
                  leading: icon,
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(
              color: Colors.black38,
            ),
            itemCount: 3
        ),
      ),
    );;
  }
}