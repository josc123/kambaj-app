import 'package:cloud_firestore/cloud_firestore.dart';

class Catergories
{
  String? catID;
  String? catInformation;
  String? catTittle;
  String? miniatura;
  Timestamp ? publishedDate;
  String? status;
  String? tiendaUID;

  Catergories({
    this.catID,
    this.catInformation,
    this.catTittle,
    this.miniatura,
    this.publishedDate,
    this.status,
    this.tiendaUID,
  });

  Catergories.fromJson(Map<String,dynamic>json )
  {
    catID = json['catID'];
    catInformation = json['catInformation'];
    catTittle = json['catTittle'];
    miniatura = json['miniatura'];
    publishedDate = json['publishedDate'];
    status = json['status'];
    tiendaUID = json['tiendaUID'];
  }
  Map<String, dynamic>toJson()
  {

    final Map<String, dynamic> data = Map<String, dynamic>();
    data['catID'] = catID;
    data['catInformation'] = catInformation;
    data['catTittle'] = catTittle;
    data['miniatura'] = miniatura;
    data['publishedDate'] = publishedDate;
    data['status'] = status;
    data['tiendaUID'] = tiendaUID;


    return data;

  }
}