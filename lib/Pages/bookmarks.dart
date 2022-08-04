import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Widgets/naviBar.dart';
import './details.dart';

class Bookmarks extends StatefulWidget {
  const Bookmarks({super.key});

  @override
  State<Bookmarks> createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  List userBookmark = [];
  List bookmarkStatus = [];

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
          bookmarkStatus.add(true);
        }
      });
    });
  }

  initState() {
    fetchBookmark();
  }

  void removeBookMark(int index) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("bookmarks")
        .doc(userBookmark[index].id)
        .delete();
  }

  void changeBookMark(int index) {
    if (bookmarkStatus[index]) {
      setState(() {
        bookmarkStatus[index] = false;
      });
      removeBookMark(index);
      Navigator.popAndPushNamed(context, '/second');
    } else {
      setState(() {
        bookmarkStatus[index] = true;
      });
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
            "Bookmarks",
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
                  itemCount: userBookmark.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
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
                                            userBookmark[index]['name'],
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
                                                userBookmark[index]['address'],
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
                                        // H
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
                                          userBookmark[index]["pictures"]),
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(
                                  placeID: userBookmark[index].id, navindex: 1),
                            ),
                          );
                        });
                  },
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: NaviBar(tabIndex: 1),
      );
    } catch (e) {
      return Container();
    }
  }
}
