import '../index.dart';

class DocPDF {
  String id;
  String name;
  String category;
  String date;
  String quantity;
  String companyName;

  DocPDF({
    this.id,
    this.name = '',
    this.category = '',
    this.date = '',
    this.quantity,
    this.companyName = '',
  });

  DocPDF.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    category = json['category'];
    date = json['date'];
    quantity = json['quantity'];
    companyName = json['companyName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    data['name'] = this.name;
    data['category'] = this.category;
    data['date'] = this.date;
    data['quantity'] = this.quantity;
    data['companyName'] = this.companyName;
    return data;
  }

  DocPDF.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.id;
    name = snapshot.get("name");
    category = snapshot.get("category");
    date = snapshot.get("date");
    quantity = snapshot.get("quantity");
    companyName = snapshot.get("companyName");
  }

  @override
  String toString() {
    return "$id, $name, $category, $date, $quantity, $companyName";
  }
}
