import 'package:shopping_app/models/buyedProds.dart';
import 'package:shopping_app/models/cards.dart';
import 'package:shopping_app/models/localisations.dart';
import 'package:shopping_app/models/products.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/models/purchase.dart';
import 'package:shopping_app/provider/app_provider.dart';

import '../common.dart';

getProducts(AppProvider appProvider) async {
  QuerySnapshot snapshot =
      await Firestore.instance.collection('Produits').getDocuments();

  List<products> _Products = [];

  snapshot.documents.forEach((document) {
    products product = products.fromMap(document.data);
    _Products.add(product);
  });

  appProvider.Products = _Products;
}

getSimilarProducts(AppProvider appProvider) async {
  QuerySnapshot snapshot = await Firestore.instance.collection('Produits').where("catégorie", isEqualTo: cat).getDocuments();
  List<products> _Products = [];

  snapshot.documents.forEach((document) {
    products product = products.fromMap(document.data);
    _Products.add(product);
  });
  appProvider.SimilarProds = _Products;
}

getFavorite(AppProvider appProvider, id) async {
  QuerySnapshot snapshot = await  Firestore.instance.collection('Utilisateurs').document(id).collection('Favorits').getDocuments();

  List<products> _Products = [];

  snapshot.documents.forEach((document) {
    products product = products.fromMap(document.data);
    _Products.add(product);
  });

  appProvider.Favorites = _Products;
}

getPhone(AppProvider appProvider) async {
  QuerySnapshot snapshot = await Firestore.instance
      .collection('Produits')
      .where("catégorie", isEqualTo: "téléphone")
      .getDocuments();

  List<products> _Products = [];

  snapshot.documents.forEach((document) {
    products product = products.fromMap(document.data);
    _Products.add(product);
  });

  appProvider.Phones = _Products;
}

getMouse(AppProvider appProvider) async {
  QuerySnapshot snapshot = await Firestore.instance
      .collection('Produits')
      .where("catégorie", isEqualTo: "souris")
      .getDocuments();

  List<products> _Products = [];

  snapshot.documents.forEach((document) {
    products product = products.fromMap(document.data);
    _Products.add(product);
  });

  appProvider.Mouses = _Products;
}

getCasque(AppProvider appProvider) async {
  QuerySnapshot snapshot = await Firestore.instance
      .collection('Produits')
      .where("catégorie", isEqualTo: "casque")
      .getDocuments();

  List<products> _Products = [];

  snapshot.documents.forEach((document) {
    products product = products.fromMap(document.data);
    _Products.add(product);
  });

  appProvider.Casques = _Products;
}

getLaptop(AppProvider appProvider) async {
  QuerySnapshot snapshot = await Firestore.instance
      .collection('Produits')
      .where("catégorie", isEqualTo: "PC")
      .getDocuments();

  List<products> _Products = [];

  snapshot.documents.forEach((document) {
    products product = products.fromMap(document.data);
    _Products.add(product);
  });

  appProvider.Laptops = _Products;
}

getBuyed(AppProvider appProvider, id) async {
  QuerySnapshot snapshot = await Firestore.instance
      .collection('Utilisateurs')
      .document(id)
      .collection('ProdsAchetés')
      .getDocuments();

  List<prods> _Products = [];

  snapshot.documents.forEach((document) {
    prods product = prods.fromMap(document.data);
    _Products.add(product);
  });
  appProvider.Purchases = _Products;
}

getLocations(AppProvider appProvider, id) async {
  QuerySnapshot snapshot = await  Firestore.instance.collection('Utilisateurs').document(id).collection('Localisations').getDocuments();

  List<localisations> _Localisations = [];

  snapshot.documents.forEach((document) {
    localisations l = localisations.fromMap(document.data);
    _Localisations.add(l);
  });
  appProvider.Localisations = _Localisations;
}

loadCards(AppProvider appProvider, id) async {
  Firestore.instance.collection('Cartes').where('IdUtilisateur', isEqualTo: id).getDocuments().then((result){
    List<CardModel> _Cards = [];
    for(DocumentSnapshot item in result.documents){
      _Cards.add(CardModel.fromSnapshot(item));
    }
    appProvider.Cards = _Cards;
  });
}

loadPurchases(AppProvider appProvider, id) async {
  Firestore.instance.collection('achats').where('IdUtilisateur', isEqualTo: id).getDocuments().then((result){
    List<PurchaseModel> purchaseHistory = [];
    for(DocumentSnapshot item in result.documents){
      purchaseHistory.add(PurchaseModel.fromSnapshot(item));
    }
    appProvider.Achats = purchaseHistory;
  });
}



