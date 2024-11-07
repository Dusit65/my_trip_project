// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_is_empty, use_build_context_synchronously, unused_field

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_trip_project/models/user.dart';
import 'package:my_trip_project/services/call_api.dart';
import 'package:my_trip_project/views/login_ui.dart';

class RegisterUI extends StatefulWidget {
  const RegisterUI({super.key});

  @override
  State<RegisterUI> createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {
//TextField Controller
  TextEditingController usernameCtrl = TextEditingController(text: '');
  TextEditingController passwordCtrl = TextEditingController(text: '');
  TextEditingController emailCtrl = TextEditingController(text: '');
//image variable
  File? _imageSelected;

//Variable store camera/gallery convert to Base64 for sent to api
  String _image64Selected = '';
//Boolean variable
  bool passStatus = true;
//-----------------Camera/Gallery-----------------------------
//open camera method
  Future<void> _openCamera() async {
    final XFile? _picker = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (_picker != null) {
      setState(() {
        _imageSelected = File(_picker.path);
        _image64Selected = base64Encode(_imageSelected!.readAsBytesSync());
      });
    }
  }

//open gallery method
  Future<void> _openGallery() async {
    final XFile? _picker = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (_picker != null) {
      setState(() {
        _imageSelected = File(_picker.path);
        _image64Selected = base64Encode(_imageSelected!.readAsBytesSync());
      });
    }
  }

//-----------------Camera/Gallery-----------------------------

//Method showWaringDialog
  showWaringDialog(context, msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'คำเตือน',
          ),
        ),
        content: Text(
          msg,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'ตกลง',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

//Method showCompleteDialog
  Future showCompleteDialog(context, msg) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'ผลการทำงาน',
          ),
        ),
        content: Text(
          msg,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'ตกลง',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange[50],
        //AppBar
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text(
            'ลงทะเบียน',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginUI(),
                ),
              );
            },
            icon: Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: SingleChildScrollView(
            child: Center(
                child: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.045,
          ),
          //Avatar
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  border: Border.all(width: 4, color: Colors.orange),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _imageSelected == null
                        ? AssetImage(
                            'assets/images/banner map.jpg',
                          )
                        : FileImage(_imageSelected!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
//Icon camera
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //open camera
                        ListTile(
                          onTap: () {
                            _openCamera().then(
                              (value) => Navigator.pop(context),
                            );
                          },
                          leading: Icon(
                            Icons.camera_alt,
                            color: Colors.red,
                          ),
                          title: Text(
                            'Open Camera...',
                          ),
                        ),

                        Divider(
                          color: Colors.grey,
                          height: 5.0,
                        ),

                        //open gallery
                        ListTile(
                          onTap: () {
                            _openGallery().then(
                              (value) => Navigator.pop(context),
                            );
                          },
                          leading: Icon(
                            Icons.browse_gallery,
                            color: Colors.blue,
                          ),
                          title: Text(
                            'Open Gallery...',
                          ),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(
                  Icons.camera_alt,
                  color: Colors.orange,
                ),
              ),
            ],
          ),

//Text Username
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.1,
              top: MediaQuery.of(context).size.height * 0.03,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'ชื่อผู้ใช้ :',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                ),
              ),
            ),
          ),
//textfield Username
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
              top: MediaQuery.of(context).size.height * 0.015,
            ),
            child: TextField(
              controller: usernameCtrl,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.person_add,
                ),
                hintText: 'ป้อนชื่อผู้ใช้',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.orange,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.orange,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
//Text Password
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.1,
              top: MediaQuery.of(context).size.height * 0.03,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'รหัสผ่าน :',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                ),
              ),
            ),
          ),
//textfield Password
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
              top: MediaQuery.of(context).size.height * 0.015,
            ),
            child: TextField(
              controller: passwordCtrl,
              obscureText: passStatus,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      passStatus = !passStatus;
                    });
                  },
                  icon: Icon(
                    passStatus == true
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                ),
                hintText: 'ป้อนรหัสผ่าน',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.orange,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.orange,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
//Text Email
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.1,
              top: MediaQuery.of(context).size.height * 0.03,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'อีเมล :',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                ),
              ),
            ),
          ),
//textfield Email
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
              top: MediaQuery.of(context).size.height * 0.015,
            ),
            child: TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.email,
                ),
                hintText: 'ป้อนอีเมล',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.orange,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.orange,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
//register button
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
              top: MediaQuery.of(context).size.height * 0.03,
              bottom: MediaQuery.of(context).size.height * 0.1,
            ),
            child: ElevatedButton(
              onPressed: () {
                //validate
                if (_imageSelected == null) {
                  showCompleteDialog(context, 'กรุณาถ่ายรูป/อัปโหลดรูปโปรไฟล์ด้วย');
                } else if (usernameCtrl.text.trim().length == 0) {
                  showCompleteDialog(context, 'กรุณาป้อนรหัสผ่าน');
                } else if (passwordCtrl.text.trim().length == 0) {
                  showCompleteDialog(context, 'กรุณาป้อนรหัสผ่าน');
                } else if (emailCtrl.text.trim().length == 0) {
                  showCompleteDialog(context, 'กรุณาป้อนอีเมล');
                } else {
                  //Packing data
                  User user = User(
                    username: usernameCtrl.text.trim(),
                    password: passwordCtrl.text.trim(),
                    email: emailCtrl.text.trim(),
                    userImage: _image64Selected
                  );
                  //Call API
                  CallAPI.callnewUserAPI(user).then((value) {
                    if (value.message == '1') {
                      showCompleteDialog(context, 'สมัครสมาชิกสําเร็จOvO')
                          .then((value) => Navigator.pop(context));
                    } else {
                      showCompleteDialog(context, 'มีบางอย่างผิดพลาด');
                    }
                  });
                }
              },
              child: Text(
                'เข้าใช้งานระบบ',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                fixedSize: Size(
                  MediaQuery.of(context).size.width * 0.8,
                  MediaQuery.of(context).size.height * 0.07,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ]))));
  }
}
