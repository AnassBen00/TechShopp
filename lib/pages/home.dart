import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/common.dart';
import 'package:shopping_app/componets/Horizontal_Listview.dart';
import 'package:shopping_app/componets/products.dart';
import 'package:shopping_app/pages/about.dart';
import 'package:shopping_app/pages/cart.dart';
import 'package:shopping_app/pages/settings.dart';
import 'package:shopping_app/provider/user_provider.dart';
import 'package:shopping_app/screens/manage_cards.dart';
import 'package:shopping_app/screens/purchase.dart';
import 'favorites.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  final UserDetails detailsUser;

  const HomePage({Key key, this.detailsUser}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final GoogleSignIn _gSignIn =  GoogleSignIn();
    final user = Provider.of<UserProvider>(context);
    Widget image_carousel = new Container(
      height: 200.00,
      child: Container(
        child: new Carousel(
          boxFit: BoxFit.cover,
          images: [
            AssetImage("images/_macbook.jpg"),
            AssetImage("images/116500316-workplace-with-lamp-coffee-to-go-and-desktop-computer-with-copy-space-isolated-on-white.jpg"),
            AssetImage("images/ipad.jpg"),
            AssetImage("images/samsung-galaxy-note10-all-colors.jpg"),
            AssetImage("images/clavier-de-jeu-spiritofgamer-pro-k5-semi-mecanique-cla-pk5.jpg"),
          ],
          autoplay: true,
          animationCurve: Curves.fastLinearToSlowEaseIn,
          animationDuration: Duration(milliseconds: 1000),
          indicatorBgPadding: 4.0,
          dotBgColor: Colors.transparent,
        ),
      ),
    );

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

      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            //HEADER
            UserAccountsDrawerHeader(
              accountName:FutureBuilder(
                future: FirebaseAuth.instance.currentUser(),
                builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                  if (snapshot.hasData) {
                    return Text(user.userModel.name);
                  }
                  else {
                    return Text('Loading...');
                  }
                },
              ),
              //Text("name"),
              accountEmail: FutureBuilder(
                future: FirebaseAuth.instance.currentUser(),
                builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.email);
                  }
                  else {
                    return Text('Loading...');
                  }
                },
              ), //Text("email"),
              currentAccountPicture: GestureDetector(
                child: new CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ),
              decoration: new BoxDecoration(color: Colors.indigo),
            ),

            //BODY
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text("Page d'accueil"),
                leading: Icon(Icons.home, color: Colors.indigo,),
              ),
            ),
            InkWell(
              onTap: () {changeScreen(context, ManageCardsScreen());},
              child: ListTile(
                title: Text('Mes cartes de paiement'),
                leading: Icon(Icons.credit_card, color: Colors.indigo,),
              ),
            ),
            InkWell(
              onTap: () {changeScreen(context, Purchases());},
              child: ListTile(
                title: Text('Mes commandes'),
                leading: Icon(Icons.shopping_basket, color: Colors.indigo,),
              ),
            ),
            InkWell(
              onTap: () {Navigator.push(context, MaterialPageRoute(builder:(context)=> new Cart()));},
              child: ListTile(
                title: Text('Panier'),
                leading: Icon(Icons.shopping_cart, color: Colors.indigo,),
              ),
            ),
            InkWell(
              onTap: () {Navigator.push(context, MaterialPageRoute(builder:(context)=> new favoriteProds()));},
              child: ListTile(
                title: Text('Favorits'),
                leading: Icon(Icons.favorite, color: Colors.indigo,),
              ),
            ),

            Divider(),

            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder:(context)=> new SettingsOnePage()));
              },
              child: ListTile(
                title: Text('Réglages'),
                leading: Icon(Icons.settings),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder:(context)=> new AboutPage()));
              },
              child: ListTile(
                title: Text('À propos de'),
                leading: Icon(Icons.help),
              ),
            ),

            Divider(),

            InkWell(
              onTap: (){
                 if(user.signOut() != null){
                   Navigator.maybePop(context, MaterialPageRoute(builder: (BuildContext context) => Login()));
                 }
                 if(_gSignIn.signOut() != null){
                   Navigator.maybePop(context, MaterialPageRoute(builder: (BuildContext context) => Login()));
                 }
              },
              child: ListTile(
                title: Text('Se déconnecter'),
                leading: Icon(Icons.transit_enterexit, color: Colors.grey,),
              ),
            ),
          ],
        ),
      ),

      body: Container(
        child: new Column(
          children: <Widget>[

            /*Visibility(
              visible: !user.hasStripeId,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                    changeScreen(context, CreditCard(title: "Ajouter une carte",));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top:8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.warning, color: white,),
                          SizedBox(width: 10,),
                          CustomText(msg: "Veuillez ajouter les détails de votre carte", size: 14, color: white,),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),*/

            //image carousel starts here
            image_carousel,

            //Padding widget
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Text('catégories'),
            ),

            //Horizontal List view
             HorizontalList(),

            //Padding widget
            new Padding(
              padding: const EdgeInsets.all(10.0),
              child: new Text('Produits recents'),
            ),

            //Grid view

            Flexible(child: Products(),)
          ],
        ),
      ),
    );
  }
}
