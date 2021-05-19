import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/custom_text.dart';


class Success extends StatelessWidget {
  @override
  /*test (){
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      var Query1 = Firestore.instance
          .collection('Utilisateurs')
          .document(user.uid)
          .collection('Localisations');
      Query1.getDocuments().then((data) {
        if (0 < data.documents.length) {
          for (int i = 0; i < data.documents.length; i++) {
            if (data.documents[i].data['Ville'] ==
                "Casablanca") {
              Flushbar(
                duration: Duration(seconds: 3),
                message: "+50Dh for the delevery",
                margin: EdgeInsets.all(8),
                borderRadius: 8,
              );
            }
          }
        }
      });
    });
  }
*/

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomText(msg: "Votre paiement est effectué", color: Colors.indigo),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.home),
                  label: CustomText(msg: "Retournez à la page d'accueil")),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Flushbar(
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.blue[300],
        ),
        flushbarStyle: FlushbarStyle.GROUNDED,
        duration: Duration(seconds: 2),
        message: "Les frais de livraison sont ajoutés",
        margin: EdgeInsets.all(8),
        borderRadius: 8,
      ),
    );
  }
}
