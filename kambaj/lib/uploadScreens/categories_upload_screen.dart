import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;
import 'package:kambaj/utils/My_colors.dart';
import '../global/global.dart';
import '../mainScreens/homeScreen.dart';
import '../widgets/error_dialog.dart';
import '../widgets/progress_bar.dart';


class categoriesUpload extends StatefulWidget {
  const categoriesUpload({Key? key}) : super(key: key);

  @override
  State<categoriesUpload> createState() => _categoriesUploadState();
}

class _categoriesUploadState extends State<categoriesUpload> {

  XFile? imageXfile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController shortInfController = TextEditingController();
  TextEditingController titleController = TextEditingController();


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
      shortInfController.clear();
      titleController.clear();
      imageXfile = null;
    });
  }

  uploadImage(mImageFile)async {
    storageRef.Reference reference = storageRef.FirebaseStorage.
    instance.
    ref().
    child('Categories');

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
    //sub collection of categories
        .collection('kambaj_cotegories');

    ref.doc(uniqueIdName).set({

      'catID' : uniqueIdName,
      'tiendaUID' : sharedPreferences!.getString('uid'),
      'catInformation': shortInfController.text.toString(),
      'catTittle' : titleController.text.toString(),
      'publishedDate' : DateTime.now(),
      'status' : 'disponible ',
      'miniatura' : dowloadUrl,
    }).then((value)
    {
      final itemsRef = FirebaseFirestore.instance
          .collection("cotegories");

      itemsRef.doc(uniqueIdName).set({
        'catID' : uniqueIdName,
        'tiendaUID' : sharedPreferences!.getString('uid'),
        'catInformation': shortInfController.text.toString(),
        'catTittle' : titleController.text.toString(),
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




  validateUploadForm() async
  {

    if(imageXfile != null)
      {
        if(
        shortInfController.text.isNotEmpty&& titleController.text.isNotEmpty)
          {
            setState(() {
              uploading = true;
            });

            //upload image

            String dowloadUrl = await uploadImage(File(imageXfile!.path));

            //save inforation to firebase

            saveInfo(dowloadUrl);


          }
        else
        {
          showDialog(
              context: context,
              builder: (c)
              {
                return ErrorDialog(
                  message: 'por favor, escriba el título e infrmación' ,
                );
              }
          );
        }

      }
    else
      {
        showDialog(
            context: context,
            builder: (c)
            {
              return ErrorDialog(
                message: 'Seleccione una imagen' ,
              );
            }
        );

      }


  }






  ItemsUploadFormScreen() {
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



          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
                color: MyColors.primaryColor,
                borderRadius: BorderRadius.circular(30)
            ),
            child: ListTile(
              leading: const Icon(
                Icons.perm_device_info,
                color: Colors.white,
              ),
              title: SizedBox(
                width: 250,
                child: TextField(
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  controller: shortInfController,
                  decoration: const InputDecoration(
                    hintText: 'Nombre de la categoria',
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    border: InputBorder.none
                  ),
                )
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
                color: MyColors.primaryColor,
                borderRadius: BorderRadius.circular(30)
            ),
            child: ListTile(
              leading: const Icon(
                Icons.title,
                color: Colors.white,
              ),
              title: SizedBox(
                  width: 250,
                  child: TextField(
                    maxLength: 255,
                    maxLines: 3,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    controller: titleController,
                    decoration: const InputDecoration(
                        hintText: 'Descripcion de la categoria',
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        border: InputBorder.none
                    ),
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }







  @override
  Widget build(BuildContext context) {
    return imageXfile == null ? defaultScreens() : ItemsUploadFormScreen();
  }
}