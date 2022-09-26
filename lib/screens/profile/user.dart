import 'package:flutter/material.dart';
import 'package:mygamelist/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mygamelist/main.dart';

class User extends StatefulWidget {
  const User({Key? key}) : super(key: key);

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  void initState() {
    super.initState();
  }

  var obscureTextController = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingUser = TextEditingController();
  final TextEditingController _textEditingPassword = TextEditingController();

  logout() async {
    setState(() {
      loginTextGlobal = 'Login';
      loginGlobal = false;
      showModalDialog(context, 'Login', 'Logout feito com sucesso!');
    });
  }

  Future<void> showModalDialog(BuildContext context, title, text) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text(title)),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Center(child: Text(text)),
                  const SizedBox(height: defaultPadding * 1.2),
                  TextButton(
                    child: const Text("Ok"),
                    onPressed: () {
                      text == 'Logout feito com sucesso!'
                          ? Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MyApp()), // this mainpage is your page to refresh
                              (Route<dynamic> route) => false,
                            )
                          : Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 56, 104, 250),
        body: SingleChildScrollView(
          child: SafeArea(
            top: true,
            bottom: true,
            child: Stack(
              children: [
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 4,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 1.7,
                        width: MediaQuery.of(context).size.height / 2.3,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 150),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(
                                      loginTextGlobal,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.3,
                                      child: OutlinedButton(
                                        style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.blue),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              side: BorderSide(
                                                  color: Colors.blue),
                                            ),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: const Text(
                                            "Logout",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        ),
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            logout();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 7,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 4.5,
                        width: MediaQuery.of(context).size.height / 4.3,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 25.0,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.grey[850],
                          size: 130,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
