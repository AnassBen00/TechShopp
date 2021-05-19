import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_app/models/cards.dart';
import 'package:shopping_app/models/purchase.dart';
import 'package:shopping_app/models/user.dart';
import 'package:shopping_app/services/cards.dart';
import 'package:shopping_app/services/purchases.dart';
import 'package:shopping_app/services/user.dart';

enum Status{Uninitialized, Authenticated, Authenticating, Unauthenticated}

class UserProvider with ChangeNotifier{
  FirebaseAuth _auth;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;
  Status get status => _status;
  FirebaseUser get user => _user;
  Firestore _firestore = Firestore.instance;
  UserService _userService = UserService();


  UserModel _userModel;
  List<CardModel> cards = [];
  List<PurchaseModel> purchaseHistory = [];


  UserModel get userModel => _userModel;
  bool hasStripeId = true;
  CardServices _cardServices  = CardServices();
  PurchaseServices _purchaseServices = PurchaseServices();


  UserProvider.initialize(): _auth = FirebaseAuth.instance{
    _auth.onAuthStateChanged.listen(_onStateChanged);
  }

  Future<bool> signIn(String email, String password)async{
    try{
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    }catch(e){
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }


  Future<bool> signUp(String name,String email, String password)async{
    try{
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(email: email, password: password).then((user){
        _firestore.collection('Utilisateurs').document(user.uid).setData({
          'name':name,
          'email':email,
          'uid':user.uid
        });
        user.sendEmailVerification();
      });
      return true;
    }catch(e){
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future signOut()async{
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> resetEmail(String email) async {
    await user.updateEmail(email);
  }


  Future<void> _onStateChanged(FirebaseUser user) async {
    if (user == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = user;
      _status = Status.Authenticated;
      _userModel = await _userService.getUserById(user.uid);
      cards = await _cardServices.getCards(userId: user.uid);
      purchaseHistory =
      await _purchaseServices.getPurchaseHistory(userId: user.uid);
      if (_userModel.stripeId == null) {
        hasStripeId = false;
        notifyListeners();
      }
      print(_userModel.name);
      print(_userModel.email);
      print(_userModel.stripeId);

      notifyListeners();
    }
  }

  Future<void> loadCardsAndPurchase({String userId})async{
    cards = await _cardServices.getCards(userId: userId);
    purchaseHistory = await _purchaseServices.getPurchaseHistory(userId: userId);
  }

  void hasCard(){
    hasStripeId = !hasStripeId;
    notifyListeners();
  }

}