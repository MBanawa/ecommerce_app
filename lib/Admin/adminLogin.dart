import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Admin/uploadItems.dart';
import 'package:ecommerce_app/Authentication/authentication.dart';
import 'package:ecommerce_app/DialogBox/errorDialog.dart';
import 'package:ecommerce_app/Widgets/customTextField.dart';
import 'package:flutter/material.dart';

class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.teal,
                Colors.lightBlue,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          'iMercado Admin',
          style: TextStyle(
            fontSize: 40.0,
            color: Colors.white,
            fontFamily: 'Signatra',
          ),
        ),
        centerTitle: true,
      ),
      body: AdminSignInScreen(),
    );
  }
}

class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  final TextEditingController _adminIDtextEditingController =
      TextEditingController();
  final TextEditingController _passwordtextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        height: _screenHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.teal,
            Colors.lightBlue,
          ], begin: Alignment.topRight, end: Alignment.bottomLeft),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/images/admin.png',
                height: 240.0,
                width: 240.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Admin Area',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _adminIDtextEditingController,
                    data: Icons.email,
                    hintText: 'Enter Admin Username',
                    isObscure: false,
                  ),
                  CustomTextField(
                    controller: _passwordtextEditingController,
                    data: Icons.lock,
                    hintText: 'Enter Password',
                    isObscure: true,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    onPressed: () {
                      _adminIDtextEditingController.text.isNotEmpty &&
                              _passwordtextEditingController.text.isNotEmpty
                          ? loginAdmin()
                          : showDialog(
                              context: context,
                              builder: (c) {
                                return ErrorAlertDialog(
                                  message:
                                      'Please enter your Username and Password',
                                );
                              },
                            );
                    },
                    color: Colors.teal,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Log In',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Container(
                    height: 4.0,
                    width: _screenWidth * 0.9,
                    color: Colors.teal,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  FlatButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AuthenticScreen()),
                    ),
                    icon: Icon(
                      Icons.people,
                      color: Colors.tealAccent,
                    ),
                    label: Text(
                      'I\'m not an Admin',
                      style: TextStyle(
                          color: Colors.tealAccent,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  loginAdmin() {
    FirebaseFirestore.instance.collection('admins').get().then((snapshot) {
      snapshot.docs.forEach((result) {
        if (result.data()['id'] != _adminIDtextEditingController.text.trim()) {
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('The Username you entered was not found...')));
        } else if (result.data()['password'] !=
            _passwordtextEditingController.text.trim()) {
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('The Password you entered is incorrect...')));
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Welcome Admin,' + result.data()['name']),
          ));
          setState(() {
            _adminIDtextEditingController.text = "";
            _passwordtextEditingController.text = "";
            Route route = MaterialPageRoute(builder: (c) => UploadPage());
            Navigator.pushReplacement(context, route);
          });
        }
      });
    });
  }
}
