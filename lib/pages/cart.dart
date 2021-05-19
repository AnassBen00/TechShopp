import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/PforT/teeest2.dart';
import 'package:shopping_app/componets/Cart_Products.dart';
import 'package:shopping_app/provider/user_provider.dart';

class Cart extends StatefulWidget {

  @override
  _CartState createState() => _CartState();
}

double totalprice;

class _CartState extends State<Cart> {
  String lieu;
  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      double sum = 0;
      List<double> Totalprices = new List<double>();
      setState(() {
        var Query = Firestore.instance
            .collection('Utilisateurs')
            .document(user.uid)
            .collection('ProdsAchetés');
        Query.getDocuments().then((data) {
          if (0 < data.documents.length) {
            for (int i = 0; i < data.documents.length; i++) {
              double x = double.parse(data.documents[i].data['prix']) * data.documents[i].data['quantité'];
              Totalprices.add(x);
            }
            Totalprices.forEach((element) => sum = sum + element);
          }
          print(sum);
          setState(() {
            totalprice = sum;
          });
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.indigo,
        title: Text('TechShopp'),
        actions: <Widget>[
          new IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {}),
          new IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () {})
        ],
      ),
      body: Cart_Products(),
      bottomNavigationBar: new Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
                child: ListTile(
                  title: new Text("Totale:"),
                  subtitle: new Text("$totalprice\DH"),
                )),
            Expanded(
              child: new MaterialButton(
                  onPressed: () {
                    setState(() {
                      final user = Provider.of<UserProvider>(context);
                      var Query1 = Firestore.instance
                          .collection('Utilisateurs')
                          .document(user.userModel.uid)
                          .collection('Localisations');
                      Query1.getDocuments().then((data) {
                        if (0 < data.documents.length) {
                          for (int i = 0; i < data.documents.length; i++) {
                            setState(() {
                              lieu= "${data.documents[i].data['Ville']}, ${data.documents[i].data['Adresse']}" ;
                            });
                            if (data.documents[i].data['Ville'] !=
                                "Casablanca") {
                              var Query = Firestore.instance
                                  .collection('Utilisateurs')
                                  .document(user.userModel.uid)
                                  .collection('ProdsAchetés');
                              Query.getDocuments().then((data) {
                                if (0 < data.documents.length) {
                                  for (int i = 0;
                                  i < data.documents.length;
                                  i++) {
                                    int prix = (int.parse(data.documents[i].data['prix']) + 50)*10;
                                    Navigator.of(context).push(new MaterialPageRoute(
                                        builder: (context) =>
                                        new Page1(
                                          name :data.documents[i].data['nom'],
                                          price: prix.toString(),
                                          dhPrice: int.parse(data.documents[i].data['prix']),
                                          color: data.documents[i].data['couleur'],
                                          quantity: data.documents[i].data['quantité'],
                                          loc: lieu,
                                        )));
                                  }
                                }
                              });
                            } else {
                              var Query = Firestore.instance
                                  .collection('Utilisateurs')
                                  .document(user.userModel.uid)
                                  .collection('ProdsAchetés');
                              Query.getDocuments().then((data) {
                                if (0 < data.documents.length) {
                                  for (int i = 0;
                                  i < data.documents.length;
                                  i++) {
                                    int prix = int.parse(data.documents[i].data['prix']) *10;
                                    Navigator.of(context).push(new MaterialPageRoute(
                                        builder: (context) =>
                                        new Page1(
                                          name :data.documents[i].data['nom'],
                                          price: prix.toString(),
                                          dhPrice: int.parse(data.documents[i].data['prix']),
                                          color: data.documents[i].data['couleur'],
                                          quantity: data.documents[i].data['quantité'],
                                          loc: lieu,
                                        )));
                                  }
                                }
                              });
                            }
                          }
                        }
                      });
                    });
                  },
                  child: new Text("Confirmer",
                      style: TextStyle(color: Colors.white)),
                  color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
