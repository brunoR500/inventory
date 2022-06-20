import '../index.dart';

class Product {
  String id;
  String itemNr;
  String itemDescription;
  String category;
  int quantity;
  String type;
  String date;
  String photoUrl;
  String position;
  String notes;

  Product({
    this.id,
    this.itemNr = '',
    this.itemDescription = '',
    this.category = '',
    this.quantity = 0,
    this.type = "Pcs",
    this.date = '',
    this.photoUrl,
    this.position = '',
    this.notes = '',
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemNr = json['itemNr'];
    itemDescription = json['itemDescription'];
    category = json['category'];
    quantity = json['quantity'];
    type = json['type'];
    date = json['date'];
    photoUrl = json['photoUrl'];
    position = json['position'];
    notes = json['notes'];
  }

  factory Product.fromJsonFactory(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      itemNr: json['itemNr'],
      itemDescription: json['itemDescription'],
      category: json['category'],
      quantity: int.parse(json['quantity']),
      type: json['type'],
      date: json['date'],
      photoUrl: json['photoUrl'],
      position: json['position'],
      notes: json['notes'],
    );
  }

  Product.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.id;
    itemNr = snapshot.get("itemNr");
    itemDescription = snapshot.get("itemDescription");
    quantity = snapshot.get("quantity");
    type = snapshot.get('type');
    category = snapshot.get("category");
    date = snapshot.get("date");
    photoUrl = snapshot.get("photoUrl");
    position = snapshot.get('position');
    notes = snapshot.get('notes');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    data['itemNr'] = this.itemNr;
    data['itemDescription'] = this.itemDescription;
    data['quantity'] = this.quantity;
    data['type'] = this.type;
    data['category'] = this.category;
    data['date'] = this.date;
    data['photoUrl'] = this.photoUrl;
    data['position'] = this.position;
    data['notes'] = this.notes;
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is Product &&
        other.id == id &&
        other.itemNr == itemNr &&
        other.itemDescription == itemDescription &&
        other.quantity == quantity &&
        other.type == type &&
        other.category == category &&
        other.date == date &&
        other.photoUrl == photoUrl &&
        other.position == position &&
        other.notes == notes;
  }

  //@override
  //int get hashCode =>
  //    hashValues(id, itemNr, quantity, category, photoUrl);

  @override
  String toString() {
    return "$id, $itemNr, $itemDescription, $quantity, $type, $category, $date, $photoUrl, $position, $notes";
  }

  String getIndex(int index) {
    switch (index) {
      case 0:
        return itemNr;
      case 1:
        return itemDescription;
      case 2:
        return quantity.toString();
      case 3:
        return type;
      case 4:
        return position;
      case 5:
        return date;
    }
    return '';
  }
}
