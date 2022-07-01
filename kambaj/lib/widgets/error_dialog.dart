import 'package:flutter/material.dart';
import 'package:kambaj/utils/My_colors.dart';

class ErrorDialog extends StatelessWidget
{
  final String? message;
  ErrorDialog({this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35)
      ),
      title: Text(
        'Alerta!!'
      ),
      key: key,
      content:
      Text(message!),
      actions: [
        FlatButton(
          child: Text ('OK'),
          onPressed: ()
          {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
