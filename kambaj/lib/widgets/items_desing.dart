import 'package:flutter/material.dart';
import 'package:kambaj/model/items.dart';

class itemsDesingWidget extends StatefulWidget

{
  Items? model;
  BuildContext? context;
  
  itemsDesingWidget({this.model, this.context});
  
  

  @override
  State<itemsDesingWidget> createState() => _itemsDesingWidgetState();
}





class _itemsDesingWidgetState extends State<itemsDesingWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {
        //Navigator.push(context, MaterialPageRoute(builder: (c)=>SubItemsScreensPage(model: widget.model)));
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: Container(
            color: Colors.black,
            height: 375,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Image.network(widget.model!.miniatura!,
                  height: 305,
                  fit: BoxFit.fitHeight,

                ),
            SizedBox(height: 1.0,),
                Text(
                  widget.model!.longdescription!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'signatra'
                  ),

                )


                //Padding(
                 // padding: const EdgeInsets.all(20.0),
                 // child: ClipRRect(
                 //   borderRadius: BorderRadius.circular(35),
                 //   child: Container(
                 //     child: Image.network(widget.model!.tiendaavatar!,
                 //       height: 240.0,
                 //       fit: BoxFit.cover,
                 //     ),
                //    ),
                //  ),
               // ),
               // Text(
                //  widget.model!.tiendaName!,
                 // style: TextStyle(
                //    color: Colors.black,
               //     fontSize: 20
                //  ),
               // )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
















