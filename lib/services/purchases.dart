import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/models/purchase.dart';

class PurchaseServices{
  static const USER_ID = 'IdUtilisateur';

  String collection = "achats";
  Firestore _firestore = Firestore.instance;

  void createPurchase({String id, String productName, int amount, String userId, String date,String cardId, String color, int quantity }){
    _firestore.collection(collection).document(id).setData({
      "id":id,
      "NomProduit":productName,
      "montant": amount,
      "IdUtilisateur": userId,
      "date": DateTime.now().toString(),
      "IdCarte":cardId,
      "couleur": color,
      "quantité": quantity,
    });
  }

  Future<List<PurchaseModel>> getPurchaseHistory({String userId})async =>
      _firestore.collection(collection).where(USER_ID, isEqualTo: userId).getDocuments().then((result){
        List<PurchaseModel> purchaseHistory = [];
        print("=== RESULT SIZE ${result.documents.length}");
        for(DocumentSnapshot item in result.documents){
          purchaseHistory.add(PurchaseModel.fromSnapshot(item));
          print(" CARDS ${purchaseHistory.length}");
        }
        return purchaseHistory;
      });


//  void updateDetails(Map<String, dynamic> values){
//    _firestore.collection(collection).document(values["id"]).updateData(values);
//  }


//  Future<UserModel> getPurchaseById(String id) =>
//      _firestore.collection(collection).document(id).get().then((doc){
//        return PurchaseModel.fromSnapshot(doc);
//      });
}