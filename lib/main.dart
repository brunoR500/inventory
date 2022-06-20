import 'index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      scrollBehavior: customScroll(),
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) => HomeScreen(),
        'listProduct': (BuildContext context) => ListScreen(),
        'product': (BuildContext context) => ProductScreen(),
        'settings': (BuildContext context) => SettingsScreen(),
        'verify': (BuildContext context) => VerifyScreen(),
        'about': (BuildContext context) => AboutScreen(),
      },
    );
  }
}
