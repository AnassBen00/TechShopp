import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/PforT/teeest2.dart';
import 'package:shopping_app/db/products.dart';
import 'package:shopping_app/models/products.dart';
import 'package:shopping_app/provider/app_provider.dart';
import 'package:shopping_app/provider/user_provider.dart';
import '../common.dart';
import 'Home.dart';

class ProductDetails extends StatefulWidget {
  final product_detail_name;
  final product_detail_price;
  final product_detail_picture;
  final product_detail_couleurs;
  final product_detail_description;
  final product_detail_marque;
  final product_detail_categorie;
  final product_detail_envente;
  final product_detail_id;
  String dateCreation;

  ProductDetails(
      {this.product_detail_name,
      this.product_detail_price,
      this.product_detail_picture,
      this.product_detail_couleurs,
      this.product_detail_description,
      this.product_detail_id,
      this.product_detail_marque,
      this.product_detail_categorie,
      this.product_detail_envente,
      this.dateCreation,
      });

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int quantity=1;
  String color;
  String lieu;
  @override
  Widget build(BuildContext context) {
      cat = widget.product_detail_categorie;
    dynamic _selected;
    String uid;
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      uid = user.uid;
    });
      final user = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.indigo,
        title: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => new HomePage()));
            },
            child: Text('TechShopp')),
        actions: <Widget>[
          new IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {}),
        ],
      ),
      body: new ListView(
        children: <Widget>[
          new Container(
            height: 300.0,
            child: GridTile(
              child: Container(
                color: Colors.white,
                child: Image.network(widget.product_detail_picture),
              ),
              footer: new Container(
                color: Colors.white70,
                child: ListTile(
                  leading: Text(
                    widget.product_detail_name,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                  ),
                  title: new Row(
                    children: <Widget>[
                      Expanded(
                        child: new Text("                                                     ${widget.product_detail_price}DH",
                            style: TextStyle(
                              color: Colors.green,
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

          //---------first buttons ----------
          Row(
            children: <Widget>[
              //------Color Button----------
              Expanded(
                child: DropdownButton(
                  hint: Text('         couleur              '),
                  // Not necessary for Option 1
                  value: _selected,
                  onChanged: (newValue) {
                    setState(() {
                      _selected = newValue;
                    });
                    color = _selected;
                  },
                  items: widget.product_detail_couleurs
                      .map<DropdownMenuItem<String>>((String x) {
                    return DropdownMenuItem(
                      child: new Text(x),
                      value: x,
                    );
                  }).toList(),
                ),
              ),

              //------Quantity Button----------
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.add_circle_outline, color: Colors.grey,),
                        onPressed: () {
                          setState(() {
                            quantity ++ ;
                          });
                        }),
                    Text(quantity.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                    IconButton(
                        icon: Icon(Icons.remove_circle_outline, color: Colors.grey,),
                        onPressed: () {
                          setState(() {
                            quantity = --quantity == 0 ? 1 : quantity;
                          });
                        }),
                  ],
                ),
              ),
            ],
          ),
          //------the second buttons-------
          Row(
            children: <Widget>[
              //------buy Button-----------
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      var Query1 = Firestore.instance
                          .collection('Utilisateurs')
                          .document(user.user.uid)
                          .collection('Localisations');
                      Query1.getDocuments().then((data) {
                        if (0 < data.documents.length) {
                          for (int i = 0; i < data.documents.length; i++) {
                            setState(() {
                               lieu = "${data.documents[i].data['Ville']}, ${data.documents[i].data['Adresse']}";
                            });
                            if(data.documents[i].data['Ville'] != "Casablanca"){
                              int prix = (int.parse(widget.product_detail_price) + 50)*10;
                              Navigator.of(context).push(new MaterialPageRoute(
                                // passing the values of the product to product detail
                                  builder: (context) =>
                                  new Page1(
                                   loc: lieu,
                                    name :widget.product_detail_name,
                                    price: prix.toString(),
                                    dhPrice: widget.product_detail_price,
                                    color: color,
                                    quantity: quantity,
                                  )));
                            }
                            else{
                              int prix = int.parse(widget.product_detail_price) * 10;
                              print(prix);
                              Navigator.of(context).push(new MaterialPageRoute(
                                // passing the values of the product to product detail
                                  builder: (context) =>
                                  new Page1(
                                    loc: lieu,
                                    name :widget.product_detail_name,
                                    price: prix.toString(),
                                    dhPrice: widget.product_detail_price,
                                    color: color,
                                    quantity: quantity,
                                  )));
                            }
                          }
                        }
                      });
                    });
                  },
                  color: Colors.indigo,
                  textColor: Colors.white,
                  elevation: 1.0,
                  child: new Text("Acheter maintenant"),
                ),
              ),
              new IconButton(
                  icon: Icon(
                    Icons.add_shopping_cart,
                    color: Colors.indigo,
                  ),
                  onPressed: () {
                    Firestore.instance
                        .collection('Utilisateurs')
                        .document(uid)
                        .collection('ProdsAchetés')
                        .document(widget.product_detail_id)
                        .setData({
                      'nom': widget.product_detail_name,
                      'image': widget.product_detail_picture,
                      'prix': widget.product_detail_price,
                      'couleur': color,
                      'quantité': quantity,
                    });
                  }),
              new IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    Firestore.instance
                        .collection('Utilisateurs')
                        .document(uid)
                        .collection('Favorits')
                        .document(widget.product_detail_id)
                        .get()
                        .then((doc) {
                      if (doc.exists)
                        showDialog(
                            context: context,
                            builder: (context) {
                              return new AlertDialog(
                                title: new Text("Avertissement"),
                                content: new Text("Produit déjà ajouté"),
                                actions: <Widget>[
                                  new MaterialButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(context);
                                    },
                                    child: new Text("Fermer"),
                                  )
                                ],
                              );
                            });
                      else
                        Firestore.instance
                            .collection('Utilisateurs')
                            .document(uid)
                            .collection('Favorits')
                            .document(widget.product_detail_id)
                            .setData({
                          'id': widget.product_detail_id,
                          'nom': widget.product_detail_name,
                          'image': widget.product_detail_picture,
                          'prix': widget.product_detail_price,
                          'description': widget.product_detail_description,
                          'couleurs': widget.product_detail_couleurs,
                          'catégorie': widget.product_detail_categorie,
                          'marque': widget.product_detail_marque,
                          'envente': widget.product_detail_envente,
                          'dateCreation': DateTime.now(),
                        });
                    });
                  }),
            ],
          ),

          Divider(),
          new ListTile(
            title: new Text("Détails du produit:"),
            subtitle: new Text(widget.product_detail_description),
          ),

          //---------SIMILAR PRODUCTS---------------
          Divider(),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Text("Produits similaires")),
          new Container(
            height: 360.0,
            child: Similar_products(),
          )
        ],
      ),
    );
  }
}

