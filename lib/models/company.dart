import '../index.dart';

class Company {
  String id;
  String name;
  String adress;
  String logoUrl;

  Company({
    this.id,
    this.name = '',
    this.adress = '',
    this.logoUrl,
  });

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    adress = json['adress'];
    logoUrl = json['logoUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    data['name'] = this.name;
    data['adress'] = this.adress;
    data['logoUrl'] = this.logoUrl;
    return data;
  }

  Company.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.id;
    name = snapshot.get("name");
    adress = snapshot.get("adress");
    logoUrl = snapshot.get("logoUrl");
  }
}
