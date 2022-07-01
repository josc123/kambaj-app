import 'package:flutter/material.dart';
import 'package:kambaj/widgets/progress_bar.dart';

class loadingDialog extends StatelessWidget
{
  final String? message;
  loadingDialog({this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35)
      ),
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          circularProgress(),
          SizedBox(height:20,width: 10,),
          Text(message! +'')

        ],
      ),


    );
  }
}
