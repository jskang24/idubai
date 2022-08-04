import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import '../Widgets/naviBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './categoriesdetail.dart';

class Categories extends StatefulWidget {
  const Categories({
    Key? key,
  }) : super(key: key);
  _CategoriesState createState() => _CategoriesState();
}

// H
class _CategoriesState extends State<Categories> {
  var tags = [];
  var imgurl = [];
  void retreiveTags() async {
    await FirebaseFirestore.instance
        .collection('tags')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          tags.add(doc);
        });
      });
      for (var i in tags) {
        FirebaseFirestore.instance
            .collection('places')
            .doc(i["placesID"][0])
            .get()
            .then((DocumentSnapshot doc) {
          setState(() {
            imgurl.add(doc["pictures"][0]);
          });
        });
      }
    });
  }

  void initState() {
    retreiveTags();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Categories",
            style: TextStyle(
              fontFamily: 'Varela Round',
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: GridView.custom(
          padding: EdgeInsets.all(10),
          gridDelegate: SliverQuiltedGridDelegate(
            crossAxisCount: 3,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            repeatPattern: QuiltedGridRepeatPattern.inverted,
            pattern: const [
              QuiltedGridTile(1, 2),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              // QuiltedGridTile(1, 1),
            ],
          ),
          childrenDelegate: SliverChildBuilderDelegate((context, index) {
            try {
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoriesDetail(
                            tag: tags[index].id,
                            places: tags[index]['placesID']),
                      ),
                    );
                  },
                  child: Stack(children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(imgurl[index]),
                        ),
                      ),
                    ),
                    Container(color: Color.fromARGB(130, 255, 255, 255)),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
                          child: Text(
                            "#${tags[index].id}",
                            style: TextStyle(
                              fontFamily: "Varela Round",
                              fontSize: 16,
                            ),
                            // textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    )
                  ]));
            } catch (e) {
              return Container();
            }
          }, childCount: tags.length),
        ),
        bottomNavigationBar: NaviBar(
          tabIndex: 2,
        ),
      );
    } catch (e) {
      return Container();
    }
  }
}
