import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kambaj/model/categories.dart';
import 'package:kambaj/model/items.dart';
import 'package:kambaj/uploadScreens/items_upload.dart';
import 'package:kambaj/widgets/items_desing.dart';
import 'package:kambaj/widgets/my_drawer.dart';
import '../global/global.dart';
import '../widgets/progress_bar.dart';
import '../widgets/text_widget.dart';

class ItemsScreensPage extends StatefulWidget
{

  final Catergories? model;
  ItemsScreensPage({required this.model});


  @override
  State<ItemsScreensPage> createState() => _ItemsScreensPageState();
}






class _ItemsScreensPageState extends State<ItemsScreensPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemsUpload(model: widget.model)));

              },
              icon: const Icon(
                Icons.library_add,
              )
          )

        ],

      ),
      drawer: myDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
              delegate: TextWidgetHeader(title: widget.model!.catTittle.toString() + ' / artículos ')),



          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('kambaj')
                .doc(sharedPreferences!.getString('uid'))
                .collection('kambaj_cotegories')
                .doc(widget.model!.catID)
                .collection('items')
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
                  Items model= Items.fromJson(
                    snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                  );
                  return itemsDesingWidget(
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
