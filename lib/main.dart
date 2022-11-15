import 'package:flutter/material.dart';
import 'package:mygamelist/config.dart';
import 'package:mygamelist/screens/favorite/favorite.dart';
import 'package:mygamelist/screens/home/home.dart';
import 'package:mygamelist/screens/login/login.dart';
import 'package:mygamelist/screens/profile/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyGameList',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;
  final controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final pageViewController = PageController();

  /*@override
  void dispose() {
    super.dispose();
    pageViewController.dispose();
  }*/

  Widget favoriteWithoutLogin() => Container(
        child: Center(
            child: Text('Em construção' /*'Login necessário'*/,
                style: TextStyle(fontSize: 18))),
      );

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: pageViewController,
        children: [
          Home(),
          //loginGlobal == false ? favoriteWithoutLogin() : Favorite(),
          favoriteWithoutLogin(),
          loginGlobal == false ? Login() : User(),
        ],
      ),
      bottomNavigationBar: AnimatedBuilder(
          animation: pageViewController,
          builder: (context, snapshot) {
            return BottomNavigationBar(
              currentIndex: pageViewController.page?.round() ?? 0,
              onTap: (index) {
                pageViewController.jumpToPage(index);
              },
              iconSize: 30,
              unselectedFontSize: 15,
              showUnselectedLabels: false,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Pagina Inicial',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.star),
                  label: 'Favotito',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Usuário',
                ),
              ],
            );
          }), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
