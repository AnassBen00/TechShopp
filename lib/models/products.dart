import 'package:cloud_firestore/cloud_firestore.dart';

class products{
  String id;
  String nom;
  String categorie;
  String description;
  String prix;
  String marque;
  List<String> couleurs;
  bool envente;
  String image;
  Timestamp dateCreation;

  products();

  products.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    nom = data['nom'].toString();
    categorie = data['catégorie'];
    description = data['description'];
    image = data['image'];
    prix = data['prix'];
    marque = data['marque'];
    envente = data['envente'];
    couleurs = data['couleurs'].cast<String>();
    dateCreation = data['dateCreation'];

  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'categorie': categorie,
      'description': description,
      'image': image,
      'prix': prix,
      'marque': marque,
      'envente': envente,
      'couleurs': couleurs,
      'dateCreation': dateCreation,
    };
  }
}