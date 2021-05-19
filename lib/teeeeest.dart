/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/common.dart';
import 'package:shopping_app/models/cards.dart';
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
      body: ListView.builder(
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
                  title: Text("**** **** **** ${appProvider.Cards[index].dernier4}"),
                  subtitle: Text("${appProvider.Cards[index].mois_exp} / ${appProvider.Cards[index].an_exp}"),
                  trailing: Icon(Icons.more_horiz),
                  onTap: (){

                  },
                ),
              ),
            );

          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        child: Icon(Icons.add),
        onPressed: (){
          changeScreen(context, CreditCard(title: "Ajouter une carte",));
        },
      ),
    );
  }
}*/
