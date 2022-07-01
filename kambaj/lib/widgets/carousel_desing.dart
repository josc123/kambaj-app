import 'package:flutter/material.dart';
import 'package:kambaj/model/carousel.dart';


class carouselDesingWidget extends StatefulWidget

{
  Carousel? model;
  BuildContext? context;

  carouselDesingWidget({this.model, this.context});



  @override
  State<carouselDesingWidget> createState() => _carouselDesingWidgetState();
}





class _carouselDesingWidgetState extends State<carouselDesingWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {
       // Navigator.push(context, MaterialPageRoute(builder: (c)=>carouselScreen(model: widget.model)));
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: Container(
            color: Colors.black,
            height: 350,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Image.network(widget.model!.miniatura!,
                  height: 305,
                  fit: BoxFit.fitHeight,

                ),
                SizedBox(height: 1.0,),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
















