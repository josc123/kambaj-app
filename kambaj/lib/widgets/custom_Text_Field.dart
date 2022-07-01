import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/My_colors.dart';


class customTextField extends StatelessWidget {
  final TextEditingController? controller;
  final IconData? data;
  final String? hintText;
  bool? isObsecre = true;
  bool?  enabled = true;

  customTextField({
    this.controller,
    this.data,
    this.hintText,
    required this.enabled,
    this.isObsecre,
  });

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(1.0,0.5),
            blurRadius: 2.0
          )
        ],
        borderRadius: BorderRadius.circular(100),
      ),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(top: 20, left: 25 , right: 25),


      child: TextFormField(
        enabled: enabled,
        controller: controller,
        obscureText: isObsecre!,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            data,
            color:  MyColors.primaryColor,
          ),
          focusColor: Theme.of(context).primaryColor,
          hintText: hintText,
          hintStyle: TextStyle(
            color: MyColors.primaryColor
          )


        )
      ),


    );
  }
}
