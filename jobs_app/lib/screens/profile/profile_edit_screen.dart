import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/users.dart';
import './change_password_screen.dart';

class ProfileEditScreen extends StatefulWidget {
  static final routeName = '/edit-profile';

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _form = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  int dropdownAgeValue;

  List<int> _years = [];

  var _editedUser = User(
    id: null,
    email: '',
    firstName: '',
    lastName: '',
    password: '',
    token: '',
    expiryDate: null,
    birthYear: 0,
    gender: 0,
    phone: 0,
    description: '',
  );

  var _initValues = {
    'email': '',
    'firstName': '',
    'lastName': '',
    'password': '',
    'token': '',
    'expiryDate': '',
    'birthYear': '',
    'gender': '',
    'phone': '',
    'description': '',
  };
  var _isInit = true;
  var _isLoading = false;
  User _currentUser;

  void populateAges() {
    for (int i = 2002; i >= 1900; i--) {
      _years.add(i);
    }
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      populateAges();
      Provider.of<Users>(context).fetchAndSetUser().then((_) {
        setState(() {
          _isLoading = false;
          _currentUser = Provider.of<Users>(
            context,
            listen: false,
          ).getCurrentUser();
          _initValues = {
            'email': _currentUser.email,
            'firstName': _currentUser.firstName,
            'lastName': _currentUser.lastName,
            'password': _currentUser.password,
            'token': _currentUser.token,
            'expiryDate': _currentUser.expiryDate.toString(),
            'birthYear': _currentUser.birthYear.toString(),
            'gender': _currentUser.gender.toString(),
            'phone':
                _currentUser.phone == null ? '' : _currentUser.phone.toString(),
            'description': _currentUser.description == null
                ? ''
                : _currentUser.description,
          };
          _editedUser = User(
            id: _currentUser.id,
            email: _editedUser.email,
            password: _currentUser.password,
            firstName: _editedUser.firstName,
            lastName: _editedUser.firstName,
            token: _currentUser.token,
            expiryDate: _currentUser.expiryDate,
            birthYear: _currentUser.birthYear,
            gender: _currentUser.gender,
            phone: _editedUser.phone,
            description: _editedUser.description,
          );

          dropdownAgeValue = _currentUser.birthYear;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    await Provider.of<Users>(context, listen: false)
        .updateUser(_editedUser.id, _editedUser);
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              color: Colors.white,
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
              ),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          //width: 110.0,
                          //height: 150.0,
                          width: screenSize.height / 6.2,
                          height: screenSize.height / 4.5,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/profil.jpeg'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: Colors.white,
                              width: 3.0,
                            ),
                          ),
                          alignment: Alignment(-1.0, 1.0),
                          child: IconButton(
                            icon: Icon(
                              Icons.mode_edit,
                              color: Colors.white70,
                            ),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          width:
                              screenSize.width - 55 - (screenSize.height / 6.2),
                          margin: EdgeInsets.only(
                            top: screenSize.height / 14.4,
                          ),
                          child: Center(
                            child: FlatButton(
                              child: Text(
                                'Alege o fotografie de profil',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              onPressed: () {
                                //_editProfile(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Editează detaliile profilului',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      enabled: false,
                      initialValue:
                          _initValues['gender'] == '0' ? 'Bărbat' : 'Femeie',
                      decoration: InputDecoration(
                        labelText: 'Sex',
                      ),
                      style: TextStyle(color: Colors.black87),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: _initValues['firstName'],
                      decoration: InputDecoration(labelText: 'Prenume'),
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 17),
                      focusNode: _firstNameFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_lastNameFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Prenumele nu poate fi gol!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedUser = User(
                          id: _editedUser.id,
                          email: _editedUser.email,
                          password: _editedUser.password,
                          firstName: value,
                          lastName: _editedUser.lastName,
                          token: _editedUser.token,
                          expiryDate: _editedUser.expiryDate,
                          birthYear: _editedUser.birthYear,
                          gender: _editedUser.gender,
                          phone: _editedUser.phone,
                          description: _editedUser.description,
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: _initValues['lastName'],
                      decoration: InputDecoration(labelText: 'Nume'),
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 17),
                      focusNode: _lastNameFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_emailFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Numele nu poate fi gol!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedUser = User(
                          id: _editedUser.id,
                          email: _editedUser.email,
                          password: _editedUser.password,
                          firstName: _editedUser.firstName,
                          lastName: value,
                          token: _editedUser.token,
                          expiryDate: _editedUser.expiryDate,
                          birthYear: _editedUser.birthYear,
                          gender: _editedUser.gender,
                          phone: _editedUser.phone,
                          description: _editedUser.description,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['email'],
                      decoration: InputDecoration(labelText: 'E-mail'),
                      textInputAction: TextInputAction.next,
                      focusNode: _emailFocusNode,
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 17),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_phoneFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Invalid email!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedUser = User(
                          id: _editedUser.id,
                          email: value,
                          password: _editedUser.password,
                          firstName: _editedUser.firstName,
                          lastName: _editedUser.lastName,
                          token: _editedUser.token,
                          expiryDate: _editedUser.expiryDate,
                          birthYear: _editedUser.birthYear,
                          gender: _editedUser.gender,
                          phone: _editedUser.phone,
                          description: _editedUser.description,
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: _initValues['phone'],
                      decoration: InputDecoration(
                        labelText: 'Telefon',
                        prefixText: '+40',
                        prefixStyle: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      focusNode: _phoneFocusNode,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 17),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Te rog introdu numarul de telefon.';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Te rog introdu un numar de telefon valid.';
                        }
                        if (int.parse(value) <= 0 ||
                            int.parse(value) < 100000000 ||
                            int.parse(value) > 999999999) {
                          return 'Te rog introdu un numar de telefon valid.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedUser = User(
                          id: _editedUser.id,
                          email: _editedUser.email,
                          password: _editedUser.password,
                          firstName: _editedUser.firstName,
                          lastName: _editedUser.lastName,
                          token: _editedUser.token,
                          expiryDate: _editedUser.expiryDate,
                          birthYear: _editedUser.birthYear,
                          gender: _editedUser.gender,
                          phone: int.tryParse(value),
                          description: _editedUser.description,
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Anul nașterii',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    //SizedBox(height: -5,),
                    Container(
                      width: double.infinity,
                      height: 56,
                      child: DropdownButton<int>(
                        value: dropdownAgeValue,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Theme.of(context).primaryColor,
                        ),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                        ),
                        isExpanded: true,
                        underline: Container(
                          margin: EdgeInsets.only(top: 3),
                          height: 3,
                          color: Colors.black12,
                        ),
                        onChanged: (int newValue) {
                          setState(() {
                            dropdownAgeValue = newValue;
                            _editedUser = User(
                              id: _editedUser.id,
                              email: _editedUser.email,
                              password: _editedUser.password,
                              firstName: _editedUser.firstName,
                              lastName: _editedUser.lastName,
                              token: _editedUser.token,
                              expiryDate: _editedUser.expiryDate,
                              birthYear: newValue,
                              gender: _editedUser.gender,
                              phone: _editedUser.phone,
                              description: _editedUser.description,
                            );
                          });
                        },
                        hint: Text(
                          "Anul nașterii",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 17,
                          ),
                        ),
                        items: _years
                            .map<DropdownMenuItem<int>>((int chosenValue) {
                          return DropdownMenuItem<int>(
                            value: chosenValue,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  chosenValue.toString(),
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Mini descriere'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
                      focusNode: _descriptionFocusNode,
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 17),
                      validator: (value) {
                        if (value.length >= 201) {
                          return 'Descrierea e prea lungă. Trebuie sa fie de cel mult 200 caractere';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedUser = User(
                          id: _editedUser.id,
                          email: _editedUser.email,
                          password: _editedUser.password,
                          firstName: _editedUser.firstName,
                          lastName: _editedUser.lastName,
                          token: _editedUser.token,
                          expiryDate: _editedUser.expiryDate,
                          birthYear: _editedUser.birthYear,
                          gender: _editedUser.gender,
                          phone: _editedUser.phone,
                          description: value,
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      child: RaisedButton(
                        onPressed: () {
                          _saveForm();
                        },
                        color: Theme.of(context).primaryColor,
                        textColor: Color(0xff075E54),
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                        child: Text(
                          'SALVEAZĂ DATELE PROFILULUI',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                          side: BorderSide(
                            color: Color(0xff075E54),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: FlatButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(ChangePasswordScreen.routeName, arguments: _currentUser);
                        },
                        child: Text(
                          'Schimbă parola',
                          style: TextStyle(
                            fontSize: 16,
                            //fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
