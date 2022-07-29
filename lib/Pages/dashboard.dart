import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';

import '../Widgets/Dashboard_bg.dart';
import './bookmarks.dart';
import '../Widgets/navbar.dart';
import './categories.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

class _DashboardState extends State<Dashboard> {
  final List<Widget> imageSliders = imgList
      .map((item) => Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(item, fit: BoxFit.cover, width: 1000.0),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Text(
                            'No. ${imgList.indexOf(item)} image',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ))
      .toList();

  var _selectedTab = _SelectedTab.home;

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
    if (_selectedTab == _SelectedTab.home) {
      Navigator.pushNamed(context, '/');
    } else if (_selectedTab == _SelectedTab.favorite) {
      Navigator.pushNamed(context, '/second');
    } else if (_selectedTab == _SelectedTab.search) {
      Navigator.pushNamed(context, '/third');
    } else if (_selectedTab == _SelectedTab.person) {
      Navigator.pushNamed(context, '/fourth');
    }
  }

  List bookMarkStatus = [false, false, false, false, false];

  initState() {
    print(bookMarkStatus[0]);
  }

  void changeBookMark(int index) {
    if (bookMarkStatus[index])
      setState(() {
        bookMarkStatus[index] = false;
      });
    else
      setState(() {
        bookMarkStatus[index] = true;
      });
    print(bookMarkStatus[index]);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Stack(
              children: [
                ContainerTwoColours(
                  progress: 0.2,
                  widthSize: MediaQuery.of(context).size.width,
                  heightSize: 400,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 60, 20, 50),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Color.fromARGB(0xFF, 0xAE, 0xD8, 0xDA),
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
                  padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
                  child: Container(
                      child: CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 1.5,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                      autoPlay: true,
                    ),
                    items: imageSliders,
                  )),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
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
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.all(5),
                      child: Container(
                        width: 120,
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 120,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              width: 120,
                              height: 50,
                              child: Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 100,
                                        child: Text(
                                          "Place " + index.toString(),
                                          style: TextStyle(
                                            fontFamily: "Varela Round",
                                            fontSize: 14,
                                          ),
                                          // textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Container(
                                        width: 100,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.location_pin,
                                              size: 15,
                                            ),
                                            Text(
                                              "Location " + index.toString(),
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
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        child: IconButton(
                                          icon: bookMarkStatus[index]
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
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: DotNavigationBar(
            backgroundColor: Color.fromARGB(0xFF, 0xAE, 0xD8, 0xDA),
            margin: EdgeInsets.only(left: 10, right: 10),
            currentIndex: _SelectedTab.values.indexOf(_selectedTab),
            dotIndicatorColor: Colors.white,
            unselectedItemColor: Colors.white,
            // enableFloatingNavBar: false,
            onTap: _handleIndexChanged,
            items: [
              /// Home
              DotNavigationBarItem(
                icon: Icon(Icons.home),
                selectedColor: Colors.white,
              ),

              /// Likes
              DotNavigationBarItem(
                icon: Icon(Icons.favorite),
                selectedColor: Colors.white,
              ),

              /// Search
              DotNavigationBarItem(
                icon: Icon(Icons.search),
                selectedColor: Colors.white,
              ),

              /// Profile
              DotNavigationBarItem(
                icon: Icon(Icons.person),
                selectedColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _SelectedTab { home, favorite, search, person }
