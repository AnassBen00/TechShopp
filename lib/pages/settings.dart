import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/provider/user_provider.dart';
import '../Location/Location.dart';

class SettingsOnePage extends StatefulWidget {
  static final String path = "lib/src/pages/settings/settings1.dart";

  @override
  _SettingsOnePageState createState() => _SettingsOnePageState();
}

class _SettingsOnePageState extends State<SettingsOnePage> {
  TextEditingController passController = TextEditingController();
  GlobalKey<FormState> _cpFormKey = GlobalKey();
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> _ceFormKey = GlobalKey();
  bool _dark;
  @override
  void initState() {

    super.initState();
    _dark = false;
  }

  Brightness _getBrightness() {
    return _dark ? Brightness.dark : Brightness.light;
  }

  void _ChangePasswordAlert() {
    final user = Provider.of<UserProvider>(context);
    var alert = new AlertDialog(
      title: Text("Vous recevez un email pour changer votre mot de passe"),
      content: Form(
        key: _cpFormKey,
        child: TextFormField(
          controller: passController,
          validator: (value){
            if(value.isEmpty){
              return 'vous devez entrer votre email';
            }
          },
          decoration: InputDecoration(
              hintText: "Entrer votre email"
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(onPressed: (){
          user.resetPassword(passController.text);
          Navigator.pop(context);
         }, child: Text('Confirmer')),
        FlatButton(onPressed: (){
          Navigator.pop(context);
         }, child: Text('Annuler')),
      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }

  void _ChangeEmailAlert() {
    final user = Provider.of<UserProvider>(context);
    var alert = new AlertDialog(
      title: Text("Consultez votre boîte pour modifier votre email"),
      content: Form(
        key: _cpFormKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: passController,
              validator: (value){
                if(value.isEmpty){
                  return 'vous devez entrer votre mot de passe';
                }
              },
              decoration: InputDecoration(
                  hintText: "Entrer votre password"
              ),
            ),
            TextFormField(
              controller: emailController,
              validator: (value){
                if(value.isEmpty){
                  return 'vous devez entrer votre email ';
                }
              },
              decoration: InputDecoration(
                  hintText: "Entrer votre email"
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(onPressed: (){
          Firestore.instance
              .collection('Utilisateurs')
              .document(user.user.uid)
              .updateData({
            "email": emailController.text
          });
          user.signIn(user.user.email, passController.text);
          user.user.updateEmail(emailController.text);
          Navigator.pop(context);
          }, child: Text('Confirmer')),
        FlatButton(onPressed: (){
          Navigator.pop(context);
          }, child: Text('Annuler')),
      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return Theme(
      isMaterialAppTheme: true,
      data: ThemeData(
        brightness: _getBrightness(),
      ),
      child: Scaffold(
        backgroundColor: _dark ? null : Colors.grey.shade200,
        appBar: AppBar(
          elevation: 0,
          brightness: _getBrightness(),
          iconTheme: IconThemeData(color: _dark ? Colors.black : Colors.white),
          backgroundColor: Colors.indigo,
          title: Text(
            'Réglages',
            style: TextStyle(color: _dark ? Colors.black : Colors.white),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(FontAwesomeIcons.moon),
              onPressed: () {
                setState(() {
                  _dark = !_dark;
                });
              },
            )
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: Colors.indigo,
                    child: ListTile(
                      onTap: () {
                        //open edit profile
                      },
                      title: /*Text(name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),*/
                      FutureBuilder(
                        future: FirebaseAuth.instance.currentUser(),
                        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                          if (snapshot.hasData) {
                            return Text(user.userModel.email,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }
                          else {
                            return Text('Loading...');
                          }
                        },
                      ),
                      leading: CircleAvatar(
                       //TODO---------------------------!!!!!!!!!!!!!
                      ),
                      trailing: new Column(
                        children: <Widget>[
                          Expanded(child: new IconButton(icon: Icon(Icons.edit, color: Colors.white,), onPressed: (){
                            _ChangeEmailAlert();
                          })),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(
                            Icons.lock_outline,
                            color: Colors.indigo,
                          ),
                          title: Text("Changer le mot de passe"),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            _ChangePasswordAlert();
                          },
                        ),
                        /*_buildDivider(),
                        ListTile(
                          leading: Icon(
                            FontAwesomeIcons.language,
                            color: Colors.indigo,
                          ),
                          title: Text("Change Language"),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            //open change language
                          },
                        ),*/
                        _buildDivider(),
                        ListTile(
                          leading: Icon(
                            Icons.location_on,
                            color: Colors.indigo,
                          ),
                          title: Text("Ajouter un emplacement"),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder:(context)=> new showLocations()));
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    "Paramètres de notification",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  SwitchListTile(
                    activeColor: Colors.green,
                    contentPadding: const EdgeInsets.all(0),
                    value: true,
                    title: Text("Notification reçue"),
                    onChanged: (val) {},
                  ),
                  SwitchListTile(
                    activeColor: Colors.green,
                    contentPadding: const EdgeInsets.all(0),
                    value: false,
                    title: Text("Newsletter reçue"),
                    onChanged: null,
                  ),
                  SwitchListTile(
                    activeColor: Colors.green,
                    contentPadding: const EdgeInsets.all(0),
                    value: true,
                    title: Text("Notification d'offre reçue"),
                    onChanged: (val) {},
                  ),
                  SwitchListTile(
                    activeColor: Colors.green,
                    contentPadding: const EdgeInsets.all(0),
                    value: true,
                    title: Text("Mises à jour des applications reçues"),
                    onChanged: null,
                  ),
                  const SizedBox(height: 60.0),
                ],
              ),
            ),

          ],
        ),
        /*bottomNavigationBar: Flushbar(
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue[300],
          ),
          flushbarStyle: FlushbarStyle.GROUNDED,
          isDismissible: true,
          duration: Duration(seconds: 3),
          message: "Localisation bien ajoutée",
          margin: EdgeInsets.all(8),
          borderRadius: 8,
        ),*/
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
}