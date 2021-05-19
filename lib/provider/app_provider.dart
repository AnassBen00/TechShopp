import 'dart:collection';
import 'package:shopping_app/models/buyedProds.dart';
import 'package:shopping_app/models/cards.dart';
import 'package:shopping_app/models/localisations.dart';
import 'package:shopping_app/models/products.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/models/purchase.dart';

class AppProvider with ChangeNotifier {
  List<products> _Products = [];
  List<products> _Favorites = [];
  List<products> _Phones = [];
  List<products> _Laptops = [];
  List<products> _Mouses = [];
  List<products> _Casques = [];
  List<prods> _Purchases = [];
  List<localisations> _Localisations = [];
  List<products> _SimilarProds = [];
  List<CardModel> _Cards = [];
  List<PurchaseModel> _Achats = [];
  products _currentProduct;

  UnmodifiableListView<products> get Products => UnmodifiableListView(_Products);
  UnmodifiableListView<products> get Phones => UnmodifiableListView(_Phones);
  UnmodifiableListView<products> get Mouses => UnmodifiableListView(_Mouses);
  UnmodifiableListView<products> get Casques => UnmodifiableListView(_Casques);
  UnmodifiableListView<products> get Laptops => UnmodifiableListView(_Laptops);
  UnmodifiableListView<products> get Favorites => UnmodifiableListView(_Favorites);
  UnmodifiableListView<prods> get Purchases => UnmodifiableListView(_Purchases);
  UnmodifiableListView<products> get SimilarProds => UnmodifiableListView(_SimilarProds);
  UnmodifiableListView<localisations> get Localisations => UnmodifiableListView(_Localisations);
  UnmodifiableListView<CardModel> get Cards => UnmodifiableListView(_Cards);
  List<PurchaseModel> get Achats => _Achats;

  products get currentProduct => _currentProduct;

  set Products(List<products> Products) {
    _Products = Products;
    notifyListeners();
  }

  set Mouses(List<products> Mouses) {
    _Mouses = Mouses;
    notifyListeners();
  }

  set Casques(List<products> Casques) {
    _Casques = Casques;
    notifyListeners();
  }

  set Achats(List<PurchaseModel> Achats) {
    _Achats = Achats;
    notifyListeners();
  }

  set Cards(List<CardModel> Cards) {
    _Cards = Cards;
    notifyListeners();
  }

  set SimilarProds(List<products> Products) {
    _SimilarProds = Products;
    notifyListeners();
  }

  set Localisations(List<localisations> Localisations) {
    _Localisations = Localisations;
    notifyListeners();
  }

  set Purchases(List<prods> Products) {
    _Purchases = Products;
    notifyListeners();
  }

  set Favorites(List<products> Products) {
    _Favorites = Products;
    notifyListeners();
  }

  set Phones(List<products> Products) {
    _Phones = Products;
    notifyListeners();
  }

  set Laptops(List<products> Products) {
    _Laptops = Products;
    notifyListeners();
  }

  set currentProduct(products product) {
    _currentProduct = product;
    notifyListeners();
  }

}

