import 'package:flutter/material.dart';
import 'package:mygamelist/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mygamelist/main.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: PageView(
            children: [
              GridView.builder(
                itemCount: favoriteList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (context, index) => Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: InkWell(
                    onTap: () {},
                    child: Column(
                      children: [
                        /*InkWell(
                                          child: Image.network(
                                              snapshot.data[index].image),
                                        ),*/
                        Expanded(
                          child: ListTile(
                            title: Center(child: Text('Nome do Jogo')),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
