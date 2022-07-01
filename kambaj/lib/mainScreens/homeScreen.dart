import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kambaj/global/global.dart';
import 'package:kambaj/model/categories.dart';
import 'package:kambaj/uploadScreens/categories_upload_screen.dart';
import 'package:kambaj/widgets/my_drawer.dart';

import '../widgets/categories_desing.dart';
import '../widgets/progress_bar.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: myDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.black,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          sharedPreferences!.getString('tienda')!,
          style: const TextStyle(
              fontFamily: 'Lobster', fontSize: 35, color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (c)=>categoriesUpload()));
              },
              icon: const Icon(
                  Icons.post_add,
                
              )
          )

        ],

      ),

      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: ListTile(
              title: Text(
                'Inicio',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'lobster',
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              tileColor: Colors.black,
              dense: true,

            ),
          ),



          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
            .collection('kambaj')
            .doc(sharedPreferences!.getString('uid'))
            .collection('kambaj_cotegories')
            .orderBy('publishedDate', descending: true)
            .snapshots(),

            builder: (context, snapshot)
            {
              return !snapshot.hasData?
              SliverToBoxAdapter(
                child: Center(
                  child: circularProgress(),
                ),
              )

                  : SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 2,
                  staggeredTileBuilder: (c)=> StaggeredTile.fit(1),
                  itemBuilder: (context, index)
                  {
                    Catergories model=Catergories.fromJson(
                      snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                    );
                    return infoDesingWidget(
                      model: model,
                      context: context,

                    );
                  },
                itemCount: snapshot.data!.docs.length,

              );
            },
          )

        ],
      ),


    );
  }
}
