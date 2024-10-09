// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_is_empty, use_build_context_synchronously

import 'package:flutter/material.dart';
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

//Boolean variable
  bool passStatus = true;

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
//Banner
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              "https://cdn.pixabay.com/photo/2020/02/02/03/39/man-4811935_1280.png",
              width: MediaQuery.of(context).size.width * 0.45,
              height: MediaQuery.of(context).size.width * 0.45,
              fit: BoxFit.cover,
            ),
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
//Login button
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
                if (usernameCtrl.text.trim().length == 0) {
                  showCompleteDialog(context, 'กรุณาป้อนชื่อผู้ใช้งาน');
                } else if (passwordCtrl.text.trim().length == 0) {
                  showCompleteDialog(context, 'กรุณาป้อนรหัสผ่าน');
                } else if (emailCtrl.text.trim().length == 0) {
                  showCompleteDialog(context, 'กรุณาป้อนอีเมล');
                } else {
                //validate username and password from DB through API
                //Create a variable to store data to be sent with the API
                User user = User(
                  username: usernameCtrl.text.trim(),
                  password: passwordCtrl.text.trim(),
                  email: emailCtrl.text.trim(),
                );
                //Call API
                CallAPI.callnewUserAPI(user).then((value) {
                  if (value.message == '1') {
                    showCompleteDialog(context, 'สมัครสมาชิกสําเร็จOvO').then((value) => Navigator.pop(context));
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
