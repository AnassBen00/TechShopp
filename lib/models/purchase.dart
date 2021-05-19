import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseModel{
  static const ID = 'id';
  static const PRODUCT_NAME = 'NomProduit';
  static const AMOUNT = 'montant';
  static const USER_ID = 'IdUtilisateur';
  static const DATE = 'date';
  static const CARD_ID = "IdCarte";
  static const COULEUR = "couleur";
  static const QUANTITE = "quantité";

  String _id;
  String _productName;
  String _userId;
  String _date;
  String _cardId;
  int _amount;
  String _couleur;
  int _quantite;

//  getters
  String get id => _id;
  String get NomProduit => _productName;
  String get IdUtilisateur => _userId;
  String get date => _date;
  String get IdCarte => _cardId;
  int get montant => _amount;
  int get quantite => _quantite;
  String get couleur => _couleur;

  PurchaseModel.fromSnapshot(DocumentSnapshot snapshot){
    _id = snapshot.data[ID];
    _productName = snapshot.data[PRODUCT_NAME];
    _userId = snapshot.data[USER_ID];
    _date = snapshot.data[DATE];
    _cardId = snapshot.data[CARD_ID];
    _amount = snapshot.data[AMOUNT];
    _quantite = snapshot.data[QUANTITE];
    _couleur = snapshot.data[COULEUR];
  }

  PurchaseModel.fromMap(Map data){
    _id = data[ID];
    _productName = data[PRODUCT_NAME];
    _userId = data[USER_ID];
    _date = data[DATE];
    _cardId = data[CARD_ID];
    _amount = data[AMOUNT];
    _quantite = data[QUANTITE];
    _couleur = data[COULEUR];
  }

  Map<String, dynamic> toMap(){
    return {
      ID: _id,
      PRODUCT_NAME: _productName,
      USER_ID: _userId,
      DATE: _date,
      CARD_ID: _cardId,
      AMOUNT: _amount,
      QUANTITE: _quantite,
      COULEUR: _couleur,
    };
  }

}