import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kambaj/auth_sreem/auth_sreem.dart';
import 'package:kambaj/global/global.dart';
import 'package:kambaj/mainScreens/homeScreen.dart';
import 'package:kambaj/widgets/error_dialog.dart';
import 'package:kambaj/widgets/loading_dialog.dart';
import 'package:lottie/lottie.dart';

import '../utils/My_colors.dart';
import '../widgets/custom_Text_Field.dart';

class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  formValidation() {
    if (emailController.text.isNotEmpty && passController.text.isNotEmpty) {

      //login
      loginNow();




    } else {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: 'Escriba su email/contraseña',
            );
          });
    }
  }

  loginNow() async
  {
    showDialog(
        context: context,
        builder: (c) {
          return loadingDialog(
            message: 'Comprobando credenciales',
          );
        });
    User? currentUsers;
    await firebaseAuth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim()
    ).then((auth) {
      currentUsers = auth.user!;
    }).catchError((error) {
      Navigator.pop(context);

      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          });
    });

    if (currentUsers != null)
    {
      
      readDataAndSetDataLocality(currentUsers!).then((value)
      {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (c)=>const homeScreen()));

      });

    }
  }

    Future readDataAndSetDataLocality(User currentUser) async
    {
     await FirebaseFirestore.instance.collection('kambaj')
         .doc(currentUser.uid)
         .get().then((shop) async
     {

       if(shop.exists)
       {
         await sharedPreferences!.setString('uid', currentUser.uid);
         await sharedPreferences!.setString('email', shop.data()!['tiendaEmail']);
         await sharedPreferences!.setString('name' , shop.data()!['Name']);
         await sharedPreferences!.setString('tienda',shop.data()!['tiendaName']);
         await sharedPreferences!.setString('photoUrl',shop.data()!['tiendaavatar']);

         Navigator.pop(context,);
         Navigator.push(context, MaterialPageRoute(builder: (c)=>const homeScreen()));

       }
       else
       {
         firebaseAuth.signOut();
         Navigator.pop(context,);
         Navigator.push(context, MaterialPageRoute(builder: (c)=>const AuthSreem()));

         showDialog(
             context: context,
             builder: (c) {
               return ErrorDialog(
                 message: 'no existe ningún registro',
               );
             });
       }
     });
    }






  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 50),
            alignment: Alignment.bottomCenter,
            child: Lottie.asset(
              'assets/json/75062-man-with-smartphone.json',
              width: 250,
              height: 225,
              fit: BoxFit.fill,
            ),
          ),
          Form(
            key: _formkey,
            child: Column(
              children: [
                customTextField(
                  enabled: true,
                  data: Icons.email,
                  controller: emailController,
                  hintText: "Email",
                  isObsecre: false,
                ),
                customTextField(
                  enabled: true,
                  data: Icons.lock,
                  controller: passController,
                  hintText: "Contraseña",
                  isObsecre: true,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () {
              formValidation();
            },
            child: const Text(
              'Login',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
                primary: MyColors.primaryColor,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
          ),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
