import 'dart:developer';
import '../index.dart';

class DocPDFProvider {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> addPDF({@required final DocPDF docPDF}) async {
    final document = _db.collection("docPDFs").doc(docPDF.id);
    log("NoSql ID ${document.id}");
    try {
      await document.set(docPDF.toJson());
      return document.id;
    } catch (e) {
      print(e);
      return "no id";
    }
  }

  Future<List<DocPDF>> getPDFs() async {
    QuerySnapshot snapshot = await _db.collection("docPDFs").get();
    List<DocPDF> _listPDFs = snapshot.docs.map((DocumentSnapshot doc) {
      return DocPDF.fromSnapshot(doc);
    }).toList();
    print(_listPDFs);
    return _listPDFs;
  }
}
