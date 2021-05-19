/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/db/products.dart';
import 'package:shopping_app/provider/app_provider.dart';

class getLocation extends StatefulWidget {
  @override
  _getLocationState createState() => _getLocationState();
}
class _getLocationState extends State<getLocation> {
  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      getLocations(appProvider, user.uid);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return ListView.builder(
        itemCount: appProvider.Localisations.length,
        itemBuilder: (BuildContext context, int index) {
          return AjoutLocation(
            adr: appProvider.Localisations[index].Adresse,
            codePo: appProvider.Localisations[index].CodePostal,
            ville: appProvider.Localisations[index].Ville,
          );
        });
  }
}

class AjoutLocation extends StatelessWidget {
  final adr;
  final codePo;
  final ville;

  AjoutLocation({this.adr, this.codePo, this.ville});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Text(""),
        title: Text(""),
        subtitle: new Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: new Text("Ville: "),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: new Text(ville),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: new Text("Adresse: "),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: new Text(adr),
                ),
              ],
            ),
          ],
        ),
        trailing: new Column(
          children: <Widget>[
            Expanded(child: new IconButton(icon: Icon(Icons.delete_forever), onPressed: (){})),
          ],
        ),
      ),
    );
  }
}
*/
