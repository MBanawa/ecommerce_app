import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Config/config.dart';
import 'package:ecommerce_app/DialogBox/errorDialog.dart';
import 'package:ecommerce_app/DialogBox/loadingDialog.dart';
import 'package:ecommerce_app/Store/storehome.dart';
import 'package:ecommerce_app/Widgets/customTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nametextEditingController =
      TextEditingController();
  final TextEditingController _emailtextEditingController =
      TextEditingController();
  final TextEditingController _passwordtextEditingController =
      TextEditingController();
  final TextEditingController _cPasswordtextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUrl = '';
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 10.0,
            ),
            InkWell(
              onTap: _selectAndPickImage,
              child: CircleAvatar(
                radius: _screenWidth * 0.15,
                backgroundColor: Colors.white,
                backgroundImage:
                    _imageFile == null ? null : FileImage(_imageFile),
                child: _imageFile == null
                    ? Icon(
                        Icons.add_photo_alternate,
                        size: _screenWidth * 0.15,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nametextEditingController,
                    data: Icons.person,
                    hintText: 'Enter Name',
                    isObscure: false,
                  ),
                  CustomTextField(
                    controller: _emailtextEditingController,
                    data: Icons.email,
                    hintText: 'Enter Email Address',
                    isObscure: false,
                  ),
                  CustomTextField(
                    controller: _passwordtextEditingController,
                    data: Icons.lock,
                    hintText: 'Enter Password',
                    isObscure: true,
                  ),
                  CustomTextField(
                    controller: _cPasswordtextEditingController,
                    data: Icons.lock,
                    hintText: 'Confirm Password',
                    isObscure: true,
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                uploadAndSaveImage();
              },
              color: Colors.teal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Container(
              height: 4.0,
              width: _screenWidth * 0.9,
              color: Colors.teal,
            ),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }

  final _picker = ImagePicker();
  void _selectAndPickImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> uploadAndSaveImage() async {
    if (_imageFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: 'Please select an image..',
            );
          });
    } else {
      _passwordtextEditingController.text ==
              _cPasswordtextEditingController.text
          ? _emailtextEditingController.text.isNotEmpty &&
                  _passwordtextEditingController.text.isNotEmpty &&
                  _cPasswordtextEditingController.text.isNotEmpty &&
                  _nametextEditingController.text.isNotEmpty
              ? uploadToStorage()
              : displayDialog('Please complete the registration form..')
          : displayDialog('Passwords do not match!');
    }
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }

  uploadToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadinAlertDialog(
            message: 'Authenticating, Please wait....',
          );
        });

    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();

    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(imageFileName);
    StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;

    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      userImageUrl = urlImage;
      _registerUser();
    });
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _registerUser() async {
    User firebaseUser;

    await _auth
        .createUserWithEmailAndPassword(
      email: _emailtextEditingController.text.trim(),
      password: _passwordtextEditingController.text.trim(),
    )
        .then((auth) {
      firebaseUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });

    if (firebaseUser != null) {
      saveUserInfoToFireStore(firebaseUser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future saveUserInfoToFireStore(User fUser) async {
    FirebaseFirestore.instance.collection('users').doc(fUser.uid).set({
      'uid': fUser.uid,
      'email': fUser.email,
      'name': _nametextEditingController.text.trim(),
      'url': userImageUrl,
    });

    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userUID, fUser.uid);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userEmail, fUser.email);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userName, _nametextEditingController.text);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userAvatarUrl, userImageUrl);
    await EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ['garbageValue']);
  }
}
