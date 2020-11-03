import 'dart:io';

import 'package:ecommerce_app/Admin/adminShiftOrders.dart';
import 'package:ecommerce_app/Widgets/loadingWidget.dart';
import 'package:ecommerce_app/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  bool get wantKeepAlive => true;
  File imageFile;
  final _picker = ImagePicker();
  void capturePhotoWithCamera() async {
    Navigator.pop(context);
    final pickedFile = await _picker.getImage(
        source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        print('Path $imageFile');
      }
    });
  }

  void pickPhotoFromGallery() async {
    Navigator.pop(context);
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        print('Path $imageFile');
      }
    });
  }

  pickImage(ImageSource imageSource) async {
    Navigator.pop(context);
    final pickedFile = await ImagePicker().getImage(source: imageSource);
    setState(() {
      imageFile = File(pickedFile.path);
      print('Path $imageFile');
    });
  }

  TextEditingController _descriptionTextEditingController =
      TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _shortInfoTextEditingController =
      TextEditingController();
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return imageFile == null
        ? displayAdminHomeScreen()
        : displayAdminUploadFormScreen();
  }

  displayAdminHomeScreen() {
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
        leading: IconButton(
          icon: Icon(
            Icons.border_color,
            color: Colors.white,
          ),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
            Navigator.pushReplacement(context, route);
          },
        ),
        actions: [
          FlatButton(
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => SplashScreen());
              Navigator.pushReplacement(context, route);
            },
            child: Text(
              'Logout',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: getAdminHomeScreenBody(),
    );
  }

  getAdminHomeScreenBody() {
    return Container(
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shop_two,
              color: Colors.white,
              size: 200.0,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                color: Colors.green,
                onPressed: () => takeImage(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    9.0,
                  ),
                ),
                child: Text(
                  'Add New Items',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
      context: context,
      builder: (con) {
        return SimpleDialog(
          title: Text(
            'Item Image',
            style: TextStyle(
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            SimpleDialogOption(
              child: Text(
                'Take a Picture',
                style: TextStyle(
                  color: Colors.teal,
                ),
              ),
              onPressed: () => pickImage(ImageSource.camera),
            ),
            SimpleDialogOption(
              child: Text(
                'Select from Gallery',
                style: TextStyle(
                  color: Colors.teal,
                ),
              ),
              onPressed: () => pickImage(ImageSource.gallery),
            ),
            SimpleDialogOption(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.teal,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  displayAdminUploadFormScreen() {
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: clearFormInfo(),
        ),
        title: Text(
          'New Product',
          style: TextStyle(
              color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        actions: [
          FlatButton(
            onPressed: () => print('asedfasdf'),
            child: Text(
              'Add',
              style: TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading ? linearProgress() : Text(''),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(imageFile),
                      // fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 12.0)),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.teal,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepOrange),
                controller: _shortInfoTextEditingController,
                decoration: InputDecoration(
                  hintText: 'Enter Short Info',
                  hintStyle: TextStyle(color: Colors.deepOrange),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.teal,
          ),
          ListTile(
            leading: Icon(
              Icons.info,
              color: Colors.teal,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepOrange),
                controller: _titleTextEditingController,
                decoration: InputDecoration(
                  hintText: 'Product Title',
                  hintStyle: TextStyle(color: Colors.deepOrange),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.teal,
          ),
          ListTile(
            leading: Icon(
              Icons.notes,
              color: Colors.teal,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepOrange),
                controller: _descriptionTextEditingController,
                decoration: InputDecoration(
                  hintText: 'Enter Complete Product Description',
                  hintStyle: TextStyle(color: Colors.deepOrange),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.teal,
          ),
          ListTile(
            leading: Icon(
              Icons.money,
              color: Colors.teal,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepOrange),
                controller: _priceTextEditingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter Product Sell Price',
                  hintStyle: TextStyle(color: Colors.deepOrange),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.teal,
          ),
        ],
      ),
    );
  }

  clearFormInfo() {
    setState(() {
      imageFile = null;
      _descriptionTextEditingController.clear();
      _priceTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _titleTextEditingController.clear();
    });
  }
}
