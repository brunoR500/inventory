import 'dart:developer';
import '../index.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _productoProvider = new ProductProvider();

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadItems());
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadItems());
  }

  void _loadItems() async {
    List<Company> _itemsList = await companyProvider.getCompany();
    log(_itemsList.toString());
    if (_itemsList.isNotEmpty) {
      company = _itemsList[0];
    }
    prefs = await SharedPreferences.getInstance();
    logoCompany = await companyProvider.getLogo(company.logoUrl);
    setState(() {});
  }

//  List<String> lista = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: _actions(),
      ),
      body: SafeArea(
          child: MediaQuery.of(context).size.width < 1000
              ? _productsBuilder(context)
              : Row(children: [
                  Container(width: 300.0, child: MyDrawer()),
                  Container(
                      width: MediaQuery.of(context).size.width - 300.0,
                      child: _productsBuilder(context))
                ])),
      drawer: MediaQuery.of(context).size.width < 1000 ? MyDrawer() : null,
      floatingActionButton: _addProduct(context),
    );
  }

  List<Widget> _actions() {
    return [
      IconButton(
        icon: Icon(Icons.refresh),
        onPressed: () => setState(() {
          _loadItems();
        }),
      ),
    ];
  }

  Widget _addProduct(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: Theme.of(context).primaryColor,
      icon: Icon(Icons.add),
      label: const Text("Add product"),
      onPressed: () => Navigator.pushNamed(context, 'product')
          .then((value) => setState(() {})),
    );
  }

  Widget _productsBuilder(BuildContext context) {
    return FutureBuilder(
      //Firebase
      future: _productoProvider.getCategories(),
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        if (snapshot.hasData) {
//          snapshot.data.forEach((element) {
//            lista.add(element.category.toString());
//          });
//          lista.forEach((element) {
//            print(element);
//          });
//          log(lista.length.toString());
          return _productsGrid(snapshot.data);
        } else {
          return _loadingIndicator(context);
        }
      },
    );
  }

  Widget _loadingIndicator(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _productsGrid(final List<Product> products) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: kIsWeb ? 3 : 2,
        //childAspectRatio: MediaQuery.of(context).size.width /
        //    (MediaQuery.of(context).size.height / 2.1),
        mainAxisExtent: 200,
      ),
      itemCount: products.length,
      itemBuilder: (BuildContext contex, i) =>
          _productCard(contex, products[i]),
    );
  }

  Widget _productCard(BuildContext context, final Product product) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(10.0),
      child: GestureDetector(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: _productImage(product),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${product.category}',
                    style: TextStyle(fontSize: 17.0),
                    maxLines: 4,
                  ),
                ],
              ),
            )
          ],
        ),
        onTap: () => _onTapProduct(context, product),
      ),
    );
  }

  Widget _productImage(final Product product) {
    if (product.photoUrl == null) {
      return Image(
        image: AssetImage('assets/img/image-placeholder.jpg'),
        height: 100.0,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      return FadeInImage(
        image: NetworkImage(product.photoUrl),
        placeholder: AssetImage(circularProgressIndicatorSmall),
        height: 100.0,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
  }

  void _onTapProduct(BuildContext context, final Product product) {
    Navigator.pushNamed(context, 'listProduct', arguments: product);
  }
}

class MyDrawer extends StatefulWidget {
  MyDrawer({Key key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName:
                    Text(company.name, style: TextStyle(color: Colors.white)),
                accountEmail:
                    Text(company.adress, style: TextStyle(color: Colors.white)),
                currentAccountPicture: company.logoUrl != null
                    ? ClipOval(
                        child: Container(
                          height: 300,
                          width: 300,
                          color: Colors.grey.shade200,
                          child: FadeInImage(
                            image: NetworkImage(company.logoUrl),
                            placeholder:
                                AssetImage('assets/img/image-placeholder.jpg'),
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    : null,
                //decoration: BoxDecoration(color: Colors.white),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, 'home', (route) => false);
                },
              ),
              ListTile(
                leading: Icon(Icons.verified),
                title: const Text('Verifiy Document'),
                onTap: () {
                  Navigator.pushNamed(context, 'verify')
                      .then((value) => setState(() {}));
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pushNamed(context, 'settings')
                      .then((value) => setState(() {}));
                },
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: const Text('About'),
                onTap: () {
                  Navigator.pushNamed(context, 'about')
                      .then((value) => setState(() {}));
                },
              ),
            ],
          )),
          Container(
              child: Column(
            children: [
              Divider(),
              ListTile(
                  title: Text(
                'Version 0.0.1',
                textAlign: TextAlign.center,
              )),
            ],
          ))
        ],
      ),
    );
  }
}

class Content extends StatelessWidget {
  final List elements = [
    "Zero",
    "One",
    "Two",
    "Three",
    "Four",
    "Five",
    "Six",
    "Seven",
    "Eight",
    "A Million Billion Trillion",
    "A much, much longer text that will still fit"
  ];
  @override
  Widget build(context) => GridView.builder(
      itemCount: elements.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 130.0,
        crossAxisSpacing: 20.0,
        mainAxisSpacing: 20.0,
      ),
      itemBuilder: (context, i) => Card(
          child: Center(
              child: Padding(
                  padding: EdgeInsets.all(8.0), child: Text(elements[i])))));
}
