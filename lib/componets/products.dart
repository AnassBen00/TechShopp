import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/pages/Product_details.dart';
import 'package:shopping_app/provider/app_provider.dart';
import 'package:shopping_app/db/products.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    getProducts(appProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return GridView.builder(
        itemCount: appProvider.Products.length,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return SingleProd(
              prod_name: appProvider.Products[index].nom,
              prod_price: appProvider.Products[index].prix,
              prod_picture: appProvider.Products[index].image,
              prod_description: appProvider.Products[index].description,
              prod_couleurs: appProvider.Products[index].couleurs,
              prod_marque: appProvider.Products[index].marque,
              prod_categorie: appProvider.Products[index].categorie,
              prod_envente: appProvider.Products[index].envente,
              prod_id: appProvider.Products[index].id,
          );
        });
  }
}

class SingleProd extends StatelessWidget {
  final prod_picture;
  final prod_name;
  final prod_price;
  final prod_description;
  final prod_couleurs;
  final prod_id;
  final prod_envente;
  final prod_marque;
  final prod_categorie;

  SingleProd({
    this.prod_picture,
    this.prod_name,
    this.prod_price,
    this.prod_description,
    this.prod_couleurs,
    this.prod_id,
    this.prod_envente,
    this.prod_marque,
    this.prod_categorie,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
          tag: prod_name,
          child: Material(
            child: InkWell(onTap: () =>
              Navigator.of(context).push(new MaterialPageRoute(
                  // passing the values of the product to product detail
                  builder: (context) =>
                  new ProductDetails(
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
              child:
              GridTile(
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
