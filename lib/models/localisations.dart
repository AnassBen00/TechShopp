import 'package:cloud_firestore/cloud_firestore.dart';

class localisations{
  String Adresse;
  String CodePostal;
  String Ville;

  localisations();

  localisations.fromMap(Map<String, dynamic> data) {
    Adresse = data['Adresse'];
    CodePostal = data['Code Postal'].toString();
    Ville = data['Ville'];
  }

  Map<String, dynamic> toMap() {
    return {
      'Adresse': Adresse,
      'Code Postal': CodePostal,
      'Ville': Ville,
    };
  }
}
