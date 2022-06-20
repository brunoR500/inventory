import 'dart:developer';
import '../index.dart';

class ListScreen extends StatefulWidget {
  ListScreen({Key key}) : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final _productoProvider = new ProductProvider();
  final _pdfApi = pdfApi();
  Product product = Product();

  List<Product> _listProducts = [];
  List<Product> selectedProducts;

  bool sort = true;
  int _sortColumnIndex;
  bool _sortItemNr = true;
  bool _sortItemDescription = true;
  bool _sortQuantity = true;
  bool _sortType = true;
  bool _sortDate = true;
  bool _sortPosition = true;

  int _value;

  @override
  initState() {
    selectedProducts = [];
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadItems());
  }

  void _loadItems() async {
    _listProducts = (await _productoProvider.getProduct(product.category));
    //log("loadItems " + _listProducts.length.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    product = ModalRoute.of(context).settings.arguments;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('${product.category}'),
            actions: _actions(),
            //backgroundColor: Colors.green,
            bottom: const TabBar(tabs: [
              Tab(icon: Icon(Icons.format_list_numbered_rtl)),
              Tab(icon: Icon(Icons.view_list)),
            ]),
          ),
          body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildTable(_listProducts),
                _together(context),
              ]),
          floatingActionButton: _addProduct(context),
        ));
  }

  List<Widget> _actions() {
    return [
      if (selectedProducts.isNotEmpty)
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            setState(() {
              log("delete");
              selectedProducts.forEach((element) {
                _productoProvider.deleteProduct(product: element);
                _listProducts.remove(element);
              });
            });
          },
        ),
      IconButton(
        icon: Icon(Icons.refresh),
        onPressed: () => setState(() {}),
      ),
      PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem<int>(
              value: 0,
              onTap: () => Printing.layoutPdf(
                    onLayout: (PdfPageFormat format) {
                      return generatePdfInventory(format, _listProducts);
                    },
                  ),
              child: Row(
                children: [
                  Icon(Icons.print, color: Colors.black),
                  Text("  Print PDF"),
                ],
              )),
          PopupMenuItem<int>(
              value: 1,
              onTap: () async {
                final bytes =
                    await generatePdfInventory(PdfPageFormat.a4, _listProducts);
                if (kIsWeb) {
                  _pdfApi.open_FilePdf(bytes);
                } else {
                  _pdfApi.open_File("myDocument.pdf", bytes);
                }
              },
              child: Row(
                children: [
                  Icon(Icons.picture_as_pdf, color: Colors.black),
                  Text("  Save PDF"),
                ],
              )),
          PopupMenuItem<int>(
              value: 2,
              onTap: () {
                createCSVFile(_listProducts);
              },
              child: Row(
                children: [
                  //TODO : to change the icon in CSV
                  Icon(Icons.file_download, color: Colors.black),
                  Text("  Export CSV"),
                ],
              )),
        ],
      ),
    ];
  }

  Widget _addProduct(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, 'product',
              arguments: Product(category: product.category))
          .then((value) => setState(() {
                _loadItems();
              })),
    );
  }

  Widget _dropDownButton() {
    return DropdownButton(
      value: _value,
      items: [
        DropdownMenuItem(
          child: Text("Sort by Item Number"),
          value: 1,
          onTap: () {},
        ),
        DropdownMenuItem(
          child: Text("Sort by Quantity"),
          value: 2,
        ),
        DropdownMenuItem(child: Text("Sort by Date"), value: 3),
        DropdownMenuItem(child: Text("Sort by Position"), value: 4)
      ],
      onChanged: (value) {
        setState(() {
          _value = value;
        });
      },
      hint: Text("Sort the follow products"),
    );
  }

  Widget _together(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(flex: 1, child: _dropDownButton()),
        Expanded(flex: 10, child: _productsBuilder(context))
      ],
    );
  }

  Widget _productsBuilder(BuildContext context) {
    return FutureBuilder(
      //Firebase
      future: _productoProvider.getProduct(product.category),
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        if (snapshot.hasData) {
          return _products(snapshot.data);
        } else {
          return _loadingIndicator(context);
        }
      },
    );
  }

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == _sortColumnIndex) {
      if (ascending) {
        _listProducts.sort((a, b) => a.itemNr.compareTo(b.itemNr));
        log(_listProducts.toString());
      } else {
        _listProducts.sort((a, b) => b.itemNr.compareTo(a.itemNr));
        log(_listProducts.toString());
      }
    }
  }

  Widget _buildTable(final List<Product> products) {
    var myColumns = [
      DataColumn(
          label: Text("Item Nr.", style: TextStyle(fontSize: 16)),
          numeric: false,
          onSort: (columnIndex, ascending) {
            setState(() {
              if (columnIndex == _sortColumnIndex) {
                sort = _sortItemNr = ascending;
              } else {
                _sortColumnIndex = columnIndex;
                sort = _sortItemNr;
              }
              _listProducts.sort((a, b) => a.itemNr.compareTo(b.itemNr));
              if (!ascending) {
                _listProducts = _listProducts.reversed.toList();
              }
            });
          }),
      DataColumn(
          label: Text("Item Description", style: TextStyle(fontSize: 16)),
          numeric: false,
          onSort: (columnIndex, ascending) {
            setState(() {
              if (columnIndex == _sortColumnIndex) {
                sort = _sortItemDescription = ascending;
              } else {
                _sortColumnIndex = columnIndex;
                sort = _sortItemDescription;
              }
              _listProducts.sort(
                  (a, b) => a.itemDescription.compareTo(b.itemDescription));
              if (!ascending) {
                _listProducts = _listProducts.reversed.toList();
              }
            });
          }),
      DataColumn(
          label: Text("Quantity", style: TextStyle(fontSize: 16)),
          numeric: false,
          onSort: (columnIndex, ascending) {
            setState(() {
              if (columnIndex == _sortColumnIndex) {
                sort = _sortQuantity = ascending;
              } else {
                _sortColumnIndex = columnIndex;
                sort = _sortQuantity;
              }
              _listProducts.sort((a, b) => a.quantity.compareTo(b.quantity));
              if (!ascending) {
                _listProducts = _listProducts.reversed.toList();
              }
            });
          }),
      DataColumn(
          label: Text("Type", style: TextStyle(fontSize: 16)),
          numeric: false,
          onSort: (columnIndex, ascending) {
            setState(() {
              if (columnIndex == _sortColumnIndex) {
                sort = _sortType = ascending;
              } else {
                _sortColumnIndex = columnIndex;
                sort = _sortType;
              }
              _listProducts.sort(
                  (a, b) => a.type.toString().compareTo(b.type.toString()));
              if (!ascending) {
                _listProducts = _listProducts.reversed.toList();
              }
            });
          }),
      DataColumn(
          label: Text("Date", style: TextStyle(fontSize: 16)),
          numeric: false,
          onSort: (columnIndex, ascending) {
            setState(() {
              if (columnIndex == _sortColumnIndex) {
                sort = _sortDate = ascending;
              } else {
                _sortColumnIndex = columnIndex;
                sort = _sortDate;
              }
              _listProducts.sort((a, b) => a.date.compareTo(b.date));
              if (!ascending) {
                _listProducts = _listProducts.reversed.toList();
              }
            });
          }),
      DataColumn(
          label: Text("Position", style: TextStyle(fontSize: 16)),
          numeric: false,
          onSort: (columnIndex, ascending) {
            setState(() {
              if (columnIndex == _sortColumnIndex) {
                sort = _sortPosition = ascending;
              } else {
                _sortColumnIndex = columnIndex;
                sort = _sortPosition;
              }
              _listProducts.sort((a, b) => a.position.compareTo(b.position));
              if (!ascending) {
                _listProducts = _listProducts.reversed.toList();
              }
            });
          }),
    ];

    var myRows = products
        .map(
          (product) => DataRow(
              selected: selectedProducts.contains(product),
              onSelectChanged: (value) {
                print("SELECT");
                onSelectedRow(value, product);
              },
              cells: [
                DataCell(
                  Text(product.itemNr),
                  onTap: () {
                    _onTapProduct(context, product);
                  },
                ),
                DataCell(
                  Text(product.itemDescription),
                  onTap: () {
                    _onTapProduct(context, product);
                  },
                ),
                DataCell(
                  Text(product.quantity.toString()),
                ),
                DataCell(
                  Text(product.type),
                ),
                DataCell(
                  Text(product.date),
                ),
                DataCell(
                  Text(product.position),
                ),
              ]),
        )
        .toList();

    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: MediaQuery.of(context).size.width < 1000
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                    sortAscending: sort,
                    sortColumnIndex: _sortColumnIndex,
                    columns: myColumns,
                    rows: myRows),
              )
            : SingleChildScrollView(
                child: DataTable(
                    sortAscending: sort,
                    sortColumnIndex: _sortColumnIndex,
                    columns: myColumns,
                    rows: myRows),
              ));
  }

  onSelectedRow(bool selected, Product emp) async {
    setState(() {
      if (selected) {
        selectedProducts.add(emp);
      } else {
        selectedProducts.remove(emp);
      }
    });
    print(selectedProducts.length.toString());
  }

  Widget _loadingIndicator(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  void _sortProducts(List<Product> products, int value) {
    switch (value) {
      case 1:
        products.sort((a, b) => a.itemNr.compareTo(b.itemNr));
        break;
      case 2:
        products.sort((a, b) => a.quantity.compareTo(b.quantity));
        break;
      case 3:
        products.sort((a, b) => a.date.compareTo(b.date));
        break;
      case 4:
        products.sort((a, b) => a.position.toString().compareTo(b.position));
        break;
      default:
    }
  }

  Widget _products(final List<Product> products) {
    _sortProducts(products, _value);
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (BuildContext contex, i) => _product(contex, products[i]),
    );
  }

  Widget _product(BuildContext context, final Product product) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.redAccent,
      ),
      onDismissed: (DismissDirection direction) => _deleteProduct(product),
      child: _productCard(product),
    );
  }

  Widget _productCard(final Product product) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          child: Card(
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        _productImage(product),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            '${product.itemNr}',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          subtitle: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                //TextSpan(
                                //    text: 'Item description: ',
                                //    style: const TextStyle(
                                //        fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text: '${product.itemDescription}',
                                ),
                                TextSpan(
                                    text: '\nQuantity: ',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text: '${product.quantity} ${product.type}',
                                ),
                                TextSpan(
                                    text: '\nDate: ',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text: '${product.date}',
                                ),
                                TextSpan(
                                    text: '\nPosition',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text: '${product.position}',
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
          onTap: () => _onTapProduct(context, product),
        ));
  }

  Widget _productImage(final Product product) {
    if (product.photoUrl == null) {
      return Image(image: AssetImage('assets/img/image-placeholder.jpg'));
    } else {
      return FadeInImage(
        image: NetworkImage(product.photoUrl),
        placeholder: AssetImage(circularProgressIndicatorSmall),
        height: 125.0,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
  }

  void _deleteProduct(final Product product) async {
    await _productoProvider.deleteProduct(
      product: product,
    );

    setState(() {});
  }

  void _onTapProduct(BuildContext context, final Product product) {
    Navigator.pushNamed(context, 'product', arguments: product)
        .then((value) => setState(() {
              _loadItems();
            }));
  }
}
