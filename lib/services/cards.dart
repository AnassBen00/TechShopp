import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/models/cards.dart';
import 'package:shopping_app/models/user.dart';

class CardServices{
  static const USER_ID = 'IdUtilisateur';

  String collection = "Cartes";
  Firestore _firestore = Firestore.instance;

  void createCard({String id, String userId, int exp_month, int exp_year, String last4}){
    _firestore.collection(collection).document(id).setData({
      "id": id,
      "IdUtilisateur": userId,
      "mois_exp": exp_month,
      "an_exp":exp_year,
      "num_carte": last4
    });
  }

  void updateDetails(Map<String, dynamic> values){
    _firestore.collection(collection).document(values["id"]).updateData(values);
  }

  void deleteCard(Map<String, dynamic> values){
    _firestore.collection(collection).document(values["id"]).delete();
  }

  Future<List<CardModel>> getPurchaseHistory({String customerId})async =>
      _firestore.collection(collection).where(USER_ID, isEqualTo: customerId).getDocuments().then((result){
        List<CardModel> listOfCards = [];
        result.documents.map((item){
          listOfCards.add(CardModel.fromSnapshot(item));
        });
        return listOfCards;
      });

  Future<List<CardModel>> getCards({String userId})async =>
      _firestore.collection(collection).where(USER_ID, isEqualTo: userId).getDocuments().then((result){
        List<CardModel> cards = [];
        print("=== RESULT SIZE ${result.documents.length}");
        for(DocumentSnapshot item in result.documents){
          cards.add(CardModel.fromSnapshot(item));
          print(" CARDS ${cards.length}");
        }
        return cards;
      });
}
