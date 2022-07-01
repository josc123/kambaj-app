import 'package:flutter/material.dart';
import 'package:kambaj/utils/My_colors.dart';


circularProgress()
{
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 30),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
        MyColors.primaryColor,
      ),
    ),
  );
}


linearProgress()
{
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(top: 12),
    child: const LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
        Colors.black,
      ),
    ),
  );
}