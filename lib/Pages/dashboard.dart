import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../Widgets/naviBar.dart';
import '../Widgets/Dashboard_bg.dart';
import './bookmarks.dart';
import './categories.dart';
import './details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// H

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List popularPlaces = [];
  List recentPlaces = [];
  List userBookmark = [];
  List imgList = [];
  List recentBookmark = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  List popularBookmark = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  var imageSliders;
  void fetchPopular() async {
    await FirebaseFirestore.instance
        .collection('places')
        .orderBy('numBookmark', descending: true)
        .limit(10)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          popularPlaces.add(doc);
        });
      });
    });
  }

  void fetchRecent() async {
    await FirebaseFirestore.instance
        .collection('places')
        .orderBy('addTime', descending: true)
        .limit(10)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          recentPlaces.add(doc);
        });
      });
    });
  }

  void fetchMain() async {
    await FirebaseFirestore.instance
        .collection('places')
        .where("displayMain", isEqualTo: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          imgList.add([doc.id, doc["pictures"][0]]);
        });
      });
      setState(() {
        genCarousel();
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
        setState(() {
          userBookmark.add(doc);
        });
        for (int i = 0; i < recentPlaces.length; i++) {
          for (int j = 0; j < userBookmark.length; j++) {
            if (recentPlaces[i].id == userBookmark[j].id) {
              setState(() {
                recentBookmark[i] = true;
              });
              break;
            }
          }
        }
        for (int i = 0; i < popularPlaces.length; i++) {
          for (int j = 0; j < userBookmark.length; j++) {
            if (popularPlaces[i].id == userBookmark[j].id) {
              setState(() {
                popularBookmark[i] = true;
              });
              break;
            }
          }
        }
      });
    });
  }

  initState() {
    fetchPopular();
    fetchRecent();
    fetchBookmark();
    fetchMain();
    // print(imgList);
  }

  void addRecentBookMark(int index) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("bookmarks")
        .doc(recentPlaces[index].id)
        .set({
      'name': recentPlaces[index]['name'],
      'address': recentPlaces[index]['address'],
      'description': recentPlaces[index]['description'],
      'pictures': recentPlaces[index]['pictures'][0],
    });
    Navigator.popAndPushNamed(context, '/');
  }

  void removeRecentBookMark(int index) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("bookmarks")
        .doc(recentPlaces[index].id)
        .delete();
    Navigator.popAndPushNamed(context, '/');
  }

  void addPopularBookMark(int index) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("bookmarks")
        .doc(popularPlaces[index].id)
        .set({
      'name': popularPlaces[index]['name'],
      'address': popularPlaces[index]['address'],
      'description': popularPlaces[index]['description'],
      'pictures': popularPlaces[index]['pictures'][0],
    });
    print(popularPlaces[index].id);
    Navigator.popAndPushNamed(context, '/');
  }

  void removePopularBookMark(int index) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("bookmarks")
        .doc(popularPlaces[index].id)
        .delete();
    Navigator.popAndPushNamed(context, '/');
  }

  void changeRecentBookMark(int index) {
    if (recentBookmark[index]) {
      setState(() {
        recentBookmark[index] = false;
      });
      removeRecentBookMark(index);
    } else {
      setState(() {
        recentBookmark[index] = true;
      });
      addRecentBookMark(index);
    }
    print(recentBookmark);
  }

  void changePopularBookMark(int index) {
    if (popularBookmark[index]) {
      setState(() {
        popularBookmark[index] = false;
      });
      removePopularBookMark(index);
    } else {
      setState(() {
        popularBookmark[index] = true;
      });
      print(popularPlaces[index].id);
      addPopularBookMark(index);
    }
    print(popularBookmark);
  }

  void genCarousel() async {
    if (imgList.length > 0) {
      imageSliders = imgList
          .map(
            (item) => GestureDetector(
                child: Container(
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          child: Image.network(item[1],
                              fit: BoxFit.cover, width: 1500),
                        )),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailPage(placeID: item[0], navindex: 0),
                    ),
                  );
                }),
          )
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      return DefaultTabController(
        initialIndex: 1,
        length: 5,
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      ContainerTwoColours(
                        progress: 0.2,
                        widthSize: MediaQuery.of(context).size.width,
                        heightSize: 450,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 60, 20, 50),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 3,
                                offset:
                                    Offset(0, 3), // changes position of shadow
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
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Search...",
                                    ),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  width: 300,
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(Icons.search),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 120, 0, 0),
                        child: Container(
                            child: CarouselSlider(
                          options: CarouselOptions(
                            aspectRatio: 1.5,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                            autoPlay: true,
                          ),
                          items:
                              imageSliders == null ? Container() : imageSliders,
                        )),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 5, 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 20,
                      child: Text(
                        "Popular Places",
                        style: TextStyle(
                          fontFamily: 'Varela Round',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 255,
                    width: MediaQuery.of(context).size.width,
                    child: Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: popularPlaces.length,
                          itemBuilder: (BuildContext context, int index) {
                            try {
                              return GestureDetector(
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Container(
                                    width: 150,
                                    height: 240,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 150,
                                          height: 190,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  popularPlaces[index]
                                                      ["pictures"][0]),
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Container(
                                          width: 150,
                                          height: 50,
                                          child: Row(
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 130,
                                                    child: Text(
                                                      popularPlaces[index]
                                                          ['name'],
                                                      style: TextStyle(
                                                        fontFamily:
                                                            "Varela Round",
                                                        fontSize: 14,
                                                      ),
                                                      // textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 130,
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.location_pin,
                                                          size: 15,
                                                        ),
                                                        Text(
                                                          popularPlaces[index]
                                                              ['address'],
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "Varela Round",
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
                                                children: [
                                                  Container(
                                                    width: 20,
                                                    height: 20,
                                                    child: IconButton(
                                                      icon:
                                                          popularBookmark[index]
                                                              ? Icon(
                                                                  Icons
                                                                      .bookmark,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          238,
                                                                          223,
                                                                          90),
                                                                )
                                                              : Icon(
                                                                  Icons
                                                                      .bookmark_outline,
                                                                ),
                                                      iconSize: 20,
                                                      padding: EdgeInsets.zero,
                                                      onPressed: () {
                                                        changePopularBookMark(
                                                            index);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 30),
                                            ],
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
                                          placeID: popularPlaces[index].id,
                                          navindex: 0),
                                    ),
                                  );
                                },
                              );
                            } catch (e) {
                              return Container();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 20, 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 20,
                      child: Text(
                        "Recently Added",
                        style: TextStyle(
                          fontFamily: 'Varela Round',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 255,
                    width: MediaQuery.of(context).size.width,
                    child: Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: recentPlaces.length,
                          itemBuilder: (BuildContext context, int index) {
                            try {
                              return GestureDetector(
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Container(
                                      width: 150,
                                      height: 240,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 150,
                                            height: 190,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    recentPlaces[index]
                                                        ["pictures"][0]),
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Container(
                                            width: 150,
                                            height: 50,
                                            child: Row(
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 130,
                                                      child: Text(
                                                        recentPlaces[index]
                                                            ['name'],
                                                        style: TextStyle(
                                                          fontFamily:
                                                              "Varela Round",
                                                          fontSize: 14,
                                                        ),
                                                        // textAlign: TextAlign.left,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 130,
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.location_pin,
                                                            size: 15,
                                                          ),
                                                          Text(
                                                            recentPlaces[index]
                                                                ["address"],
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  "Varela Round",
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            // textAlign: TextAlign.left,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      width: 20,
                                                      height: 20,
                                                      child: IconButton(
                                                        icon: recentBookmark[
                                                                index]
                                                            ? Icon(
                                                                Icons.bookmark,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        238,
                                                                        223,
                                                                        90),
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .bookmark_outline,
                                                              ),
                                                        iconSize: 20,
                                                        padding:
                                                            EdgeInsets.zero,
                                                        onPressed: () {
                                                          changeRecentBookMark(
                                                              index);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 30),
                                              ],
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
                                            placeID: recentPlaces[index].id,
                                            navindex: 0),
                                      ),
                                    );
                                  });
                            } catch (e) {
                              return Container();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: NaviBar(
              tabIndex: 0,
            )),
      );
    } catch (e) {
      return Container();
    }
  }
}
