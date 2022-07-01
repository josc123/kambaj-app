import 'package:cloud_firestore/cloud_firestore.dart';

class Items
{
  String? catID;
  String? itemTittle;
  String? itemsID;
  String? longdescription;
  Timestamp ? publishedDate;
  String? miniatura;
  String? price;
  String? shortinformation;
  String? status;
  String? tiendaName;
  String? tiendaUID;

  Items({
    this.catID,
    this.itemTittle,
    this.itemsID,
    this.longdescription,
    this.publishedDate,
    this.miniatura,
    this.price,
    this.shortinformation,
    this.status,
    this.tiendaName,
    this.tiendaUID,

  });

  Items.fromJson(Map<String,dynamic>json )
  {
    catID = json['catID'];
    itemTittle = json['itemTittle'];
    itemsID = json['itemsID'];
    longdescription = json['longdescription'];
    publishedDate = json['publishedDate'];
    miniatura = json['miniatura'];
    price = json['price'];
    shortinformation = json['shortinformation'];
    status = json['status'];
    tiendaName = json['tiendaName'];
    tiendaUID = json['tiendaUID'];
  }
  Map<String, dynamic>toJson()
  {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['catID'] = catID ;
    data['itemTittle'] =  itemTittle ;
    data['itemsID'] = itemsID ;
    data['longdescription'] = longdescription  ;
    data['publishedDate'] = publishedDate;
    data['miniatura'] = miniatura;
    data['price'] = price;
    data['shortinformation'] = shortinformation;
    data['status'] =status ;
    data['tiendaName'] =tiendaName ;
    data ['tiendaUID'] = tiendaUID;


    return data;

  }






}