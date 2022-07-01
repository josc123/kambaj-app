import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kambaj/global/global.dart';
import 'package:kambaj/mainScreens/homeScreen.dart';
import 'package:kambaj/utils/My_colors.dart';
import 'package:kambaj/widgets/custom_Text_Field.dart';
import 'package:kambaj/widgets/error_dialog.dart';
import 'package:kambaj/widgets/loading_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';

class registerPage extends StatefulWidget {
  const registerPage({Key? key}) : super(key: key);

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController nameSellerController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confimpassController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  Position? position;
  List<Placemark>? placeMarks;

  String sellerImageURL = '';
  String completeAddress = '';





  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageXFile;
    });
  }

  getCurrentLocation() async {
    Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    position = newPosition;
    placeMarks =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);

    Placemark pMark = placeMarks![0];
    completeAddress =
        '${pMark.subThoroughfare}  ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode} , ${pMark.country} ';

    locationController.text = completeAddress;
  }

  Future<void> formValidation() async {
    if (imageXFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: 'Seleccione una imagen',
            );
          });
    } else {
      if (passController.text == confimpassController.text) {
        if (confimpassController.text.isNotEmpty &&
            emailController.text.isNotEmpty &&
            phoneController.text.isNotEmpty &&
            nameSellerController.text.isNotEmpty&&
            locationController.text.isNotEmpty) {
          //start uploading image

          showDialog(
              context: context,
              builder: (c) {
                return loadingDialog(
                  message: 'espere',
                );
              });

          String filename = DateTime.now().millisecondsSinceEpoch.toString();
          fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref().child('kambaj').child(filename);
          fStorage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
          fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
          await taskSnapshot.ref.getDownloadURL().then((url) {
            sellerImageURL = url;

            //save info to firestore

            authkambajAndSignUp();

          });



        } else {
          showDialog(
              context: context,
              builder: (c) {
                return ErrorDialog(
                  message:
                      'Por favor escriba la información completa para el registro',
                );
              });
        }
      } else {
        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: 'La contraseña no coincide',
              );
            });
      }
    }
  }


  void authkambajAndSignUp() async {
    User? currentUser;

    await firebaseAuth.createUserWithEmailAndPassword(

      email: emailController.text.trim(),
      password: passController.text.trim(),
    ).then((auth)
    {
      currentUser = auth.user;
    }).catchError((error){
      Navigator.pop(context);

      showDialog(
          context: context,
          builder: (c)
          {
            return ErrorDialog(
              message: error.message.toString(),
            );
          }
      );

    });

    if(currentUser != null)
      {
        saveDataFirestore(currentUser!).then((value)
        {
          Navigator.pop(context);
          //send user to home page
          Route newRoute = MaterialPageRoute(builder: (c)=> const homeScreen());
          Navigator.pushReplacement(context, newRoute);

        });
      }


  }

  Future saveDataFirestore(User currentUsers) async {
    FirebaseFirestore.instance.collection('kambaj').doc(currentUsers.uid).set(
        {
          'tiendaUID': currentUsers.uid,
          'tiendaEmail': currentUsers.email,
          'Name': nameController.text.trim(),
          'tiendaName':nameSellerController.text.trim(),
          'tiendaavatar': sellerImageURL,
          'tiendaphone': phoneController.text.trim(),
          'adress': completeAddress,
          'status': 'aproved',
          'earnigs' : 0.0,
          'lat' : position!.latitude,
          'lng' : position!.latitude
        });


    // save data locally
    SharedPreferences? sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('uid', currentUsers.uid);
    await sharedPreferences.setString('email', currentUsers.email.toString());
    await sharedPreferences.setString('name', nameController.text.trim());
    await sharedPreferences.setString('tienda', nameSellerController.text.trim());
    await sharedPreferences.setString('photoUrl', sellerImageURL);
  }








  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              _getImage();
            },
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.20,
              backgroundColor: MyColors.primaryColor,
              backgroundImage:
                  imageXFile == null ? null : FileImage(File(imageXFile!.path)),
              child: imageXFile == null
                  ? Icon(
                      Icons.add_photo_alternate,
                      size: MediaQuery.of(context).size.width * 0.20,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Form(
            key: _formkey,
            child: Column(
              children: [
                customTextField(
                  enabled: true,
                  data: Icons.person,
                  controller: nameController,
                  hintText: "Nombre",
                  isObsecre: false,
                ),
                customTextField(
                  enabled: true,
                  data: Icons.person,
                  controller: nameSellerController,
                  hintText: "Nombre de la empresa",
                  isObsecre: false,
                ),
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
                customTextField(
                  enabled: true,
                  data: Icons.lock,
                  controller: confimpassController,
                  hintText: "Confirmar contraseña",
                  isObsecre: true,
                ),
                customTextField(
                  enabled: true,
                  data: Icons.phone_android,
                  controller: phoneController,
                  hintText: "Telefono",
                  isObsecre: false,
                ),
                customTextField(
                  enabled: true,
                  data: Icons.location_on,
                  controller: locationController,
                  hintText: "Ubicacion",
                  isObsecre: false,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: 400,
                  height: 50,
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      getCurrentLocation();
                    },
                    icon: const Icon(Icons.location_on),
                    label: const Text('obtener mi ubicación actual'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              formValidation();
            },
            child: const Text(
              'Registrarse',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
                primary: MyColors.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
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
