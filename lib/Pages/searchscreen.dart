import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './details.dart';
// H
import '../Widgets/naviBar.dart';

class SearchScreen extends StatefulWidget {
  final String search;
  SearchScreen({required this.search});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List searchedPlaces = [];
  List bookmarkStatus = [];
  List userBookmark = [];

  TextEditingController _searchController = new TextEditingController();

  void fetchPlaces() async {
    await FirebaseFirestore.instance
        .collection("places")
        .where('name', isGreaterThanOrEqualTo: widget.search)
        .where('name', isLessThanOrEqualTo: widget.search + "\uf8ff")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc.id != "dummy") {
          setState(() {
            searchedPlaces.add(doc);
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
    for (int i = 0; i < searchedPlaces.length; i++) {
      for (int j = 0; j < userBookmark.length; j++) {
        if (searchedPlaces[i].id == userBookmark[j].id) {
          setState(() {
            bookmarkStatus[i] = true;
          });
          break;
        }
      }
    }
  }

  initState() {
    fetchPlaces();
    fetchBookmark();
  }

  void addBookMark(int index) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("bookmarks")
        .doc(searchedPlaces[index].id)
        .set({
      'name': searchedPlaces[index]['name'],
      'address': searchedPlaces[index]['address'],
      'description': searchedPlaces[index]['description'],
      'pictures': searchedPlaces[index]['pictures'][0],
    });
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                SearchScreen(search: widget.search)));
  }

  void removeBookMark(int index) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("bookmarks")
        .doc(searchedPlaces[index].id)
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
              builder: (BuildContext context) => SearchScreen(
                    search: widget.search,
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
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 60, 20, 15),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Row(
                    children: [
                      Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width - 110,
                        child: TextField(
                          onSubmitted: (value) {
                            if (_searchController.text.length > 0) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchScreen(
                                        search: _searchController.text)),
                              );
                            }
                          },
                          controller: _searchController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search...",
                          ),
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.search),
                        onPressed: () {
                          if (_searchController.text.length > 0) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchScreen(
                                      search: _searchController.text)),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  scrollDirection: Axis.vertical,
                  itemCount: searchedPlaces.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailPage(
                                      placeID: searchedPlaces[index].id,
                                      navindex: 0,
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
                                            searchedPlaces[index]['name'],
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
                                                searchedPlaces[index]
                                                    ['address'],
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
                                          searchedPlaces[index]["pictures"][0]),
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
        bottomNavigationBar: NaviBar(tabIndex: 0),
      );
    } catch (e) {
      return Container();
    }
  }
}
