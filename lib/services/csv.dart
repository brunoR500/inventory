import 'dart:convert';
import '../index.dart';

String csv;

Future createCSVFile(List<Product> data) async {
  List<List<dynamic>> rows = [];
  rows.add([
    "id",
    "item nr.",
    "item description",
    "quantity",
    "type",
    "category",
    "position",
    "date",
    "notes"
  ]);

  List<dynamic> row;

  for (int i = 0; i < data.length; i++) {
    row = [];
    row.add(data[i].id);
    row.add(data[i].itemNr);
    row.add(data[i].itemDescription);
    row.add(data[i].quantity);
    row.add(data[i].type);
    row.add(data[i].category);
    row.add(data[i].position);
    row.add(data[i].date);
    row.add(data[i].notes);
    rows.add(row);
  }

  csv = const ListToCsvConverter().convert(rows);

  if (kIsWeb) {
    downloadCSVWeb(csv);
  } else {
    downloadCSVMobile(csv);
  }
}

Future<void> downloadCSVWeb(String csv) async {
  final content = base64Encode(csv.codeUnits);
  final url = 'data:text/csv;base64,$content';
  await launch(url);
}

Future<void> downloadCSVMobile(String csv) async {
  final dir = await getExternalStorageDirectory();
  final file = File('${dir.path}/exported.csv');

  await file.writeAsString(csv);
  await OpenFile.open(file.path);
}
