import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './home_screen.dart';
import 'offer_job/job_details_input_screen.dart';
import 'authentification/login_screen.dart';
import './profile/profile_details_screen.dart';
import './find_job/job_location_search_screen.dart';
import './home_tabs_screen.dart';
import '../providers/auth.dart';
import '../providers/jobs.dart';

class NavigationScreen extends StatefulWidget {
  final int index;

  NavigationScreen({this.index = 0});

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex;

  @override
  initState() {
    _pages = [
      {'page': HomeScreen(), 'title': 'Acasă'},
      {'page': JobLocationSearchScreen(), 'title': 'Caută'},
      {'page': JobDetailsInputScreen(), 'title': 'Oferă'},
      //{'page': HomeScreen(), 'title': 'Mesaje'},
      {'page': ProfileDetailsScreen(), 'title': 'Profil'},
    ];
    _selectedPageIndex = widget.index;

    super.initState();
  }

  void _selectPage(int index) {
    if (index == 2) {
      Navigator.of(context).pushNamed(JobDetailsInputScreen.routeName);
    } else if (index == 1) {
      Navigator.of(context).pushNamed(JobLocationSearchScreen.routeName);
    } else {
      setState(() {
        _selectedPageIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: _pages[_selectedPageIndex]['page'],
            bottomNavigationBar: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: BottomNavigationBar(
                onTap: _selectPage,
                //type: BottomNavigationBarType.shifting,
                backgroundColor: Colors.white,
                unselectedItemColor: Colors.black54,
                selectedItemColor: Color(0xff075E54),
                currentIndex: _selectedPageIndex,
                items: [
                  BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: Icon(
                      Icons.home,
                    ),
                    title: Text('Acasă'),
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: Icon(
                      Icons.search,
                    ),
                    title: Text('Caută'),
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: Icon(
                      Icons.add_circle_outline,
                    ),
                    title: Text('Oferă'),
                  ),
//                  BottomNavigationBarItem(
//                    backgroundColor: Colors.white,
//                    icon: Icon(
//                      Icons.message,
//                    ),
//                    title: Text('Mesaje'),
//                  ),
                  BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: Icon(
                      Icons.person,
                    ),
                    title: Text('Profil'),
                  ),
                ],
              ),
            ),
          );
  }
}
