import 'package:flutter/material.dart';
import 'package:mygamelist/model/gog.dart';
import 'package:mygamelist/model/steam.dart';
import 'package:mygamelist/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mygamelist/screens/home/components/detail.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String steamNameFilter = '';
  var gogPrice;
  static var gogAppids = [];
  @override
  void initState() {
    super.initState();
  }

  changeStateSteam(String text) {
    setState(() {
      steamsWithFilter = [];
      steamNameFilter = text;
      steamFilter = true;
      steamConsult = true;
    });
  }

  consultarPrecoGog(gogAppid) async {
    var jsonDataGOG;
    http.Response responseGOGPrice = await http
        .get(Uri.parse("$apiGOGPrice${gogAppid}/prices?countryCode=BR"));
    final jsonDataPriceGOG = jsonDecode(responseGOGPrice.body);
    http.Response responseGOGDetail =
        await http.get(Uri.parse("$apiGOG${gogAppid}"));
    final jsonDataApiGOG = jsonDecode(responseGOGDetail.body);
    jsonDataGOG = jsonDataApiGOG;
    gogPrice = jsonDataPriceGOG["_embedded"]["prices"][0]["finalPrice"];
    if (gogPrice != null && gogPrice.length > 0) {
      gogPrice = gogPrice.substring(0, gogPrice.length - 4);
    }
    final currencyFormatter = NumberFormat('#,##0.00', 'pt_BR');
    var format = NumberFormat.simpleCurrency(locale: 'pt_BR');
    gogPrice = "${format.currencySymbol}" +
        currencyFormatter.format(int.parse(gogPrice) / 100);
  }

  callDetailPage(nameGame, steamAppid, steamPrice, imageGame, gogAppid) {
    setState(() {
      homeVisibility = !homeVisibility;
      detailVisibility = !detailVisibility;
      nameGameDetail = nameGame;
      steamAppidDetail = steamAppid;
      steamPriceDetail = steamPrice;
      imageGameDetail = imageGame;
      gogAppidDetail = gogAppid;
    });
    //consultarPrecoGog(gogAppid);
  }

  callHomePage() {
    setState(() {
      homeVisibility = !homeVisibility;
      detailVisibility = !detailVisibility;
      starIcon = Icon(Icons.star_border, size: 45);
      //validFavoriteState = false;
    });
  }

  Future<List<Steam>> consultarDados() async {
    var jsonDataGOG;
    int qtd = 0;
    List screenShotList = [];

    if (steamConsult == true) {
      if (steams.isEmpty == false && steamFilter == false) {
        return steams;
      } else if (steamFilter == true && steamNameFilter == '') {
        return steams;
      }
      http.Response responseApiSteam =
          await http.get(Uri.parse("$api/steamapi/?name=$steamNameFilter"));
      jsonDataApiSteam = jsonDecode(responseApiSteam.body);
      http.Response responseApiGOG = await http.get(Uri.parse("$api/gog/"));
      var jsonDataApiGOG = jsonDecode(responseApiGOG.body);
      for (var i in jsonDataApiGOG) {
        var gogAppid = i["appid"];
        gogAppids.add(gogAppid);
      }
      steamConsult = false;
      for (var i in jsonDataApiSteam) {
        var steamAppid = i["appid"];
        http.Response responseSteam =
            await http.get(Uri.parse("$apiSteam$steamAppid&cc=BR"));
        final jsonDataDetail = jsonDecode(responseSteam.body);
        //var scoreGame = jsonDataDetail["$steamAppid"]["data"]["metacritic"];
        /*if (scoreGame == null) {
        scoreGame = null;
      } else {
        scoreGame =
            jsonDataDetail["$steamAppid"]["data"]["metacritic"]["score"];
      }*/
        String steamPrice = jsonDataDetail["$steamAppid"]["data"]
            ["price_overview"]["final_formatted"];
        var format = NumberFormat.simpleCurrency(locale: 'pt_BR');
        steamPrice = steamPrice.substring(3, steamPrice.length);
        steamPrice = "${format.currencySymbol}" + steamPrice;
        Steam steam = Steam(
            appid: i["appid"],
            name: i["name"],
            image: jsonDataDetail["$steamAppid"]["data"]["header_image"],
            score: 6, //scoreGame,
            price: steamPrice);
        if (steamFilter == true && steamNameFilter != '') {
          steamsWithFilter.add(steam);
        } else {
          steams.add(steam);
        }
      }
    }
    if (steamFilter == true) {
      steamFilter = false;
      return steamsWithFilter;
    } else {
      return steams;
    }
    //http.Response responseApiGOG = await http.get(Uri.parse("$api/gog/"));
    //var jsonDataApiGOG = jsonDecode(responseApiGOG.body);
    /*for (var i in jsonDataApiGOG) {
      var gogAppid = i["appid"];
      gogAppids.add(gogAppid);
    }*/
    //return steams;
  }

  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: FutureBuilder(
        future: consultarDados(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Algum error ocorreu'),
              );
            } else {
              return Container(
                child: Column(
                  children: [
                    Visibility(
                      visible: homeVisibility,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                                hintText: 'Procurar',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 5.0),
                                    borderRadius: BorderRadius.circular(20.0)),
                                suffixIcon: InkWell(
                                    onTap: () {
                                      changeStateSteam(controller.text);
                                    },
                                    child: const Icon(Icons.search))),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: homeVisibility,
                      child: Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: PageView(
                              children: [
                                GridView.builder(
                                  itemCount: snapshot.data.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10),
                                  itemBuilder: (context, index) => Card(
                                    semanticContainer: true,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: InkWell(
                                      onTap: () {
                                        callDetailPage(
                                          snapshot.data[index].name,
                                          snapshot.data[index].appid,
                                          snapshot.data[index].price,
                                          snapshot.data[index].image,
                                          gogAppids[index],
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          InkWell(
                                            child: Image.network(
                                                snapshot.data[index].image),
                                          ),
                                          Expanded(
                                            child: ListTile(
                                              leading:
                                                  Icon(Icons.desktop_windows),
                                              title: Text(
                                                  snapshot.data[index].name),
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
                      ),
                    ),
                    Detail(
                      callPage: callHomePage,
                    )
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}
