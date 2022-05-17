

import 'package:supercab_admin/Utils/model/airportNameModel.dart';
import 'package:supercab_admin/Utils/model/cityModel.dart';

List<CityNameModel> cityNamesList(context) => [
  CityNameModel(name:'Melbourne',index: '0'),
  CityNameModel(name:'Sydney',index: '1'),
  CityNameModel(name:'Adelaide',index :'2'),
  CityNameModel(name:'Perth',index: '3'),
  CityNameModel(name:'Brisbane',index: '4'),
  CityNameModel(name:'Canberra',index: '5'),
  CityNameModel(name:'Darwin',index: '6'),
  CityNameModel(name:'Gold Cost',index: '7'),
  CityNameModel(name:'Cairns',index: '8')
];


List<AirportNameModel> airPortNamesListForCity(context) => [
  AirportNameModel(name:'Adelaide Airport',index:'0'),
  AirportNameModel(name:'Brisbane Airport',index:'1'),
  AirportNameModel(name:'Cairns Airport',index: '2'),
  AirportNameModel(name:'Canberra Airport',index: '3'),
  AirportNameModel(name:'Darwin Airport',index: '4'),
  AirportNameModel(name:'Gold Cost Airport',index: '5'),
  AirportNameModel(name:'Melbourne Tullamarine Airport',index: '6'),
  AirportNameModel(name:'Melbourne Avalon Airport',index: '7'),
  AirportNameModel(name:'Perth Airport',index:'8'),
  AirportNameModel(name:'Sydney Airport',index: '9')
];

List<AirportNameModel> airPortNamesList(context) => [
  //'Adelaide Airport',
  //'Brisbane Airport',
  //'Cairns Airport',
  //'Canberra Airport',
  //'Darwin Airport',
  //'Gold Cost Airport',
  AirportNameModel(name:'Melbourne Tullamarine Airport',index: '0'),
  AirportNameModel(name:'Melbourne Avalon Airport',index: '1'),
  //'Perth Airport',
  //'Sydney Airport'
];