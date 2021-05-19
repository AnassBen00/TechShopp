import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/db/products.dart';
import 'package:shopping_app/pages/home.dart';
import 'package:shopping_app/pages/settings.dart';
import 'package:shopping_app/provider/app_provider.dart';

import '../common.dart';

class showLocations extends StatefulWidget {
  @override
  _showLocationsState createState() => _showLocationsState();
}

class _showLocationsState extends State<showLocations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.indigo,
        title: new Text('Localisation'),
      ),
      body: getmesLocation(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigo,
          child: Icon(Icons.add),
          onPressed: (){
            changeScreen(context, Location());
          },
        ),
    );
  }
}

class getmesLocation extends StatefulWidget {
  @override
  _getmesLocationState createState() => _getmesLocationState();
}
class _getmesLocationState extends State<getmesLocation> {
  var refreshkey = GlobalKey<RefreshIndicatorState>();
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

    return RefreshIndicator(
       key: refreshkey,
      child: ListView.builder(
          itemCount: appProvider.Localisations.length,
          itemBuilder: (BuildContext context, int index) {
            setState(() {
              L = appProvider.Localisations[index].Ville;
            });
            return AjoutLocation(
              adr: appProvider.Localisations[index].Adresse,
              codePo: appProvider.Localisations[index].CodePostal,
              ville: appProvider.Localisations[index].Ville,
            );
          }),
        onRefresh: refreshlist,
    );
  }
  Future<Null> refreshlist() async {
    refreshkey.currentState?.show(
        atTop:
        true); // change atTop to false to show progress indicator at bottom
    await Future.delayed(Duration(seconds: 2)); //wait here for 2 second
    setState(() {
      AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
      FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
        getLocations(appProvider, user.uid);
    });
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
    //print(adr);
    return Card(
      child: ListTile(
        leading: Icon(Icons.location_on),
        title: Text(ville),
        subtitle: Text(adr),
        trailing: new Column(
          children: <Widget>[
             new IconButton(icon: Icon(Icons.delete_forever),
                 onPressed: (){
               FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
                 Firestore.instance
                     .collection('Utilisateurs')
                     .document(user.uid)
                     .collection('Localisations')
                     .where("Adresse", isEqualTo: adr)
                     .getDocuments().then((snapshot){
                   snapshot.documents.first.reference.delete();
                 });
               });
             }),
          ],
        ),
      ),
    );
  }
}

class Location extends StatefulWidget {
  String adresse;
  String codeP;
  String ville;

  Location({
    this.adresse,
    this.codeP,
    this.ville,
  });

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  final key = GlobalKey<FormState>();
  bool _validate = false;
  String uid;

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      uid = user.uid;
    });
    return Scaffold(
        appBar: new AppBar(
          elevation: 0.1,
          backgroundColor: Colors.indigo,
          title: new Text('Localisation'),
        ),
        body: Stack(fit: StackFit.expand, children: <Widget>[
          new SingleChildScrollView(
            child: new Container(
              margin: new EdgeInsets.all(15.0),
              child: new Form(
                key: key,
                autovalidate: _validate,
                child: FormUI(),
              ),
            ),
          ),
        ]));
  }

  Widget FormUI() {
    return new Column(
      children: <Widget>[
        new TextFormField(
          decoration: new InputDecoration(hintText: 'Adresse'),
          maxLength: 50,
          validator: validateAdresse,
          onSaved: (String val) {
            setState(() {
              widget.adresse = val;
            });
          },
        ),
        new TextFormField(
            decoration: new InputDecoration(hintText: 'Code postal'),
            keyboardType: TextInputType.number,
            maxLength: 5,
            validator: validateCodeP,
            onSaved: (String val) {
              setState(() {
                widget.codeP = val;
              });
            }),
        new TextFormField(
            decoration: new InputDecoration(hintText: 'Ville'),
            keyboardType: TextInputType.text,
            maxLength: 32,
            validator: validateVille,
            onSaved: (String val) {
              setState(() {
                widget.ville = val;
              });
            }),
        new SizedBox(height: 15.0),
        new RaisedButton(
          onPressed: () {
            if (key.currentState.validate()) {
              key.currentState.save();

              Firestore.instance
                  .collection('Utilisateurs')
                  .document(uid)
                  .collection('Localisations')
                  .document()
                  .setData({
                'Adresse': widget.adresse,
                'Code Postal': widget.codeP,
                'Ville': widget.ville,
              });
              changeScreen(context, HomePage());

              setState(() {
                _validate = true;
              });
            }
          },
          child: new Text('Valider'),
        )
      ],
    );
  }

  String validateVille(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Ville est requise";
    } else if (!regExp.hasMatch(value)) {
      return "Ville doit être a-z et A-Z";
    }
    return null;
  }

  String validateCodeP(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Code postal est requis";
    } else if (value.length != 5) {
      return "Code postal doit contenir 5 chiffres";
    } else if (!regExp.hasMatch(value)) {
      return "Code postal doit être des chiffres";
    }
    return null;
  }

  String validateAdresse(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Adresse est requise";
    } else if (!regExp.hasMatch(value)) {
      return "Adresse invalide";
    } else {
      return null;
    }
  }
}

