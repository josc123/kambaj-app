import 'package:flutter/material.dart';
import 'package:kambaj/mainScreens/Carousel_screen.dart';
import 'package:kambaj/mainScreens/homeScreen.dart';
import '../auth_sreem/auth_sreem.dart';
import '../global/global.dart';

class myDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 10,left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Material(
                    borderRadius: BorderRadius.all(Radius.circular(200)),
                    elevation: 10,
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Container(
                        height: 198,
                        width: 198,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            sharedPreferences!.getString('photoUrl')!
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10,),
                Text(sharedPreferences!.getString('name')!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'kiwi'
                  ),
                ),
                SizedBox(height: 10,),
                Text(sharedPreferences!.getString('email')!,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Kiwi'
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: Column(
              children: [
                Divider(
                  height: 1,
                  color: Colors.black,
                  thickness: 0.100,
                ),
                SizedBox(height: 10,),


                ListTile(
                  leading: Icon(
                    Icons.store_mall_directory_outlined,
                    color: Colors.black,
                  ),
                  title: Text('Categorias',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Kiwi'
                    ),
                  ),
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (C)=>homeScreen()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.image_aspect_ratio,
                    color: Colors.black,
                  ),
                  title: Text('Carrusel de imagenes',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Kiwi'
                    ),
                  ),
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (C)=>carouselScreen()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.monetization_on,
                    color: Colors.black,
                  ),
                  title: Text('Mi ganancia',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Kiwi'
                    ),
                  ),
                  onTap: (){


                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.playlist_add_check,
                    color: Colors.black,
                  ),
                  title: Text('Nueva Orden',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Kiwi'
                    ),
                  ),
                  onTap: (){


                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.local_shipping_rounded,
                    color: Colors.black,
                  ),
                  title: Text('Historial-Orden ',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Kiwi'
                    ),
                  ),
                  onTap: (){


                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Colors.black,
                  ),
                  title: Text('Salir',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Kiwi'
                    ),
                  ),
                  onTap: (){

                    firebaseAuth.signOut().then((value) {
                      Navigator.push(context, MaterialPageRoute(builder: (C)=>AuthSreem()));
                    });


                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
