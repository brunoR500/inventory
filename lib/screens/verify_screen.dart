import 'dart:developer';
import '../index.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({Key key}) : super(key: key);

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  String scannedItem = "";
  DocPDF resultSearch = null;
  final myController = TextEditingController();
  String status = "";
  Color texts;
  //Test
  List<DocPDF> pdfs = [];

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadItems());
  }

  void _loadItems() async {
    pdfs = (await docPDFProvider.getPDFs());
    log(pdfs.length.toString());
    log(pdfs[0].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Verify Document'),
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_searchField(), SizedBox(height: 10.0), _cardResult()],
        ),
      ),
      floatingActionButton: kIsWeb ? null : _addProduct(context),
    );
  }

  Widget _searchField() {
    return TextFormField(
      cursorColor: Theme.of(context).backgroundColor,
      maxLength: 20,
      controller: myController,
      decoration: InputDecoration(
        icon: Icon(Icons.qr_code),
        labelText: 'Label text',
        labelStyle: TextStyle(
          color: Color(0xFF6200EE),
        ),
        helperText: 'Insert the content of the QR code',
        suffixIcon: IconButton(
          onPressed: () async {
            _getBarcodeText(myController.text);
            status = (resultSearch is DocPDF) ? "Ok" : "Not found";
          },
          icon: Icon(Icons.search),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF6200EE)),
        ),
      ),
    );
  }

  Color _getColor(String status) {
    switch (status) {
      case "Ok":
        log("green");
        texts = Colors.white;
        return Colors.green;
      case "Not found":
        log("red");
        texts = Colors.white;
        return Colors.red;
      default:
        texts = Colors.black;
        log("");
        return null;
    }
  }

  Widget _cardResult() {
    return Card(
      color: _getColor(status),
      child: Padding(
        padding:
            EdgeInsets.only(top: 10.0, left: 6.0, right: 6.0, bottom: 30.0),
        child: ExpansionTile(
          title: Text(
            "Status : ${status}",
            style: TextStyle(color: texts),
          ),
          children: <Widget>[
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14.0,
                  color: texts,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: '\nScanned QrCode : ',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                    text: '${scannedItem}',
                  ),
                  TextSpan(
                      text: '\nName : ',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                    text: '${resultSearch?.name ?? ''}',
                  ),
                  TextSpan(
                      text: '\nInventory name : ',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                    text: '${resultSearch?.category ?? ''}',
                  ),
                  TextSpan(
                      text: '\nCompany : ',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                    text: '${resultSearch?.companyName ?? ''}',
                  ),
                  TextSpan(
                      text: '\nDate : ',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                    text: '${resultSearch?.date ?? ''}',
                  ),
                  TextSpan(
                      text: '\nQuantity : ',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                    text: '${resultSearch?.quantity ?? ''}',
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  Widget _addProduct(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: Theme.of(context).primaryColor,
      icon: Icon(Icons.qr_code),
      label: const Text("Scan QrCode"),
      onPressed: () => _getBarcode(),
    );
  }

  Future<void> _getBarcode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      scannedItem = barcodeScanRes;
      resultSearch = _search(barcodeScanRes);
      status = (resultSearch is DocPDF) ? "Ok" : "Not found";
    });
  }

  DocPDF _search(String toSearch) {
    return pdfs.firstWhere((element) => element.id == toSearch, orElse: () {
      return null;
    });
  }

  Future<void> _getBarcodeText(String value) async {
    scannedItem = value;
    setState(() {
      resultSearch = _search(scannedItem);
      status = (resultSearch is DocPDF) ? "Ok" : "Not found";
    });
  }
}
