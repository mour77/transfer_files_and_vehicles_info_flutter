

import 'package:flutter/cupertino.dart';

class Vehicles{

  VehiclesInfo data =  VehiclesInfo(id: "" , brand: "", model: '',  capacity: 0, hp: 0, kivika: 0, year: 0, userID: "");

  Vehicles({required this.data});

  Vehicles.fromJson(Map<String, dynamic> json) {
    data = ( VehiclesInfo.fromJson(json) );
  }
}



class VehiclesInfo{


  String
  id,
  brand,
  model,
  brandIDStr = '';

  String userID;

  int capacity, hp, kivika,year;

  VehiclesInfo({
    required this.id,
    required this.brand,
    required this.model,
    required this.capacity,
    required this.hp,
    required this.kivika,
    required this.year,
    required this.userID
  });





  factory VehiclesInfo.fromJson(Map<String, dynamic> json) {

    // json["results"];
    return VehiclesInfo(
      id: json['id'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      capacity: json['capacity'] as int,
      hp: json['hp'] as int,
      kivika: json['kivika'] as int,
      year: json['year'] as int,
      userID: json['userID'] as String,

    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['userID'] = userID;
    data['brand'] = brand;
    data['model'] = model;
    data['kivika'] = kivika;
    data['hp'] = hp;
    data['capacity'] = capacity;
    data['year'] = year;

    return data;
  }
}











