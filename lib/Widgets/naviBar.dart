import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

// H
class NaviBar extends StatefulWidget {
  final int tabIndex;
  NaviBar({required this.tabIndex});
  @override
  _NaviBarState createState() => _NaviBarState();
}

class _NaviBarState extends State<NaviBar> {
  int _selectedIndex = 0;
  void initState() {
    _selectedIndex = widget.tabIndex;
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Home',
      style: optionStyle,
    ),
    Text(
      'Bookmarks',
      style: optionStyle,
    ),
    Text(
      'Categories',
      style: optionStyle,
    ),
    Text(
      'Settings',
      style: optionStyle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
      child: GNav(
        activeColor: Color.fromARGB(255, 113, 180, 231),
        rippleColor: Color.fromARGB(255, 113, 180, 231),
        hoverColor: Colors.grey[100]!,
        gap: 8,
        iconSize: 24,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        duration: Duration(milliseconds: 400),
        tabBackgroundColor: Colors.grey[100]!,
        color: Colors.black,
        tabs: [
          GButton(
            icon: LineIcons.home,
            text: 'Home',
          ),
          GButton(
            icon: LineIcons.bookmark,
            text: 'Bookmarks',
          ),
          GButton(
            icon: LineIcons.icons,
            text: 'Categories',
          ),
          GButton(
            icon: LineIcons.cog,
            text: 'Settings',
          ),
        ],
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
          switch (_selectedIndex) {
            case 0:
              Navigator.pushNamed(context, "/");
              break;
            case 1:
              Navigator.pushNamed(context, "/second");
              break;
            case 2:
              Navigator.pushNamed(context, "/third");
              break;
            case 3:
              Navigator.pushNamed(context, "/fourth");
              break;
          }
        },
      ),
    );
  }
}
