import 'dart:developer';
import '../index.dart';

List<Product> listTestProducts = [
  Product(
    itemNr: 'ID200',
    itemDescription: 'Möbel 1',
    category: 'Inventory 2020',
    quantity: 1,
    type: "Pcs",
    date: '2022-01-23',
    photoUrl:
        'https://firebasestorage.googleapis.com/v0/b/products-a8e76.appspot.com/o/scaled_a91bec8e-3455-43f5-b4bf-987684ad329c9017529077014155706.jpg?alt=media&token=880667f4-099b-48d1-92fd-19aa9e107930',
    position: '-122.0842883, 37.4219587',
    notes: 'Nothing',
  ),
  Product(
    itemNr: 'ID201',
    itemDescription: 'Sofa 1',
    category: 'Inventory 2020',
    quantity: 1,
    type: "Pcs",
    date: '2022-01-23',
    photoUrl:
        'https://firebasestorage.googleapis.com/v0/b/products-a8e76.appspot.com/o/scaled_557bc1a2-67ba-4b03-af72-5e8c9f4211ed8957048509593747595.jpg?alt=media&token=bffe53c3-6901-485e-84ca-0a9622dcf2a2',
    position: '-122.0842883, 37.4219587',
    notes: 'Nothing',
  ),
  Product(
    itemNr: 'ID202',
    itemDescription: 'Möbel 2',
    category: 'Inventory 2020',
    quantity: 2,
    type: "Pcs",
    date: '2022-01-23',
    photoUrl:
        'https://firebasestorage.googleapis.com/v0/b/products-a8e76.appspot.com/o/scaled_a91bec8e-3455-43f5-b4bf-987684ad329c9017529077014155706.jpg?alt=media&token=880667f4-099b-48d1-92fd-19aa9e107930',
    position: '-122.0842883, 37.4219587',
    notes: 'Nothing',
  ),
  Product(
    itemNr: 'ID203',
    itemDescription: 'Sofa 2',
    category: 'Inventory 2020',
    quantity: 2,
    type: "Pcs",
    date: '2022-01-23',
    photoUrl:
        'https://firebasestorage.googleapis.com/v0/b/products-a8e76.appspot.com/o/scaled_557bc1a2-67ba-4b03-af72-5e8c9f4211ed8957048509593747595.jpg?alt=media&token=bffe53c3-6901-485e-84ca-0a9622dcf2a2',
    position: '-122.0842883, 37.4219587',
    notes: 'Nothing',
  ),
];

List<Product> listTestCategoris = [
  Product(
    itemNr: 'ID200',
    itemDescription: 'Möbel 1',
    category: 'Inventory 2021',
    quantity: 1,
    type: "Pcs",
    date: '2022-01-23',
    photoUrl:
        'https://firebasestorage.googleapis.com/v0/b/products-a8e76.appspot.com/o/scaled_a91bec8e-3455-43f5-b4bf-987684ad329c9017529077014155706.jpg?alt=media&token=880667f4-099b-48d1-92fd-19aa9e107930',
    position: '-122.0842883, 37.4219587',
    notes: 'Nothing',
  ),
  Product(
    itemNr: 'ID201',
    itemDescription: 'Sofa 1',
    category: 'Inventory 2020',
    quantity: 1,
    type: "Pcs",
    date: '2022-01-23',
    photoUrl:
        'https://firebasestorage.googleapis.com/v0/b/products-a8e76.appspot.com/o/scaled_557bc1a2-67ba-4b03-af72-5e8c9f4211ed8957048509593747595.jpg?alt=media&token=bffe53c3-6901-485e-84ca-0a9622dcf2a2',
    position: '-122.0842883, 37.4219587',
    notes: 'Nothing',
  ),
  Product(
    itemNr: 'ID202',
    itemDescription: 'Möbel 2',
    category: 'Inventory 2019',
    quantity: 2,
    type: "Pcs",
    date: '2022-01-23',
    photoUrl:
        'https://firebasestorage.googleapis.com/v0/b/products-a8e76.appspot.com/o/scaled_a91bec8e-3455-43f5-b4bf-987684ad329c9017529077014155706.jpg?alt=media&token=880667f4-099b-48d1-92fd-19aa9e107930',
    position: '-122.0842883, 37.4219587',
    notes: 'Nothing',
  ),
  Product(
    itemNr: 'ID203',
    itemDescription: 'Sofa 2',
    category: 'Inventory 2018',
    quantity: 2,
    type: "Pcs",
    date: '2022-01-23',
    photoUrl:
        'https://firebasestorage.googleapis.com/v0/b/products-a8e76.appspot.com/o/scaled_557bc1a2-67ba-4b03-af72-5e8c9f4211ed8957048509593747595.jpg?alt=media&token=bffe53c3-6901-485e-84ca-0a9622dcf2a2',
    position: '-122.0842883, 37.4219587',
    notes: 'Nothing',
  ),
  Product(
    itemNr: 'ID202',
    itemDescription: 'Möbel 2',
    category: 'Inventory 2017',
    quantity: 2,
    type: "Pcs",
    date: '2022-01-23',
    photoUrl:
        'https://firebasestorage.googleapis.com/v0/b/products-a8e76.appspot.com/o/scaled_a91bec8e-3455-43f5-b4bf-987684ad329c9017529077014155706.jpg?alt=media&token=880667f4-099b-48d1-92fd-19aa9e107930',
    position: '-122.0842883, 37.4219587',
    notes: 'Nothing',
  ),
  Product(
    itemNr: 'ID203',
    itemDescription: 'Sofa 2',
    category: 'Inventory 2016',
    quantity: 2,
    type: "Pcs",
    date: '2022-01-23',
    photoUrl:
        'https://firebasestorage.googleapis.com/v0/b/products-a8e76.appspot.com/o/scaled_557bc1a2-67ba-4b03-af72-5e8c9f4211ed8957048509593747595.jpg?alt=media&token=bffe53c3-6901-485e-84ca-0a9622dcf2a2',
    position: '-122.0842883, 37.4219587',
    notes: 'Nothing',
  ),
];

List csvImport = [
  "Werkbank Rechteck;EG-Durchgang;Produktion;DE0021;12000",
  "Werkbank Rechteck;EG-Durchgang;Produktion;DE0001;70123",
  "Regal;EG;Produktion;DE0008;56091",
  "Tisch Rechteck;Montage;Produktion;DE0839;88888",
];

List<Product> generateProduct() {
  List<Product> listProductsTEst = [];
  List tmp = [];
  List converted = [];
  for (var item in csvImport) {
    tmp = item.split(";");
    print(tmp);
    converted.add(tmp);
  }
  print(converted.length);
  for (var i in converted) {
    print(i);
    listProductsTEst.add(Product(
      itemNr: i[3],
      itemDescription: i[0],
      category: 'Inventory 2022',
      quantity: 1,
      type: "Pcs",
      date: '2022-01-23',
      photoUrl:
          'https://firebasestorage.googleapis.com/v0/b/products-a8e76.appspot.com/o/scaled_557bc1a2-67ba-4b03-af72-5e8c9f4211ed8957048509593747595.jpg?alt=media&token=bffe53c3-6901-485e-84ca-0a9622dcf2a2',
      position: i[1],
      notes: i[4],
    ));
    print(listProductsTEst);
    print("\n");
  }

  print(listProductsTEst);
  return listProductsTEst;
}
