import 'package:flutter/material.dart';
import 'package:kambaj/auth_sreem/register_Page.dart';
import 'login_Page.dart';

class AuthSreem extends StatefulWidget {
  const AuthSreem({Key? key}) : super(key: key);

  @override
  State<AuthSreem> createState() => _AuthSreemState();
}

class _AuthSreemState extends State<AuthSreem> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: const Text(
            'Kambaj',
            style: TextStyle(
                fontFamily: 'Lobster', fontSize: 35, color: Colors.black),
          ),
          centerTitle: true,
          bottom: const TabBar(
              labelColor: Colors.black,
              labelStyle: TextStyle(
                fontFamily: 'lobster'),
              tabs:[
            Tab(
              icon: Icon(
                Icons.lock,
                color: Colors.black,),
              text: 'Login',
            ),

            Tab(
              icon: Icon(
                Icons.person,
                color: Colors.black,),
              text: 'register',
            ),
          ],
            indicatorColor: Colors.blueGrey,

          ),





        ),
        body: Container(
          child: TabBarView(
            children: [
              loginPage(),
              registerPage(),

            ],
          ),
        ),
      ),
    );
  }

















}
