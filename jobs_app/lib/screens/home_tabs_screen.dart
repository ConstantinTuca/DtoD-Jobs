import 'package:flutter/material.dart';

import './home_screen.dart';

class HomeTabsScreen extends StatefulWidget {
  @override
  _HomeTabsScreenState createState() => _HomeTabsScreenState();
}

class _HomeTabsScreenState extends State<HomeTabsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      // initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          //centerTitle: true,
          title: Text(
            'Joburile tale',
            style: TextStyle(fontSize: 23, color: Theme.of(context).primaryColor,),
          ),
          backgroundColor: Colors.white,
          elevation: 1,

        ),
        body: TabBarView(
          children: <Widget>[
            HomeScreen(),
            HomeScreen(),
          ],
        ),
      ),
    );
  }
}
