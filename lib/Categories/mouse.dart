import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/pages/Product_details.dart';
import 'package:shopping_app/pages/cart.dart';
import 'package:shopping_app/provider/app_provider.dart';
import 'package:shopping_app/db/products.dart';

class Mouse extends StatefulWidget {
  @override
  _MouseState createState() => _MouseState();
}

class _MouseState extends State<Mouse> {
  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    getMouse(appProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return GridView.builder(
        itemCount: appProvider.Mouses.length,
        gridDelegate:
        new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return SingleProd(
            prod_name: appProvider.Mouses[index].nom,
            prod_price: appProvider.Mouses[index].prix,
            prod_picture: appProvider.Mouses[index].image,
            prod_description: appProvider.Mouses[index].description,
            prod_couleurs: appProvider.Mouses[index].couleurs,
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
  final prod_favori;

  SingleProd({
    this.prod_picture,
    this.prod_name,
    this.prod_price,
    this.prod_description,
    this.prod_couleurs,
    this.prod_favori,
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

class mouseProds extends StatefulWidget {
  @override
  _mouseProdsState createState() => _mouseProdsState();
}

class _mouseProdsState extends State<mouseProds> {
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
              onPressed: () {Navigator.push(context, MaterialPageRoute(builder:(context)=> new Cart()));
              }),
        ],
      ),

      body: new Column(
        children: <Widget>[

          //Padding widget
          new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Text('Souris', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),),
          ),

          Flexible(child: Mouse(),)
        ],
      ),
    );
  }
}

