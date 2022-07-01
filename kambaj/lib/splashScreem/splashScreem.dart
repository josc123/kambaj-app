import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kambaj/global/global.dart';
import 'package:kambaj/mainScreens/homeScreen.dart';
import '../auth_sreem/auth_sreem.dart';

class splashScreem extends StatefulWidget {
  const splashScreem({Key? key}) : super(key: key);

  @override
  State<splashScreem> createState() => _splashScreemState();
}

class _splashScreemState extends State<splashScreem> {

  StartTimer()
  {
    Timer(Duration(seconds: 5),() async
    {
      // if user is loggeding already
      if(firebaseAuth.currentUser!= null)
        {
          Navigator.push(context, MaterialPageRoute(builder: (c)=>homeScreen()));
        }
      else
      //if user is not loggedin already
        {
          Navigator.push(context, MaterialPageRoute(builder: (c)=>AuthSreem()));
        }

    });
  }

  @override
  void initState() {
    // TODO: implement initState

    StartTimer();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Image.asset('assets/img/logo cambak.png'),

              Padding(padding:
                  EdgeInsets.only(left:200.0,top: 0),
                child: Text(
                  'diseños para ti',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                  color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Valera',
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
