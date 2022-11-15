import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mygamelist/model/gog.dart';
import 'package:mygamelist/model/steam.dart';

//Global Variables
String loginTextGlobal = 'Login';
bool loginGlobal = false;
bool registrationButton = true;
bool loginButton = true;
bool registrationButtons = false;
bool steamConsult = true;
var jsonDataApiSteam;
List<Steam> steams = [];
List<GOG> gogs = [];
List<Steam> steamsWithFilter = [];
bool steamFilter = false;
bool homeVisibility = true;
bool detailVisibility = false;
String favoriteString = '';
List<String> favoriteList = [];
bool validFavoriteState = false;
bool favoriteState = false;

// Detail Page
String nameGameDetail = '';
var steamAppidDetail = '';
var steamPriceDetail = '';
var imageGameDetail = '';
var gogAppidDetail = '';
var gogPriceDetail = '';
var gogUrlDetail = '';
var ScreenShotsDetail = [];
bool starIconState = false;
var starIcon = Icon(Icons.star_border, size: 45);

//API
//const String api = 'http://127.0.0.1:8000';
const String api = 'https://backend-my-game-list.herokuapp.com';
const String apiSteam = 'https://store.steampowered.com/api/appdetails?appids=';
const String apiGOG = 'https://api.gog.com/v2/games/';
const String apiGOGPrice = 'https://api.gog.com/products/';
const String apiMetacritic = 'http://www.metacritic.com/game/pc';

//Colores
var bgColor = const Color.fromARGB(255, 37, 38, 43);
var kTextColor = const Color.fromARGB(255, 56, 56, 56);
var textFieldColor = const Color(0xFF2A2D3E);
var kAppBarColor = const Color.fromARGB(255, 199, 199, 199);
var iconSearchColor = const Color.fromARGB(255, 35, 83, 243);

//Icones
const logo = 'assets/img/logo.png';
const steamIcon = 'assets/icons/steam-icon.png';
const gogIcon = 'assets/icons/gog_icon.png';

//Espaçamento
const defaultPadding = 10.0;

//Paginas
const steam = 'https://store.steampowered.com/app/';
