import 'package:flutter/material.dart';
import 'package:shopping_app/Categories/casque.dart';
import 'package:shopping_app/Categories/laptop.dart';
import 'package:shopping_app/Categories/mouse.dart';
import 'package:shopping_app/Categories/phone.dart';

class HorizontalList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Category(
            image_Location: 'images/categories/phone.png',
            image_caption: 'Téléphone',
            route: () async =>  Navigator.push(context, MaterialPageRoute(builder:(context)=> phoneProds())),
          ),
          Category(
            image_Location: 'images/categories/laptop.png',
            image_caption: 'PC',
            route: () async => Navigator.push(context, MaterialPageRoute(builder:(context)=> laptopProds())),
          ),
          Category(
            image_Location: 'images/categories/ipad.png',
            image_caption: 'Tablette',
          ),
          Category(
            image_Location: 'images/categories/keyboard.png',
            image_caption: 'Clavier',
          ),
          Category(
            image_Location: 'images/categories/mouse.png',
            image_caption: 'Souris',
            route: () async => Navigator.push(context, MaterialPageRoute(builder:(context)=> mouseProds())),
          ),
          Category(
            image_Location: 'images/categories/monitor.png',
            image_caption: 'TV',
            //route: () async => Navigator.push(context, MaterialPageRoute(builder:(context)=> casqueProds())),
          ),
          Category(
            image_Location: 'images/categories/casque.png',
            image_caption: 'Casque',
            route: () async => Navigator.push(context, MaterialPageRoute(builder:(context)=> casqueProds())),
          ),
        ],
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String image_Location;
  final String image_caption;
  final route;

  Category({this.image_caption, this.image_Location, this.route });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: route,
        child: Container(
          width: 100.0,
          child: ListTile(
            title: Image.asset(image_Location, width: 40.0, height: 40.0),
            subtitle: Container(
              alignment: Alignment.topCenter,
              child: Text(image_caption, style: new TextStyle(fontSize: 13.0)),
            ),
          ),
        ),
      ),
    );
  }
}
