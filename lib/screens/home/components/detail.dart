import 'package:flutter/material.dart';
import 'package:mygamelist/config.dart';
import 'package:mygamelist/model/gog.dart';
import 'package:mygamelist/model/steam.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';

class Detail extends StatefulWidget {
  Function callPage;
  int activeIndex = 0;
  Detail({required this.callPage, Key? key}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Future<List<GOG>> consultarPrecoGog(gogAppid) async {
    var gogPrice;
    http.Response responseGOGPrice = await http
        .get(Uri.parse("$apiGOGPrice${gogAppid}/prices?countryCode=BR"));
    //print(responseGOGPrice.statusCode);
    final jsonDataPriceGOG = jsonDecode(responseGOGPrice.body);
    //print('Teste');
    http.Response responseGOGDetail =
        await http.get(Uri.parse("$apiGOG${gogAppid}"));
    final jsonDataApiGOG = jsonDecode(responseGOGDetail.body);
    gogUrlDetail = jsonDataApiGOG["_links"]["store"]["href"];
    gogPrice = jsonDataPriceGOG["_embedded"]["prices"][0]["finalPrice"];
    if (gogPrice != null && gogPrice.length > 0) {
      gogPrice = gogPrice.substring(0, gogPrice.length - 4);
    }
    final currencyFormatter = NumberFormat('#,##0.00', 'pt_BR');
    var format = NumberFormat.simpleCurrency(locale: 'pt_BR');
    gogPrice = "${format.currencySymbol}" +
        currencyFormatter.format(int.parse(gogPrice) / 100);
    GOG gog = GOG(appid: gogAppid, price: gogPrice);
    gogAppidDetail = gogAppid;
    gogPriceDetail = gogPrice;
    gogs.add(gog);
    http.Response responseSteam =
        await http.get(Uri.parse("$apiSteam$steamAppidDetail&cc=BR"));
    final jsonDataDetail = jsonDecode(responseSteam.body);
    ScreenShotsDetail =
        jsonDataDetail["${steamAppidDetail}"]["data"]["screenshots"];
    /*if (loginGlobal == true && validFavoriteState == false) {
      validFavorite();
    }*/
    return gogs;
  }

  void registerFavorite(appid) async {
    http.Response response = await http.put(
        Uri.parse("$api/users/$loginTextGlobal/update/"),
        body: {'favorite': appid});
  }

  validFavorite() {
    var appidFavorite = favoriteList;
    //print('Favorito usuario: $favoriteList');
    //print('Appid: $steamAppidDetail');
    for (var i in favoriteList) {
      if (i == steamAppidDetail) {
        favoriteState = true;
      }
    }
    if (favoriteState == true) {
      setState(() {
        validFavoriteState = true;
        starIcon = Icon(Icons.star, size: 45);
        starIconState = true;
        favoriteState = false;
      });
    }
  }

  favorite(appidGame) {
    if (starIconState == false) {
      favoriteList.add(steamAppidDetail);
      favoriteString = favoriteList.join(",");
      setState(() {
        starIcon = Icon(Icons.star, size: 45);
        starIconState = true;
        registerFavorite(favoriteString);
      });
    } else {
      favoriteList.remove(steamAppidDetail);
      favoriteString = favoriteList.join(",");
      setState(() {
        starIcon = Icon(Icons.star_border, size: 45);
        starIconState = false;
        registerFavorite(favoriteString);
      });
    }
  }

  Widget buildImage(String urlImage, int index) => Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        color: Colors.grey,
        child: Image.network(urlImage, fit: BoxFit.cover),
      );

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: widget.activeIndex,
        count: 4,
        effect: SlideEffect(
          dotWidth: 18,
          dotHeight: 18,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: detailVisibility,
      child: FutureBuilder(
          future: consultarPrecoGog(gogAppidDetail),
          builder: (context, snapshot) {
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
                return SafeArea(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                              onTap: () {
                                widget.callPage();
                              },
                              child: Icon(Icons.arrow_circle_left, size: 45)),
                          SizedBox(width: 10),
                          Visibility(
                            visible: loginGlobal == true ? true : false,
                            child: InkWell(
                                onTap: () {
                                  //favorite(steamAppidDetail);
                                },
                                child: starIcon),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        nameGameDetail,
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 25),
                      CardPage(
                        image: imageGameDetail,
                        nameShop: 'Steam',
                        icon: steamIcon,
                        steam: true,
                        appid: steamAppidDetail,
                        price: steamPriceDetail,
                        link: steam,
                      ),
                      CardPage(
                        image: imageGameDetail,
                        nameShop: 'GOG',
                        icon: gogIcon,
                        steam: false,
                        appid: gogAppidDetail,
                        price: gogPriceDetail,
                        link: gogUrlDetail,
                      ),
                      CarouselSlider.builder(
                        options: CarouselOptions(
                            height: 200,
                            onPageChanged: (index, reason) =>
                                setState(() => widget.activeIndex = index)),
                        itemCount: 4,
                        itemBuilder: (context, index, realIndex) {
                          final urlImage =
                              ScreenShotsDetail[index]["path_thumbnail"];
                          return buildImage(urlImage, index);
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      buildIndicator()
                    ],
                  ),
                );
              }
            }
          }),
    );
  }
}

class CardPage extends StatefulWidget {
  final String image;
  final String nameShop;
  final String icon;
  final bool steam;
  final String appid;
  final String price;
  final String link;
  const CardPage({
    required this.image,
    required this.nameShop,
    required this.icon,
    required this.steam,
    required this.appid,
    required this.price,
    required this.link,
    Key? key,
  }) : super(key: key);

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  goUrl(String pageUrl, String appid, bool steam) async {
    if (steam == true) {
      Uri url = Uri.parse('$pageUrl$appid');
      await launchUrl(url);
    } else {
      Uri url = Uri.parse('$pageUrl');
      await launchUrl(url);
    }

    /*Uri url = Uri.parse('$pageUrl$appid');
    if (await canLaunchUrl(url))
      await launchUrl(url);
    else
      throw "Could not launch $url";*/
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 30,
            child: Card(
              elevation: 10.0,
              shadowColor: Colors.grey.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                height: 130,
                width: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(widget.image),
                    )),
              ),
            ),
          ),
          Positioned(
            top: 5,
            left: 200,
            child: Container(
              height: 150,
              width: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.nameShop,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 65),
                    child: OutlinedButton.icon(
                      onPressed: () {
                        goUrl(widget.link, widget.appid, widget.steam);
                      },
                      style: OutlinedButton.styleFrom(
                          primary: Colors.white, backgroundColor: Colors.blue),
                      icon: Padding(
                        padding:
                            const EdgeInsets.only(top: 4, right: 4, bottom: 4),
                        child: Image.asset(
                          widget.icon,
                          width: 35,
                          height: 35,
                        ),
                      ),
                      label: Text(
                        widget.price,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
