import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/common.dart';
import 'package:shopping_app/provider/app_provider.dart';
import 'package:shopping_app/db/products.dart';
import 'package:shopping_app/screens/credit_card.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/services/cards.dart';


class ManageCardsScreen extends StatefulWidget {
  @override
  _ManageCardsScreenState createState() => _ManageCardsScreenState();
}

class _ManageCardsScreenState extends State<ManageCardsScreen> {
  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      loadCards(appProvider, user.uid);
    });
    super.initState();
  }
  var refreshkey = GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        title: Text(
          "Cartes",
        ),
      ),
      body: RefreshIndicator(
        key: refreshkey,
        child: ListView.builder(
            itemCount: appProvider.Cards.length,
            itemBuilder: (BuildContext context, index){
              return  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration:  BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: white,
                      boxShadow: [
                        BoxShadow(
                            color: grey,
                            offset: Offset(2, 1),
                            blurRadius: 5
                        )
                      ]
                  ),
                  child: ListTile(
                    leading: Icon(Icons.credit_card),
                    title: Text("**** **** **** ${appProvider.Cards[index].num_carte.replaceAll(RegExp(r"\s+\b|\b\s"), "").toString().substring(11)}"),
                    subtitle: Text("${appProvider.Cards[index].mois_exp} / ${appProvider.Cards[index].an_exp}"),
                    trailing: Icon(Icons.delete),
                    onTap: () {
                      Firestore.instance.collection("Cartes")
                          .where("id", isEqualTo: appProvider.Cards[index].id)
                          .getDocuments()
                          .then((snapshot) {
                        snapshot.documents.first.reference.delete();
                      });
                    }
                  ),
                ),
              );
            }),
        onRefresh: refreshlist,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        child: Icon(Icons.add),
        onPressed: (){
          changeScreen(context, CreditCard(title: "Ajouter une carte",));
        },
      ),
    );
  }

  Future<Null> refreshlist() async {
    refreshkey.currentState?.show(
        atTop:
        true);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
      FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
        loadCards(appProvider, user.uid);
      });
    });
  }

}