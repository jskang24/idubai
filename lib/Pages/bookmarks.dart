import 'package:flutter/material.dart';
import '../Widgets/naviBar.dart';

class Bookmarks extends StatefulWidget {
  const Bookmarks({super.key});

  @override
  State<Bookmarks> createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  Widget build(BuildContext context) {
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
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 50,
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
                                    width:
                                        MediaQuery.of(context).size.width - 50,
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
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.bookmark,
                                        color:
                                            Color.fromARGB(255, 238, 223, 90),
                                      ),
                                      iconSize: 20,
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        // changeBookMark(index);
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
                              color: Colors.grey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
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
      bottomNavigationBar: NaviBar(tabIndex: 1),
    );
  }
}
