import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import '../../providers/auth.dart';

import '../../screens/feedback/feedback_list_screen.dart';
import '../../providers/users.dart';
import '../../providers/jobs.dart';
import './profile_edit_screen.dart';
import './public_profile_screen.dart';

class ProfileDetailsScreen extends StatefulWidget {
  static final routeName = '/profile-details';

  @override
  _ProfileDetailsScreenState createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  var _isInit = true;
  var _isLoading = false;
  var _currentUser;
  Map<String, dynamic> _starlete = {};
  int k = 0;

  void _editProfile(BuildContext context) {
    Navigator.of(context).pushNamed(ProfileEditScreen.routeName).then((value) {
      setState(() {
        k = 0;
        _isInit = true;
        _isLoading = true;
        didChangeDependencies();
      });
    });
  }

  void _goToFeedbackListScreen(BuildContext context) {
    Navigator.of(context).pushNamed(FeedbackListScreen.routeName,
        arguments: ['profil']).then((value) {
      setState(() {
        _isInit = true;
        _isLoading = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Users>(context, listen: false).fetchAndSetUser().then((_) {
        setState(() {
          _currentUser = Provider.of<Users>(
            context,
            listen: false,
          ).getCurrentUser();
          k++;
          if (k == 2) {
            _isLoading = false;
          }
        });
      });

      Provider.of<Jobs>(context, listen: false)
          .getFeedbackStars()
          .then((value) {
        setState(() {
          k++;
          _starlete = value;
          if (k == 2) {
            _isLoading = false;
          }
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Theme.of(context).primaryColor);
    Size screenSize = MediaQuery.of(context).size;

    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: ListView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
                      height: screenSize.height / 5.6,
                      width: double.infinity,
                      color: Theme.of(context).primaryColor,
                      //child: Text('Profilul meu'),
                    ),
                    SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            //SizedBox(height: screenSize.height / 19.4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 35,
                                    top: screenSize.height / 19.4,
                                  ),
                                  //width: 110.0,
                                  //height: 150.0,
                                  width: screenSize.height / 6.2,
                                  height: screenSize.height / 4.5,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/profil.jpeg'),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: screenSize.height / 14.4,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '${_currentUser.firstName} ${_currentUser.lastName}',
                                        //'Constantin Tuca',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        'Ambasador',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _goToFeedbackListScreen(context);
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.star,
                                              color: Colors.amberAccent,
                                              size: 30,
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            Text(
                                              '${_starlete['media']}/5 - ${_starlete['length']} evaluări',
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 19.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 35,
                    right: 35,
                    top: 25,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Detalii',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      _currentUser.phone != null && _currentUser.phone != ''
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Telefon',
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(Icons.phone),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      '0${_currentUser.phone}',
                                      //'0745049587',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )
                          : Container(
                              height: 0,
                              width: 0,
                            ),
                      SizedBox(
                        height: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Vârstă',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.perm_identity),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                //'${_currentUser.phone}',
                                '${2020 - _currentUser.birthYear} ani',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Email',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.email),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                //'${_currentUser.phone}',
                                '${_currentUser.email}',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.black12,
                      ),
                      _currentUser.description != null &&
                              _currentUser.description != ''
                          ? SizedBox(
                              height: 30,
                            )
                          : Container(
                              height: 0,
                              width: 0,
                            ),
                      _currentUser.description != null &&
                              _currentUser.description != ''
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Descriere',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  'Mini-biografie',
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(Icons.description),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      width: screenSize.width * 0.7,
                                      child: Text(
                                        //'${_currentUser.phone}',
                                        '  ${_currentUser.description}',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 5,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )
                          : Container(
                              height: 0,
                              width: 0,
                            ),
                      _currentUser.description != null &&
                              _currentUser.description != ''
                          ? SizedBox(
                              height: 30,
                            )
                          : Container(
                              height: 0,
                              width: 0,
                            ),
                      _currentUser.description != null &&
                              _currentUser.description != ''
                          ? Container(
                              height: 1,
                              width: double.infinity,
                              color: Colors.black12,
                            )
                          : Container(
                              height: 0,
                              width: 0,
                            ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: <Widget>[
                          Center(
                            child: FlatButton(
                              child: Text(
                                'Editează profilul',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              onPressed: () {
                                _editProfile(context);
                              },
                            ),
                          ),
                          Center(
                            child: FlatButton(
                              onPressed: () {
                                Provider.of<Auth>(context, listen: false)
                                    .logout();
                              },
                              child: Text(
                                'Ieși din cont',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
