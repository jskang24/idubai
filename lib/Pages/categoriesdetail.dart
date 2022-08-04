import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './details.dart';
// H
import '../Widgets/naviBar.dart';

class CategoriesDetail extends StatefulWidget {
  final String tag;
  final List places;
  CategoriesDetail({required this.tag, required this.places});

  @override
  State<CategoriesDetail> createState() => _CategoriesDetailState();
}

class _CategoriesDetailState extends State<CategoriesDetail> {
  List taggedPlaces = [];
  List bookmarkStatus = [];
  List userBookmark = [];

  void fetchPlaces() async {
    await FirebaseFirestore.instance
        .collection("places")
        .where(FieldPath.documentId, whereIn: widget.places)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc.id != "dummy") {
          setState(() {
            taggedPlaces.add(doc);
          });
          bookmarkStatus.add(false);
        }
      });
    });
  }

  void fetchBookmark() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("bookmarks")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc.id != "dummy") {
          setState(() {
            userBookmark.add(doc);
          });
        }
      });
    });
    for (int i = 0; i < taggedPlaces.length; i++) {
      for (int j = 0; j < userBookmark.length; j++) {
        if (taggedPlaces[i].id == userBookmark[j].id) {
          setState(() {
            bookmarkStatus[i] = true;
          });
          break;
        }
      }
    }
  }

  initState() {
    print(widget.places);
    fetchPlaces();
    fetchBookmark();
  }

  void addBookMark(int index) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("bookmarks")
        .doc(taggedPlaces[index].id)
        .set({
      'name': taggedPlaces[index]['name'],
      'address': taggedPlaces[index]['address'],
      'description': taggedPlaces[index]['description'],
      'pictures': taggedPlaces[index]['pictures'][0],
    });
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CategoriesDetail(
                  tag: widget.tag,
                  places: widget.places,
                )));
  }

  void removeBookMark(int index) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("bookmarks")
        .doc(taggedPlaces[index].id)
        .delete();
  }

  void changeBookMark(int index) {
    if (bookmarkStatus[index]) {
      setState(() {
        bookmarkStatus[index] = false;
      });
      removeBookMark(index);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => CategoriesDetail(
                    tag: widget.tag,
                    places: widget.places,
                  )));
    } else {
      setState(() {
        bookmarkStatus[index] = true;
      });
      addBookMark(index);
    }
  }

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
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: taggedPlaces.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailPage(
                                      placeID: taggedPlaces[index].id,
                                      navindex: 2,
                                    )),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              50,
                                          child: Text(
                                            taggedPlaces[index]['name'],
                                            style: TextStyle(
                                              fontFamily: "Varela Round",
                                              fontSize: 14,
                                            ),
                                            // textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              50,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.location_pin,
                                                size: 15,
                                              ),
                                              Text(
                                                taggedPlaces[index]['address'],
                                                style: TextStyle(
                                                  fontFamily: "Varela Round",
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                                // textAlign: TextAlign.left,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          child: IconButton(
                                            icon: bookmarkStatus[index]
                                                ? Icon(
                                                    Icons.bookmark,
                                                    color: Color.fromARGB(
                                                        255, 238, 223, 90),
                                                  )
                                                : Icon(
                                                    Icons.bookmark_outline,
                                                  ),
                                            iconSize: 20,
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              changeBookMark(index);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 30),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          taggedPlaces[index]["pictures"][0]),
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
                  },
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: NaviBar(tabIndex: 2),
      );
    } catch (e) {
      return Container();
    }
  }
}
