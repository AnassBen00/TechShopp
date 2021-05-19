import 'package:cloud_firestore/cloud_firestore.dart';

class CardModel{
  static const ID = 'id';
  static const USER_ID = 'IdUtilisateur';
  static const MONTH = 'mois_exp';
  static const YEAR = 'an_exp';
  static const LAST_FOUR = 'num_carte';

  String _id;
  String _userId;
  int _month;
  int _year;
  String _last4;

//  getters
  String get id => _id;
  String get IdUtilisateur => _userId;
  int get mois_exp => _month;
  int get an_exp => _year;
  String get num_carte => _last4;

  CardModel.fromSnapshot(DocumentSnapshot snapshot){
    _id = snapshot.data[ID];
    _userId = snapshot.data[USER_ID];
    _month = snapshot.data[MONTH];
    _year = snapshot.data[YEAR];
    _last4 = snapshot.data[LAST_FOUR];
  }

  CardModel.fromMap(Map data, {String customerId}){
    _id = data[ID];
    _userId = data[USER_ID];
    _month = data[MONTH];
    _year = data[YEAR];
    _last4 = data[LAST_FOUR];
  }

  Map<String, dynamic> toMap(){
    return {
      ID: _id,
      USER_ID: _userId,
      MONTH: _month,
      YEAR: _year,
      LAST_FOUR: _last4
    };
  }

}