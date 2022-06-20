import '../index.dart';

class CompanyProvider {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  bool _status = false;

  Future<bool> addCompany({@required final Company company}) async {
    try {
      await _db
          .collection("company")
          .doc(company.id)
          .set(company.toJson())
          .whenComplete(() => _status = true);
      return _status;
    } catch (e) {
      print(e);
      return _status;
    }
  }

  Future<bool> updateCompany({@required final Company company}) async {
    try {
      _db
          .collection("company")
          .doc(company.id)
          .update(company.toJson())
          .whenComplete(() => _status = true);
      return _status;
    } catch (e) {
      return _status;
    }
  }

  Future<List<Company>> getCompany() async {
    QuerySnapshot snapshot = await _db.collection("company").get();
    List<Company> _listProducts = snapshot.docs.map((DocumentSnapshot doc) {
      return Company.fromSnapshot(doc);
    }).toList();
    print(_listProducts);
    return _listProducts;
  }

  Future<String> uploadFile(final XFile image) async {
    final String filename = image.path.split("/").last;
    try {
      await _storage.ref(filename).putData(await image.readAsBytes());

      String theURL;
      await _storage
          .ref(filename)
          .getDownloadURL()
          .then((value) => theURL = value);

      return theURL;
    } on FirebaseException catch (error) {
      print(error);
      return null;
    }
  }

  Future<Uint8List> getLogo(String url) {
    return InternetFile.get(
      url,
    );
  }
}
