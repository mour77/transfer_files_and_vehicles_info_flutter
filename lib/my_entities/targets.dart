

import 'package:flutter/cupertino.dart';
import 'package:transfer_files_and_vehicles_info_flutter/my_entities/utils.dart';

class Targets{

  TargetsInfo data =  TargetsInfo(id: "" , title: "", date: '', totalCost: '',  remainingCost: '', userID: '');

  Targets({required this.data});

  Targets.fromJson(Map<String, dynamic> json) {
    data = ( TargetsInfo.fromJson(json) );
  }
}



class TargetsInfo{


  String id,title, date;

  String userID;

  String totalCost;
  String  remainingCost;

  TargetsInfo({
    required this.id,
    required this.title,
    required this.date,
    required this.totalCost,
    required this.remainingCost,

    required this.userID
  });





  factory TargetsInfo.fromJson(Map<String, dynamic> json) {

    // json["results"];
    return TargetsInfo(
      id: json['id'] as String,

      title: json['title'] as String,
      date: convertTimestampToDateStr(json['date']),
      totalCost: json['total_cost'].toString(),
      remainingCost: json['remaining_cost'].toString(),
      userID: json['uid'] as String,

    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['uid'] = userID;
    data['title'] = title;
    data['total_cost'] = totalCost;
    data['remaining_cost'] = remainingCost;
    data['date'] = convertDateStrToTimestamp(date);

    return data;
  }
}











