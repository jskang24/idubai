import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../Widgets/naviBar.dart';

class DetailPage extends StatefulWidget {
  @override
  _detailPageState createState() => _detailPageState();
}

class _detailPageState extends State<DetailPage> {
  List _tags = ["#Beach", "#Sand", "#California", "#Palm Trees", "#Family"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NaviBar(tabIndex: 3),
      body: SlidingUpPanel(
        isDraggable: false,
        defaultPanelState: PanelState.OPEN,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        panel: Column(
          children: [
            Container(
              height: 425,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Santa Monica Beach",
                        style: TextStyle(
                          fontFamily: 'Varela Round',
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.black,
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      RichText(
                          text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(Icons.location_on, size: 14),
                          ),
                          TextSpan(
                              text: "Santa Monica",
                              style: TextStyle(
                                fontFamily: 'Varela Round',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color.fromARGB(255, 193, 193, 193),
                              ))
                        ],
                      )),
                      Padding(padding: EdgeInsets.all(20)),
                      Text(
                        "Tags",
                        style: TextStyle(
                          fontFamily: 'Varela Round',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      Container(
                          height: 70,
                          child: Row(children: [
                            Flexible(
                              fit: FlexFit.loose,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _tags.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Container(
                                        // width: 120,
                                        //height: 20,
                                        child: Text(
                                      _tags[index],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          background: Paint()
                                            ..strokeWidth = 15.0
                                            ..color = Colors.grey
                                            ..style = PaintingStyle.stroke
                                            ..strokeJoin = StrokeJoin.round),
                                    )),
                                  );
                                },
                              ),
                            ),
                          ])),
                      // Padding(padding: EdgeInsets.all(20)),
                      Text(
                        "Description",
                        style: TextStyle(
                          fontFamily: 'Varela Round',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                      Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque fermentum porttitor augue nec facilisis. Mauris interdum nulla sed magna luctus ultricies. Proin a elit quis quam pharetra blandit. Fusce at orci at est ornare suscipit ut sed risus. ",
                        style: TextStyle(
                          fontFamily: 'Varela Round',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color.fromARGB(255, 193, 193, 193),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(20)),
                      Text(
                        "More Pictures",
                        style: TextStyle(
                          fontFamily: 'Varela Round',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      Container(
                          height: 70,
                          child: Row(children: [
                            Flexible(
                              fit: FlexFit.loose,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Container(
                                        width: 70,
                                        height: 70,
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                        )),
                                  );
                                },
                              ),
                            ),
                          ])),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(100, 96, 193, 200),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      minimumSize: Size(170, 50), //////// HERE
                      textStyle: const TextStyle(
                          fontSize: 14, fontFamily: "Varela Round"),
                    ),
                    onPressed: () {},
                    child: Row(children: [
                      Icon(Icons.local_taxi),
                      SizedBox(width: 5),
                      const Text('Find Way')
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      minimumSize: Size(170, 50), //////// HERE
                      textStyle: const TextStyle(
                          fontSize: 14, fontFamily: "Varela Round"),
                      primary: Color.fromARGB(0xff, 0x2E, 0x92, 0xD0),
                    ),
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        const Text('Look Around'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Center(
          child: Text("This is the Widget behind the sliding panel"),
        ),
      ),
    );
  }
}
