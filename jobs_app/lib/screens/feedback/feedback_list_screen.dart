import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../screens/profile/public_profile_screen.dart';
import '../../providers/jobs.dart';

class FeedbackListScreen extends StatefulWidget {
  static const routeName = '/user-feedback-list';

  FeedbackListScreen();

  @override
  _FeedbackListScreenState createState() => _FeedbackListScreenState();
}

class _FeedbackListScreenState extends State<FeedbackListScreen> {
  List<Map<String, dynamic>> _userFeedbacks = [];
  Map<String, dynamic> _starlete = {};
  var _isInit = true;
  var _isLoading = true;
  int userId;

  String returnStarsText(int stars) {
    switch (stars) {
      case 1:
        return 'Dezamăgitoare';
      case 2:
        return 'Slabă';
      case 3:
        return 'Bună';
      case 4:
        return 'Foarte bună';
      case 5:
        return 'Excelentă';
      default:
        return 'Excelentă';
    }
  }

  Future<void> _goToProfileScreen(BuildContext context, String userId) async {
    await Navigator.of(context).pushNamed(
      PublicProfileScreen.routeName,
      arguments: userId,
    );
  }

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      final resRoute =
          ModalRoute.of(context).settings.arguments as List<String>;

      if (resRoute.length == 1 && resRoute[0] != 'profil') {
        userId = int.tryParse(resRoute[0]);

        await Provider.of<Jobs>(context, listen: false)
            .getFeedbacks(userId)
            .then((value) {
          setState(() {
            _userFeedbacks = value;
            _starlete = Provider.of<Jobs>(context, listen: false).calculateFeedback(value);
            _isLoading = false;
          });
        });
      } else {
        await Provider.of<Jobs>(context, listen: false)
            .getFeedbacks()
            .then((value) {
          setState(() {
            _userFeedbacks = value;
            _starlete = Provider.of<Jobs>(context, listen: false).calculateFeedback(value);
            _isLoading = false;
          });
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(
                          left: 25,
                          right: 25,
                          top: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 40.0),
                              child: _buildTitleText('Evaluări '),
                            ),
                            _buildStarIcon(_starlete['media'], _starlete['length']),
                            _buildGradeRow('Excelentă', _starlete['excelenta']),
                            _buildGradeRow('Foarte bună', _starlete['foarte_buna']),
                            _buildGradeRow('Bună', _starlete['buna']),
                            _buildGradeRow('Slabă', _starlete['slaba']),
                            _buildGradeRow('Dezamăgitoare', _starlete['dezamagitoare']),
                          ],
                        ),
                      ),
                      ListView.separated(
                        separatorBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(left: 25.0, right: 25),
                          child: Divider(
                            thickness: 0.2,
                            color: Colors.black87,
                          ),
                        ),
                        itemBuilder: (ctx, i) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
                          child: GestureDetector(
                            onTap: () {
                              _goToProfileScreen(context, _userFeedbacks[i]['user'].id);
                            },
                            child: Column(
                              children: <Widget>[
                                _buildUserRow(
                                    _userFeedbacks[i]['user'].firstName),
                                SizedBox(
                                  height: 30,
                                ),
                                _buildStarText(
                                    returnStarsText(_userFeedbacks[i]['stars'])),
                                _buildFeedbackText(
                                    context, _userFeedbacks[i]['text']),
                              ],
                            ),
                          ),
                        ),
                        itemCount: _userFeedbacks.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                      ),
                    ],
                  ),
                );
              },
              itemCount: 1,
            ),
    );
  }
}

Widget _buildTitleText(String title) {
  return Text(
    title,
    textAlign: TextAlign.start,
    style: const TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget _buildUserRow(String name) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(
        '$name',
        style: TextStyle(
            color: Colors.black87, fontSize: 19.0, fontWeight: FontWeight.w500),
      ),
      CircleAvatar(
        backgroundImage: AssetImage('assets/images/profil.jpeg'),
        radius: 26,
      ),
    ],
  );
}

Widget _buildGradeRow(String text, int number) {
  return Padding(
    padding: const EdgeInsets.only(top: 25.0, bottom: 25.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '$text',
          style: TextStyle(
              color: Colors.black54, fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
        Text(
          '$number',
          style: TextStyle(
              color: Colors.black87, fontSize: 20.0, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}

Widget _buildStarText(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          '$text',
          textAlign: TextAlign.start,
          style: TextStyle(
              color: Colors.black87, fontSize: 17.0, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}

Widget _buildStarIcon(double media, int nr_feedbacks) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10.0),
    child: Row(
      children: <Widget>[
        Icon(
          Icons.star,
          color: Colors.amberAccent,
          size: 30,
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          '$media/5 - $nr_feedbacks evaluări',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 17.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

Widget _buildFeedbackText(BuildContext context, String text) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Expanded(
        child: RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            text: '',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            children: <TextSpan>[
              TextSpan(
                text: '$text',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
//letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
