import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MessagesMaintenanceScreen extends StatefulWidget {
  static final routeName = '/messages-maintenance';

  @override
  _MessagesMaintenanceState createState() => _MessagesMaintenanceState();
}

class _MessagesMaintenanceState extends State<MessagesMaintenanceScreen> {
  final _form = GlobalKey<FormState>();

  var _isInit = true;
  var _isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: screenSize.height,
        padding: EdgeInsets.only(
          top: 20,
          left: 25,
          right: 25,
          bottom: 20,
        ),
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/maintenance.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Funcționalitate în mentenanță. \nProgramatorii noștrii lucrează la executarea acesteia în cel mai scurt timp.',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
