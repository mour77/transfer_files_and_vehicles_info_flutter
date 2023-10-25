

import 'package:flutter/cupertino.dart';
import 'package:transfer_files_and_vehicles_info_flutter/my_entities/gas_types.dart';

class Vehicles{

  VehiclesInfo data =
  VehiclesInfo(id: "" , brand: "", model: '',
      gasTypeID: 0, gasTypeStr: '',
      logoPath: '' , capacity: 0, hp: 0, kivika: 0, year: 0,
      arithmosKikloforias: '', plateID: '' ,vin: '',
      userID: "");

  Vehicles({required this.data});



  Vehicles.emptyVehicle() {
    data = ( VehiclesInfo.emptyVehicle() );
  }


  Vehicles.fromJson(Map<String, dynamic> json) {
    data = ( VehiclesInfo.fromJson(json) );
  }

  Vehicles.forDropDown(String brand , String logoPath) {
    data = ( VehiclesInfo.forDropDown( brand: brand , logoPath: logoPath) );
  }


}



class VehiclesInfo{


  String
  id,
  brand,
  model,
  brandIDStr = '';

  String userID;
  String logoPath = '';
  String arithmosKikloforias = '';
  String plateID = '';
  String vin = '';

  int gasTypeID = 0;
  String gasTypeStr = '';
  int capacity,  hp, kivika,year;


  VehiclesInfo({
    required this.id,
    required this.brand,
    required this.model,
    required this.capacity,
    required this.hp,
    required this.kivika,
    required this.year,
    required this.userID,
    required this.gasTypeID,
    required this.gasTypeStr,
    required this.arithmosKikloforias,
    required this.plateID,
    required this.vin,
    required this.logoPath,
  });


  VehiclesInfo.forDropDown({required this.brand, required this.logoPath,
    this.id = '', this.model = '' ,
    this.capacity = -1, this.hp = -1, this.kivika = -1,
    this.year = -1, this.userID = ''});



  factory VehiclesInfo.emptyVehicle() {
    return VehiclesInfo(id: '',
        brand: '',
        model: '',
        capacity: 0, hp: 0, kivika: 0, year: 0,
        userID: '', gasTypeID: 0, gasTypeStr: '',
        arithmosKikloforias: "", plateID: "", vin: '', logoPath: '');
  }


  factory VehiclesInfo.fromJson(Map<String, dynamic> json) {

    // json["results"];
    return VehiclesInfo(
      id: json['id'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      gasTypeID: json['gasTypeID'] as int,
      gasTypeStr: json['gasTypeStr'] as String,
      capacity: json['capacity'] as int,
      hp: json['hp'] as int,
      kivika: json['kivika'] as int,
      year: json['year'] as int,
      logoPath: json['logoLocalPath'] as String,

      arithmosKikloforias: json['arithmos_kikloforias'] as String,
      plateID: json['plateID'] as String,
      vin: json['vin'] as String,

      userID: json['userID'] as String,

    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['userID'] = userID;
    data['brand'] = brand;
    data['model'] = model;
    data['gasTypeID'] = gasTypeID;
    data['gasTypeStr'] = gasTypeStr;
    data['kivika'] = kivika;
    data['hp'] = hp;
    data['capacity'] = capacity;
    data['logoLocalPath'] = logoPath;
    data['arithmos_kikloforias'] = arithmosKikloforias;
    data['plateID'] = plateID;
    data['vin'] = vin;
    data['year'] = year;

    return data;
  }
}











