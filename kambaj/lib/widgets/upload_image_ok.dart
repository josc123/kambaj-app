import 'package:flutter/material.dart';

class UploadDialog extends StatelessWidget
{
  final String? message;
  UploadDialog({this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35)
      ),
      title: Text(
          'presione para continuar'
      ),
      key: key,
      content:
      Text(message!),
      actions: [
        FlatButton(
          child: Text ('ok'),
          onPressed: ()
          {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
