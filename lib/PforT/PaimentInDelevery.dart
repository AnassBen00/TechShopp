import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/Location/Location.dart';
import 'package:shopping_app/db/products.dart';
import 'package:shopping_app/pages/home.dart';
import 'package:shopping_app/provider/app_provider.dart';
import 'package:shopping_app/provider/user_provider.dart';
import 'package:shopping_app/services/purchases.dart';
import 'package:uuid/uuid.dart';

import '../common.dart';

class paiment_in_delevery extends StatefulWidget {
  final nom ;
  final prix;
  final dhPrix;
  final quantite;
  final loc;
  final couleur;
  paiment_in_delevery({Key key, this.nom, this.prix, this.dhPrix, this.quantite, this.loc, this.couleur}): super(key:key);

  @override
  _paiment_in_deleveryState createState() => _paiment_in_deleveryState();
}

class _paiment_in_deleveryState extends State<paiment_in_delevery> {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    DateTime dateTime = DateTime.now().add(Duration(days: 5));
    dateFormat.format(dateTime);
    print(widget.loc);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Paiement à la livraison"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200
                ),
                child: new ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      const Text("Payez en espèces dès que vous recevez votre commande.",style: TextStyle(fontSize: 16.0,
                        )),
                      const Text("- Soyez certain d'avoir le montant exact du paiement.",style: TextStyle(fontSize: 16.0,
                        )),
                      const Text("- Nous acceptons uniquement le paiement en Dirham Marocain.",style: TextStyle(fontSize: 16.0,
                        )),
                    ]
                ),
              ),
              const SizedBox(height: 20.0),

            ListView(
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text("Lieu de livraison"),
                  subtitle: Text(widget.loc),
                  trailing: Icon(Icons.cached),
                ),
                Divider( color: Colors.black38,),
                ListTile(
                  leading: Icon(Icons.email),
                  title: Text("Votre email"),
                  subtitle: Text(user.userModel.email),
                ),
                Divider( color: Colors.black38,),
                ListTile(
                  leading: Icon(Icons.date_range),
                  title: Text(dateFormat.format(dateTime)),
                  subtitle: Text("Date de livraison"),
                ),
              ],
            ),
              Divider( color: Colors.black38,),
              MaterialButton(
                color: Colors.black,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("Montant total: ${widget.dhPrix * widget.quantite} DH",style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 17.0),),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30.0),
              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.indigo,
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () {
                    var id = Uuid();
                    String Pid = id.v1();
                    PurchaseServices purchaseServices = PurchaseServices();
                    purchaseServices.createPurchase(id: Pid, amount: widget.dhPrix, cardId: "non_utiliser", userId: user.user.uid, productName: widget.nom, color: widget.couleur, quantity: widget.quantite);
                    user.loadCardsAndPurchase(userId: user.user.uid);
                    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
                    /*Firestore.instance
                        .collection('Utilisateurs')
                        .document(user.user.uid)
                        .collection('ProdsAchetés')
                        .getDocuments().then((snapshot){
                      snapshot.documents.first.reference.delete();
                    });

                    appProvider.Achats.clear();*/

                    loadPurchases(appProvider, user.user.uid);
                      Navigator.pop(context, MaterialPageRoute(builder:(context)=> new HomePage()));

                  },
                  child: Text("Confirmer",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0)),
                ),
              ),
        ]
      ),
      ),
    );
  }
}
