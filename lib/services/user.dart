import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/models/user.dart';

class UserService{
  String collection = "Utilisateurs";
  Firestore _firestore = Firestore.instance;

  void createUser(Map<String, dynamic> values){
    _firestore.collection(collection).document(values["uid"]).setData(values);
  }

  void updateDetails(Map<String, dynamic> values){
    _firestore.collection(collection).document(values["uid"]).updateData(values);
  }

  Future<UserModel> getUserById(String id) =>
      _firestore.collection(collection).document(id).get().then((doc){
        return UserModel.fromSnapshot(doc);
      });
}