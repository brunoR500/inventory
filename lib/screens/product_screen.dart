import 'dart:developer';
import '../index.dart';

class ProductScreen extends StatefulWidget {
  ProductScreen({Key key}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _productoProvider = ProductProvider();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  String _autocompleteSelection;

  Product _product = Product();
  bool _saving = false;
  XFile _image;
  var imagePicker;

  List<String> _listProducts = [];
  String typQuantity = 'Stk';

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadItems());
  }

  void _loadItems() async {
    List<Product> _itemsList = (await _productoProvider.getCategories());
    _itemsList.forEach((element) {
      _listProducts.add(element.category.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context).settings.arguments;

    if (product != null) {
      _product = product;
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Product Add/Update'),
        actions: _actions(),
      ),
      body: _forms(),
    );
  }

  List<Widget> _actions() {
    return [
      //IconButton(
      //  icon: Icon(Icons.ac_unit),
      //  onPressed: () => _saveProductsTest(),
      //),
      IconButton(
        icon: Icon(Icons.save),
        onPressed: () => _submit(),
      ),
    ];
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(8),
            elevation: 10,
            titlePadding: const EdgeInsets.all(0.0),
            title: Container(
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                  _getCloseButton(context),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Column(
                      children: [
                        Text(
                          "Choose option",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ]))),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _getPhoto(ImageSource.gallery);
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    title: Text("Gallery"),
                    leading: Icon(
                      Icons.account_box,
                      color: Colors.blue,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _getPhoto(ImageSource.camera);
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    title: Text("Camera"),
                    leading: Icon(
                      Icons.camera,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _getCloseButton(context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          alignment: FractionalOffset.topRight,
          child: GestureDetector(
            child: Icon(
              Icons.clear,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _forms() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: <Widget>[
                  _viewPhotoSelection(),
                  SizedBox(height: 20.0),
                  _nameButton(),
                  SizedBox(height: 10.0),
                  _itemDescriptionField(),
                  SizedBox(height: 10.0),
                  _category(),
                  SizedBox(height: 10.0),
                  _quantityTyp(),
                  SizedBox(height: 10.0),
                  _positionButton(),
                  SizedBox(height: 10.0),
                  _notes(),
                  SizedBox(height: 20.0),
                  //_saveButton(),
                ],
              ),
            )),
      ),
    );
  }

  Widget _viewPhotoSelection() {
    return GestureDetector(
      onTap: () {
        _showChoiceDialog(context);
      },
      child: _viewPhoto(),
    );
  }

  Widget _viewPhoto() {
    if (_product.photoUrl != null) {
      return FadeInImage(
        image: NetworkImage(_product.photoUrl),
        placeholder: AssetImage(circularProgressIndicatorSmall),
        height: kIsWeb ? 400 : 350,
        width: double.infinity,
        fit: BoxFit.scaleDown,
      );
    } else {
      if (_image != null) {
        return Container(
          child: kIsWeb
              ? Image.network(_image.path)
              : Image.file(
                  File(_image.path),
                  height: 300.0,
                  fit: BoxFit.scaleDown,
                ),
        );
      } else {
        return Container(
          child: Image.asset(
            'assets/img/image-placeholder.jpg',
            height: 300.0,
            fit: BoxFit.scaleDown,
          ),
        );
      }
    }
  }

  Widget _itemDescriptionField() {
    return Container(
        child: TextFormField(
      key: Key(_product.itemDescription),
      initialValue: _product.itemDescription,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Item Description',
        //border: OutlineInputBorder(),
      ),
      onSaved: (value) => _product.itemDescription = value,
    ));
  }

  Widget _category() {
    return TextFormField(
      initialValue: '${_product.category}',
      decoration: InputDecoration(
        labelText: 'Inventory Name',
        //border: OutlineInputBorder(),
      ),
      onSaved: (value) => _product.category = value,
    );
  }

  Widget _quantityTyp() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
            flex: 3,
            child: Container(
              child: TextFormField(
                initialValue: '${_product.quantity}',
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  //border: OutlineInputBorder(),
                ),
                onSaved: (value) => _product.quantity = int.parse(value),
              ),
            )),
        SizedBox(
          width: 8,
        ),
        Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(top: 10),
              child: DropdownButtonFormField(
                value: _product.type,
                decoration: InputDecoration(
                  //border: OutlineInputBorder(),
                  labelText: "Type",
                ),
                //icon: const Icon(Icons.arrow_downward),
                //elevation: 16,
                //style: const TextStyle(fontSize: 5),

                onChanged: (String newValue) {
                  setState(() {
                    _product.type = newValue;
                  });
                },
                items: <String>[
                  'Pcs',
                  'Kg',
                  'g',
                  'm',
                  "cm",
                  "mm",
                  "L",
                  "ml",
                  "€"
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ))
      ],
    );
  }

  Widget _position() {
    return Container(
        child: TextFormField(
      key: Key(_product.position),
      initialValue: _product.position,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Position',
        //border: OutlineInputBorder(),
      ),
      onSaved: (value) => _product.position = value,
    ));
  }

  Widget _positionButton() {
    return Row(
      children: [
        Flexible(
          child: TextFormField(
            key: Key(_product.position),
            initialValue: _product.position,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Position',
              //border: OutlineInputBorder(),
            ),
            onSaved: (value) => _product.position = value,
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Container(
          child: ElevatedButton.icon(
              onPressed: _getPosition,
              icon: Icon(Icons.gps_fixed),
              label: Text("GPS")),
        )
      ],
    );
  }

  Widget _notes() {
    return Container(
        child: TextFormField(
      key: Key(_product.notes),
      initialValue: _product.notes,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Notes',
        //border: OutlineInputBorder(),
      ),
      onSaved: (value) => _product.notes = value,
    ));
  }

  Widget _nameButton() {
    return Row(
      children: [
        Flexible(
          child: TextFormField(
            key: Key(_product.itemNr),
            initialValue: _product.itemNr,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Item Nr.',
              //border: OutlineInputBorder(),
            ),
            onSaved: (value) => _product.itemNr = value,
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Container(
          child: ElevatedButton.icon(
              onPressed: _getBarcode,
              icon: Icon(Icons.qr_code),
              label: Text("Barcodescan")),
        )
      ],
    );
  }

  Widget _onlyName() {
    return Row(
      children: [
        Flexible(
          child: TextFormField(
            key: Key(_product.itemNr),
            initialValue: _product.itemNr,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Item Nr.',
              //border: OutlineInputBorder(),
            ),
            onSaved: (value) => _product.itemNr = value,
          ),
        ),
      ],
    );
  }

  Future<void> _getBarcodeString() async {
    print(_product.itemNr);
    _product.itemNr = "barcode01010";
    print(_product.itemNr);
    setState(() {});
  }

  Future<void> _getBarcode() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _product.itemNr = barcodeScanRes;
    });
  }

  Future<void> _getPosition() async {
    log("presed");
    Position position = await determinePosition();
    String long = position.longitude.toString();
    String lat = position.latitude.toString();
    setState(() {
      log("${long}" + ", " + "${lat}");
      _product.position = "${long}" + ", " + "${lat}";
    });
  }

  Widget _quantity() {
    return TextFormField(
      initialValue: '${_product.quantity}',
      keyboardType: TextInputType.numberWithOptions(
        decimal: true,
      ),
      decoration: InputDecoration(
        labelText: 'Quantity',
      ),
      onSaved: (value) => _product.quantity = int.parse(value),
    );
  }

  Widget _saveButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0))),
      icon: Icon(Icons.save),
      label: Text('Save'),
      onPressed: _saving ? null : _submit,
    );
  }

  void _submit() async {
    final valid = _formKey.currentState.validate();
    if (!valid) {
      return;
    }

    _formKey.currentState.save();
    _saving = true;
    setState(() {});
    //Firebase
    await _uploadPhoto();

    _product.date = DateTime.now().toString().split(" ")[0];

    if (_product.id == null) {
      _saveProduct();
    } else {
      _updateProduct();
    }
  }