class Similar_products extends StatefulWidget {
  @override
  _Similar_productsState createState() => _Similar_productsState();
}

class _Similar_productsState extends State<Similar_products> {
  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    getSimilarProducts(appProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return GridView.builder(
        itemCount: appProvider.SimilarProds.length,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return SimilarProd(
            prod_name: appProvider.SimilarProds[index].nom,
            prod_price: appProvider.SimilarProds[index].prix,
            prod_picture: appProvider.SimilarProds[index].image,
            prod_description: appProvider.SimilarProds[index].description,
            prod_couleurs: appProvider.SimilarProds[index].couleurs,
            prod_marque: appProvider.SimilarProds[index].marque,
            prod_categorie: appProvider.SimilarProds[index].categorie,
            prod_envente: appProvider.SimilarProds[index].envente,
            prod_id: appProvider.SimilarProds[index].id,
          );
        });
  }
}

class SimilarProd extends StatelessWidget {
  final prod_picture;
  final prod_name;
  final prod_price;
  final prod_description;
  final prod_couleurs;
  final prod_marque;
  final prod_categorie;
  final prod_envente;
  final prod_id;

  SimilarProd({
    this.prod_picture,
    this.prod_name,
    this.prod_price,
    this.prod_description,
    this.prod_couleurs,
    this.prod_marque,
    this.prod_categorie,
    this.prod_envente,
    this.prod_id,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
          tag: prod_name,
          child: Material(
            child: InkWell(
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                  // passing the values of the product to product detail
                  builder: (context) => new ProductDetails(
                        product_detail_name: prod_name,
                        product_detail_price: prod_price,
                        product_detail_picture: prod_picture,
                        product_detail_description: prod_description,
                        product_detail_couleurs: prod_couleurs,
                        product_detail_id: prod_id,
                        product_detail_categorie: prod_categorie,
                        product_detail_envente: prod_envente,
                        product_detail_marque: prod_marque,
                      ))),
              child: GridTile(
                  footer: Container(
                      color: Colors.white70,
                      child: new Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              prod_name,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          new Text(
                            "$prod_price \DH",
                            style: TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                  child: Image.network(
                    prod_picture,
                    fit: BoxFit.cover,
                  )),
            ),
          )),
    );
  }
}
