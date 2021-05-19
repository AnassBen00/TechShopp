import 'package:cloud_firestore/cloud_firestore.dart';

class prods{
  String id;
  String nom;
  String prix;
  String image;
  String couleur;
  int quantite;

  prods();

  prods.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    nom = data['nom'].toString();
    image = data['image'];
    prix = data['prix'];
    couleur = data['couleur'];
    quantite = data['quantité'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'image': image,
      'prix': prix,
      'couleur': couleur,
      'quantité': quantite,
    };
  }
}