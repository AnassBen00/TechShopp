import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopping_app/models/purchase.dart';
import 'package:shopping_app/provider/app_provider.dart';
import 'package:shopping_app/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/db/products.dart';

class Purchases extends StatefulWidget {

  @override
  _PurchasesState createState() => _PurchasesState();
}

class _PurchasesState extends State<Purchases> {
  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      loadPurchases(appProvider, user.uid);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    var formatter = new DateFormat('yyyy-MM-dd');
    return Scaffold(
        appBar: AppBar(
          //centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.indigo,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "Mes commandes",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: ListView.separated(
          itemCount: appProvider.Achats.length,
          itemBuilder: (BuildContext context, index){
            return ListTile(
              leading: CustomText(msg: appProvider.Achats[index].montant.toString() +"DH"),
              title: Text(appProvider.Achats[index].NomProduit),
              subtitle: Text("Acheté le: ${formatter.format(DateTime.parse(appProvider.Achats[index].date))}"),
              trailing: Icon(Icons.more_horiz),
              onTap: (){

              },
            );
          }, separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },)
    );
  }
}