//Firebase
  void _saveProduct() async {
    final saved = await _productoProvider.addProduct(product: _product);
    final message = saved ? 'New product saved' : 'Error to save the product';
    _viewAlert(message, saved ? Colors.green : Colors.red);

    _navigateBack(saved);
  }

  void _saveProductsTest() async {
    log("GENERATE PRODUCT TEST");
    List<Product> _testListProducts = generateProduct();
    //List<Product> _testListProducts = listTestCategoris;
    print(_testListProducts);
    for (var item in _testListProducts) {
      await _productoProvider.addProduct(product: item);
    }
    log("DONE");
  }

//  void _saveProduct() async {
//    final saved = await _productoProvider.addProductUrl(_product, _image);
//    final message = saved ? 'New product saved' : 'Error to save the product';
//    _viewAlert(message, saved ? Colors.green : Colors.red);
//    _navigateToHome(saved);
//  }

  void _updateProduct() async {
    final updated = await _productoProvider.updateProduct(product: _product);
    final message = updated ? 'Product updated' : 'Error to update the product';
    _viewAlert(message, updated ? Colors.green : Colors.red);
    _navigateBack(updated);
  }

  void _viewAlert(final String message, final Color color) {
    final snackbar = SnackBar(
      backgroundColor: color,
      content: Text('$message'),
      duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void _navigateBack(final bool navigate) {
    if (navigate) {
      Future.delayed(
        Duration(milliseconds: 1500),
        () => Navigator.pop(context),
      );
    }
  }

  void _getPhoto(final ImageSource source) async {
    imagePicker = new ImagePicker();
    XFile pickedFile = await imagePicker.pickImage(
        source: source,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.front);

    if (pickedFile != null) {
      print("-------------- " + pickedFile.path);

      _product.photoUrl = null;
      setState(() {
        _image = XFile(pickedFile.path);
      });
    }
  }

  Future<void> _uploadPhoto() async {
    print(_image);
    if (_image != null) {
      final url = await _productoProvider.uploadFile(_image);
      //final url ="https://upload.wikimedia.org/wikipedia/commons/3/3e/Phalaenopsis_JPEG.png";
      if (url != null) {
        _product.photoUrl = url;
      }
    }
  }
}
