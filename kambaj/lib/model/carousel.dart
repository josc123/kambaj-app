import 'package:cloud_firestore/cloud_firestore.dart';

class Carousel
{
  String? carouselID;
  String? miniatura;
  Timestamp ? publishedDate;
  String? status;
  String? tiendaUID;

  Carousel({
    this.carouselID,
    this.miniatura,
    this.publishedDate,
    this.status,
    this.tiendaUID,
  });

  Carousel.fromJson(Map<String,dynamic>json )
  {
    carouselID = json['carouselID'];
    miniatura = json['miniatura'];
    publishedDate = json['publishedDate'];
    status = json['status'];
    tiendaUID = json['tiendaUID'];
  }
  Map<String, dynamic>toJson()
  {

    final Map<String, dynamic> data = Map<String, dynamic>();
    data['catID'] = carouselID;
    data['miniatura'] = miniatura;
    data['publishedDate'] = publishedDate;
    data['status'] = status;
    data['tiendaUID'] = tiendaUID;


    return data;

  }
}