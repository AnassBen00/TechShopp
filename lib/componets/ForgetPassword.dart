import 'package:shopping_app/pages/login.dart';
import 'package:shopping_app/pages/signup.dart';
import 'package:shopping_app/common.dart';
import 'package:shopping_app/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 20.0,
                )
              ]),
          child: Form(key: _formKey, child: ListView(children: <Widget>[
            SizedBox(height: 250,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  child: new Text("Réinitialiser le mot de passe", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: Colors.black, decoration: TextDecoration.none ),)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
              child: Material(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey.withOpacity(0.2),
                elevation: 0.0,
                child: Padding(padding: const EdgeInsets.only(left :0.0),
                  child: ListTile(
                    title: TextFormField(
                      controller: _email,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Email",
                        icon: Icon(Icons.alternate_email),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          Pattern pattern =
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regex = new RegExp(pattern);
                          if (!regex.hasMatch(value))
                            return 'Veuillez vous assurer que votre adresse e-mail est valide';
                          else
                            return null;
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.fromLTRB(60.0, 8.0, 60.0, 8.0),
              child: Material(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.black,
                  elevation: 0.0,
                  child: MaterialButton(
                    onPressed: () async{
                      user.resetPassword(_email.text);
                      Navigator.pop(context, MaterialPageRoute(builder: (BuildContext context) => Login()));
                    },
                    minWidth: MediaQuery.of(context).size.width,
                    child: Text(
                      "Valider",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0),
                    ),
                  )),
            ),
          ]
          )
          ),
        ),
      ),
    );
  }
}
