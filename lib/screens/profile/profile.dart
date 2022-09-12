import 'package:flutter/material.dart';
import 'package:mygamelist/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
          showModalDialog(context, 'Login', 'Login feito com sucesso!');
        });
      } else {
        showModalDialog(context, 'Login', 'Usuário ou Senha inválido');
      }
    } else {
      showModalDialog(context, 'Login', 'Usuário ou Senha inválido');
    }
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
                      Navigator.of(context).pop();
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
        backgroundColor: Colors.grey,
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
                                        Padding(
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
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: const Text(
                                                  "Acessar",
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
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.8,
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
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: const Text(
                                                  "Cadastrar",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              onPressed: () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  registerUser(
                                                      _textEditingUser.text,
                                                      _textEditingPassword
                                                          .text);
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  /*Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 1.5,
                                  child: Text(
                                    "Acessar",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontSize: 20, color: Colors.grey),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 1.5,
                                  child: Text(
                                    "Cadastrar",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontSize: 20, color: Colors.black),
                                  ),
                                ),
                              ),*/
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
                          color: Colors.lightBlue[300],
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
