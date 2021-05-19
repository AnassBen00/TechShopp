import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/db/products.dart';
import 'package:shopping_app/provider/app_provider.dart';
import 'package:shopping_app/provider/user_provider.dart';

class Cart_Products extends StatefulWidget {
  @override
  _Cart_ProductsState createState() => _Cart_ProductsState();
}
class _Cart_ProductsState extends State<Cart_Products> {
  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      getBuyed(appProvider,user.uid);
    });
    super.initState();
  }
  var refreshkey = GlobalKey<RefreshIndicatorState>();
  Future<Null> refreshlist() async {
    refreshkey.currentState?.show(
        atTop:
        true); // change atTop to false to show progress indicator at bottom
    await Future.delayed(Duration(seconds: 2)); //wait here for 2 second
    setState(() {
      AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
      FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
        getBuyed(appProvider,user.uid);
      });
    });
    }
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return RefreshIndicator(
      key: refreshkey,
      child: ListView.builder(
          itemCount: appProvider.Purchases.length,
          itemBuilder: (BuildContext context, int index) {
            //double x = appProvider.Purchases[index].quantite * double.parse(appProvider.Purchases[index].prix) ;
            return Single_cart_prod(
              card_prod_name: appProvider.Purchases[index].nom,
              card_prod_price: appProvider.Purchases[index].prix,
              card_prod_picture: appProvider.Purchases[index].image,
              card_prod_color: appProvider.Purchases[index].couleur,
              card_prod_qty: appProvider.Purchases[index].quantite,
              //card_prod_id: appProvider.Purchases[index].id,
            );
          }),
      onRefresh: refreshlist,
    );
  }
}

class Single_cart_prod extends StatelessWidget {
  final card_prod_picture;
  final card_prod_name;
  final card_prod_price;
  final card_prod_color;
  final card_prod_qty;
  final card_prod_id;
  Single_cart_prod({
    this.card_prod_picture,
    this.card_prod_name,
    this.card_prod_price,
    this.card_prod_color,
    this.card_prod_qty,
    this.card_prod_id,
});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: new  Image.network(card_prod_picture, width: 80.0, height: 100.0,),
        //=========TITLE SECTION=============
        title: new Text(card_prod_name),
        //=======SUBTITLE SECTION============
        subtitle: new Column(
          children: <Widget>[
            //-----> ROW INSIDE COLUMN
               Row(
                children: <Widget>[
                   Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: new Text("couleur:"),
                    ),

                   Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: new Text(card_prod_color, style: TextStyle(color: Colors.indigo),),
                    ),

                   Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 8.0, 8.0, 8.0),
                      child: new Text("quantité:"),
                    ),

                   Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: new Text("${card_prod_qty}", style: TextStyle(color: Colors.indigo)),
                    ),
                ],
              ),

                //===========THIS SECTION IS FOR THE PRICE=========
                Container(
                  alignment: Alignment.topLeft,
                  child: new Text("${card_prod_price}\DH", style: TextStyle(fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  ),
                )
              ],
        ),
        trailing: new Column(
          children: <Widget>[
            Expanded(child: new IconButton(icon: Icon(Icons.delete_forever), onPressed: (){
              final user = Provider.of<UserProvider>(context);
              Firestore.instance
                  .collection('Utilisateurs')
                  .document(user.user.uid)
                  .collection('ProdsAchetés')
                  .where('id', isEqualTo: card_prod_id)
                  .getDocuments().then((snapshot){
                snapshot.documents.first.reference.delete();
              });
            })),
          ],
        ),
      ),
    );
  }
}



