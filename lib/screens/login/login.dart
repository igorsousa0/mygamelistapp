import 'package:flutter/material.dart';
import 'package:mygamelist/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mygamelist/main.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
  }

  var obscureTextController = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingUser = TextEditingController();
  final TextEditingController _textEditingPassword = TextEditingController();

  consultUser(user, pass) async {
    http.Response response = await http.get(Uri.parse("$api/user/$user/"));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData["password"] == pass) {
        setState(() {
          loginTextGlobal = jsonData["username"];
          loginGlobal = true;
          favoriteString = jsonData["favorite"];
          favoriteList = favoriteString.split(',');
          showModalDialog(context, 'Login', 'Login feito com sucesso!');
        });
      } else {
        showModalDialog(context, 'Login', 'Usuário ou Senha inválido');
      }
    } else {
      showModalDialog(context, 'Login', 'Usuário ou Senha inválido');
    }
  }

  registerPage() {
    setState(() {
      loginTextGlobal = 'Cadastro';
      registrationButton = !registrationButton;
      loginButton = !loginButton;
      registrationButtons = !registrationButtons;
    });
  }

  cancelRegister() {
    setState(() {
      loginTextGlobal = 'Login';
      registrationButton = !registrationButton;
      loginButton = !loginButton;
      registrationButtons = !registrationButtons;
    });
  }

  void registerUser(user, password) async {
    http.Response response = await http.get(Uri.parse("$api/user/$user/"));
    if (response.statusCode == 200) {
      showModalDialog(context, 'Cadastro', 'Usuário está em uso');
    } else {
      response = await http.post(Uri.parse("$api/users/create/"),
          body: {'username': user, 'password': password});
      if (response.statusCode == 200) {
        showModalDialog(context, 'Cadastro', 'Usuário cadastrado com sucesso!');
        cancelRegister();
      }
    }
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
                      text == 'Login feito com sucesso!'
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
                        height: MediaQuery.of(context).size.height / 1.6,
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
                                      "Login",
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
                                      child: TextFormField(
                                        controller: _textEditingUser,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 3, color: Colors.blue),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          prefixIcon: Icon(Icons.person),
                                          labelText: "Usuário",
                                        ),
                                        validator: (String? value) {
                                          if (value != null && value.isEmpty) {
                                            return "Usuário Obrigatório";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.3,
                                      child: TextFormField(
                                        obscureText: obscureTextController,
                                        controller: _textEditingPassword,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 3, color: Colors.blue),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          prefixIcon: Icon(Icons.lock),
                                          suffixIcon: InkWell(
                                            onTap: () {
                                              setState(() {
                                                obscureTextController =
                                                    !obscureTextController;
                                              });
                                            },
                                            child: Icon(Icons.visibility),
                                          ),
                                          labelText: "Senha",
                                        ),
                                        validator: (String? value) {
                                          if (value != null && value.isEmpty) {
                                            return "Senha Obrigatório";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Visibility(
                                          visible: loginButton,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, right: 15),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                              child: OutlinedButton(
                                                style: ButtonStyle(
                                                  foregroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.white),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.blue),
                                                  shape:
                                                      MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      side: BorderSide(
                                                          color: Colors.blue),
                                                    ),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: const Text(
                                                    "Login",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    consultUser(
                                                        _textEditingUser.text,
                                                        _textEditingPassword
                                                            .text);
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Visibility(
                                                visible: registrationButtons,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10, right: 15),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.8,
                                                    child: OutlinedButton(
                                                      style: ButtonStyle(
                                                        foregroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .white),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .blue),
                                                        shape:
                                                            MaterialStateProperty
                                                                .all(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: const Text(
                                                          "Cancelar",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        cancelRegister();
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible: registrationButtons,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.8,
                                                    child: OutlinedButton(
                                                      style: ButtonStyle(
                                                        foregroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .white),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .blue),
                                                        shape:
                                                            MaterialStateProperty
                                                                .all(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: const Text(
                                                          "Cadastrar",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        if (_formKey
                                                            .currentState!
                                                            .validate()) {
                                                          registerUser(
                                                            _textEditingUser
                                                                .text,
                                                            _textEditingPassword
                                                                .text,
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: registrationButton,
                                    child: InkWell(
                                      onTap: () {
                                        registerPage();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 18),
                                        child: Container(
                                          child: RichText(
                                            text: TextSpan(
                                                style: const TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.black),
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          'Não possui conta? '),
                                                  TextSpan(
                                                      text: 'Cadastra-se',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ]),
                                          ),
                                        ),
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
