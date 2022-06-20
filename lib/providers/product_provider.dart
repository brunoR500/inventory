import 'dart:developer';
import 'package:http/http.dart' as http;
import '../index.dart';

class ProductProvider {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  bool _status = false;

  Future<bool> addProduct({@required final Product product}) async {
    try {
      await _db
          .collection("products")
          .doc(product.id)
          .set(product.toJson())
          .whenComplete(() => _status = true);
      return _status;
    } catch (e) {
      print(e);
      return _status;
    }
  }

  Future<bool> updateProduct({@required final Product product}) async {
    try {
      await _db
          .collection("products")
          .doc(product.id)
          .update(product.toJson())
          .whenComplete(() => _status = true);
      return _status;
    } catch (e) {
      print(e);
      return _status;
    }
  }

  Future<bool> deleteProduct({@required final Product product}) async {
    try {
      await _db
          .collection("products")
          .doc(product.id)
          .delete()
          .whenComplete(() => _status = true);
      return _status;
    } catch (e) {
      print(e);
      return _status;
    }
  }

  Future<List<Product>> getCategories() async {
    QuerySnapshot snapshot = await _db.collection("products").get();
    List<Product> _listProducts = snapshot.docs.map((DocumentSnapshot doc) {
      return Product.fromSnapshot(doc);
    }).toList();

    return _filterCategories(_listProducts);
  }

  Future<List<Product>> getProduct(String category) async {
    QuerySnapshot snapshot = await _db
        .collection("products")
        .where("category", isEqualTo: category)
        .get();
    List<Product> _listProducts = snapshot.docs.map((DocumentSnapshot doc) {
      return Product.fromSnapshot(doc);
    }).toList();

    return _listProducts;
  }

  Future<String> uploadFile(final XFile image) async {
    final String filename = image.path.split("/").last;
    try {
      await _storage.ref(filename).putData(await image.readAsBytes());
      return await _storage.ref(filename).getDownloadURL();
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }

  List<Product> _filterCategories(List<Product> products) {
    final Map<String, Product> profileMap = new Map();
    products.forEach((item) {
      profileMap[item.category] = item;
    });
    products = profileMap.values.toList();
    return products;
  }
}
