import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kambaj/global/global.dart';
import 'package:kambaj/model/carousel.dart';
import 'package:kambaj/widgets/carousel_desing.dart';
import 'package:kambaj/widgets/my_drawer.dart';
import '../uploadScreens/carousel_upload.dart';
import '../widgets/progress_bar.dart';

class carouselScreen extends StatefulWidget {
  const carouselScreen({Key? key}) : super(key: key);

  @override
  State<carouselScreen> createState() => _carouselScreenState();
}

class _carouselScreenState extends State<carouselScreen> {
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
         ('Carrusel de imagenes'),
          style: const TextStyle(
              fontFamily: 'Lobster',
              fontSize: 30,
              color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (c)=>carouselUpload()));
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
                'Mis imagenes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'lobster',
                  fontSize: 20,
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
                .collection('kambaj_carousel')
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
                  Carousel model=Carousel.fromJson(
                    snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                  );
                  return carouselDesingWidget(
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
