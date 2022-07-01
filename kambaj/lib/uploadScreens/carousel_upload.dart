import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;
import 'package:kambaj/widgets/upload_image_ok.dart';
import '../global/global.dart';
import '../mainScreens/homeScreen.dart';
import '../widgets/progress_bar.dart';


class carouselUpload extends StatefulWidget {
  const carouselUpload({Key? key}) : super(key: key);

  @override
  State<carouselUpload> createState() => _carouselUploadState();
}

class _carouselUploadState extends State<carouselUpload> {

  XFile? imageXfile;
  final ImagePicker _picker = ImagePicker();


  bool uploading = false;
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();


  defaultScreens() {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.black,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          sharedPreferences!.getString('tienda')!,
          style: const TextStyle(
              fontFamily: 'Lobster',
              fontSize: 35,
              color: Colors.white
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (c) => const homeScreen()));
          },
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shop_two,
              color: Colors.grey,
              size: 200,
            ),
            ElevatedButton(
              onPressed: () {
                takeImage(context);
              },
              child: const Text(
                'Añadir Nuevo',
              ),
              style: ButtonStyle(
                shape: (MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (context)
        {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
            ),
            title: const Text(
              'Menu imagen',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'lobster',
              ),
            ),
            children: [

              SimpleDialogOption(
                child: const Text('capturar imagen'),
                onPressed: captureImage,
              ),


              SimpleDialogOption(
                child: const Text('Seleccionar de galeria'),
                onPressed: pickimagefromgalery,
              ),


              SimpleDialogOption(
                child: const Text('cancelar'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }




  captureImage() async {
    Navigator.pop(context);

    imageXfile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1280,
    );
    setState(() {
      imageXfile;
    });
  }

  pickimagefromgalery() async {
    Navigator.pop(context);
    imageXfile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1280,
      maxHeight: 720,
    );
    setState(() {
      imageXfile;

    });
  }

  clearMenuUploadForm() {
    setState(() {
      imageXfile = null;
    });
  }

  uploadImage(mImageFile)async {
    storageRef.Reference reference = storageRef.FirebaseStorage.
    instance.
    ref().
    child('Carousel');

    storageRef.UploadTask uploadTask = reference.child(uniqueIdName + 'jpg').putFile(mImageFile);

    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete((){});

    String dowloadUrl = await taskSnapshot.ref.getDownloadURL();

    return dowloadUrl;

  }




  saveInfo(String dowloadUrl){

    final ref = FirebaseFirestore.instance
    //initial collection
        .collection('kambaj')
        .doc(sharedPreferences!.getString('uid'))
    //sub collection of carousel
        .collection('kambaj_carousel');

    ref.doc(uniqueIdName).set({

      'carouselID' : uniqueIdName,
      'tiendaUID' : sharedPreferences!.getString('uid'),
      'publishedDate' : DateTime.now(),
      'status' : 'disponible ',
      'miniatura' : dowloadUrl,
    }).then((value)
    {
      final itemsRef = FirebaseFirestore.instance
          .collection("carousel");

      itemsRef.doc(uniqueIdName).set({
        'carouselID' : uniqueIdName,
        'tiendaUID' : sharedPreferences!.getString('uid'),
        'publishedDate' : DateTime.now(),
        'status' : 'disponible ',
        'miniatura' : dowloadUrl,
      });
    }).then((value){
      clearMenuUploadForm();

      setState(() {
        uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
        uploading = false;
      });
    });

  }




  validateUploadForm() async {
    if(imageXfile != null)
    {
      showDialog(
          context: context,
          builder: (c)
          {
            return UploadDialog(
              message: 'Cargando' ,
            );
          }
      );
      //upload image

      String dowloadUrl = await uploadImage(File(imageXfile!.path));

      //save inforation to firebase

      saveInfo(dowloadUrl);
    }
  }



  carouselUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.black,
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          'Cargar nuevo producto',
          style: TextStyle(
              fontFamily: 'Lobster',
              fontSize: 20,
              color: Colors.white
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            clearMenuUploadForm();
          },
        ),
        actions: [
          TextButton(
            onPressed:  uploading? null : ()=> validateUploadForm(),
            child: const Text(
              'Add',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'Lobster',
                letterSpacing: 3,
              ),
            ),

          ),
        ],
      ),

      body: ListView(
        children: [
          uploading == true? linearProgress() : const Text(''),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: 400,
              width: MediaQuery.of(context).size.width *.8,
              child: Center(
                child: GestureDetector(
                  onTap: ()
                  {
                    takeImage(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      image: DecorationImage(
                          image: FileImage(
                              File(imageXfile!.path)
                          ),
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return imageXfile == null ? defaultScreens() : carouselUploadFormScreen();
  }
}
