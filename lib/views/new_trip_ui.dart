// ignore_for_file: unused_field, unused_element, unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_trip_project/models/trip.dart';
import 'package:my_trip_project/services/call_api.dart';

class NewTripUi extends StatefulWidget {
  const NewTripUi({super.key});

  @override
  State<NewTripUi> createState() => _NewTripUiState();
}

class _NewTripUiState extends State<NewTripUi> {
//=========================================Variable v =================================================

//Textfield Controller
TextEditingController locationNameCtrl = TextEditingController();
  TextEditingController costCtrl = TextEditingController();
  TextEditingController startDateCtrl = TextEditingController();
  TextEditingController endDateCtrl = TextEditingController();
  TextEditingController latitudeCtrl = TextEditingController();
  TextEditingController longitudeCtrl = TextEditingController();
//image variable
  File? _imageSelected;
  
//Variable store camera/gallery convert to Base64 for sent to api
  String _image64Selected = '';

//variable meal
  int? meal;

//variable date
  String? _startDateSelected;
  String? _endDateSelected;
//variable lat lng ที่ดึงมา
  String? _latitude, _longitude;
  

//==================================Method / Function v===============================================
//++++++++++++++++Latitude Longitude+++++++++++++++++++++++++


//ตัวแปรเก็บตําแหน่งที่ Latitude, Longitude
  Position? currentPosition;
//method ดึงตําแหน่งปัจจุบัน
  void _getCurrentLocation() async {
    Position position = await _determinePosition();
    setState(() {
      currentPosition = position;
      _latitude = position.latitude.toString();
      _longitude = position.longitude.toString();
    });
  }
  Future<Position> _determinePosition() async {
    LocationPermission permission;
 
    permission = await Geolocator.checkPermission();
 
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permissions are denied');
      }
    }
 
    return await Geolocator.getCurrentPosition();
  }
//++++++++++++++++Latitude Longitude+++++++++++++++++++++++++

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

//++++++++++++++++Calendar+++++++++++++++++++++++++++++++
//Method open calendar start trip
  Future<void> _openCalendarStart() async {
    final DateTime? _picker = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (_picker != null) {
      setState(() {
        // startDateCtrl.text = convertToThaiDate(_picker);
        // _startDateSelected = _picker.toString().substring(0, 10);
         startDateCtrl.text = _picker.toString().substring(0, 10);
      });
    }

  }

  //Method open calendar end trip
  Future<void> _openCalendarEnd() async {
    final DateTime? _picker = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (_picker != null) {
      setState(() {  
        // endDateCtrl.text = convertToThaiDate(_picker);
        // _endDateSelected = _picker.toString().substring(0, 10);
         endDateCtrl.text = _picker.toString().substring(0, 10);
      });
    }

  }
/*
//เมธอดแปลงวันที่แบบสากล (ปี ค.ศ.-เดือน ตัวเลข-วัน ตัวเลข) ให้เป็นวันที่แบบไทย (วัน เดือน ปี)
  //                             2023-11-25
  convertToThaiDate(date) {
    String day = date.toString().substring(8, 10);
    String year = (int.parse(date.toString().substring(0, 4)) + 543).toString();
    String month = '';
    int monthTemp = int.parse(date.toString().substring(5, 7));
    switch (monthTemp) {
      case 1:
        month = 'มกราคม';
        break;
      case 2:
        month = 'กุมภาพันธ์';
        break;
      case 3:
        month = 'มีนาคม';
        break;
      case 4:
        month = 'เมษายน';
        break;
      case 5:
        month = 'พฤษภาคม';
        break;
      case 6:
        month = 'มิถุนายน';
        break;
      case 7:
        month = 'กรกฎาคม';
        break;
      case 8:
        month = 'สิงหาคม';
        break;
      case 9:
        month = 'กันยายน';
        break;
      case 10:
        month = 'ตุลาคม';
        break;
      case 11:
        month = 'พฤศจิกายน';
        break;
      default:
        month = 'ธันวาคม';
    }

    return day + ' ' + month + ' พ.ศ. ' + year;
  }
  */
//++++++++++++++++Calendar+++++++++++++++++++++++++++++++

//-------------------------------Show Dialog -------------------------------
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
//-------------------------------------------------------------------
//==========================================================================================
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      //AppBar
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          'เพิ่มบันทึกการเดินทาง',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
      ),

      //Body
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                height: MediaQuery.of(context).size.height * 0.075,
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.09,
              ),
              //Text locationName
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'สถานที่เดินทาง',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                ),
              ),
              //TextField locationName
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                  top: MediaQuery.of(context).size.height * 0.015,
                ),
                child: TextField(
                  controller: locationNameCtrl,
                  decoration: InputDecoration(
                    hintText: 'ป้อนชื่อสถานที่',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ),
              ),
              //Text cost
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  top: MediaQuery.of(context).size.height * 0.02,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ค่าใช้จ่าย',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                ),
              ),
              //TextField cost
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                  top: MediaQuery.of(context).size.height * 0.015,
                ),
                child: TextField(
                  controller: costCtrl,
                  decoration: InputDecoration(
                    hintText: 'ป้อนค่าใช้จ่าย',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ),
              ),
              //Text start date
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  top: MediaQuery.of(context).size.height * 0.02,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'วันที่เริ่มเดินทาง',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                ),
              ),
              //TextField start date
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                  top: MediaQuery.of(context).size.height * 0.02,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: startDateCtrl,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: 'เลือกวันที่เริ่มเดินทาง',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.orange,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _openCalendarStart();
                      },
                      icon: Icon(
                        Icons.calendar_month,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              //Text end date
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  top: MediaQuery.of(context).size.height * 0.02,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'วันที่สิ้นสุดเดินทาง',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                ),
              ),
              //TextField end date
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                  top: MediaQuery.of(context).size.height * 0.02,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: endDateCtrl,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: 'เลือกวันที่สิ้นสุดการเดินทาง',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.orange,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _openCalendarEnd();
                      },
                      icon: Icon(
                        Icons.calendar_month,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              //Text Latitude
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ละติจูด',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                ),
              ),
              //TextField Latitude
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                  top: MediaQuery.of(context).size.height * 0.015,
                ),
                child: TextField(
                  controller: latitudeCtrl,
                  decoration: InputDecoration(
                    hintText: 'ป้อนตำแหน่งละติจูด',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ),
              ),
              //Text Longitude
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ลองจิจูด',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                ),
              ),
              //TextField Longitude
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                  top: MediaQuery.of(context).size.height * 0.015,
                ),
                child: TextField(
                  controller: longitudeCtrl,
                  decoration: InputDecoration(
                    hintText: 'ป้อนตำแหน่งลองจิจูด',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              //save button
              ElevatedButton(
                onPressed: () {
                //Validate
                if (locationNameCtrl.text.trim().length == 0) {
                  showWaringDialog(context, 'ป้อนชื่อสถานที่ด้วย');
                } else if (costCtrl.text.trim().length == 0) {
                  showWaringDialog(context, 'ป้อนค่าใช้จ่ายด้วย');
                } else if (startDateCtrl.text.trim().length == 0) {
                  showWaringDialog(context, 'เลือกวันที่เริ่มเดินทางด้วย');
                } else if (endDateCtrl.text.trim().length == 0) {
                  showWaringDialog(context, 'เลือกวันที่สิ้นสุดเดินทางด้วย');
                } else {
                    //validate username and password from DB through API
                    //Create a variable to store data to be sent with the API
                  Trip member = Trip(
                        locationName: locationNameCtrl.text.trim(),
                        cost: costCtrl.text.trim(),
                        startDate: startDateCtrl.text.trim(),
                        endDate: endDateCtrl.text.trim(),
                      );
                    //call API
                    CallAPI.callnewTripAPI(member).then((value) {
                        if (value.message == '1') {
                          showCompleteDialog(context, 'บันทึกการเดินทางสําเร็จOvO').then((value) => Navigator.pop(context));
                        } else {
                          showCompleteDialog(context, 'บันทึกการเดินทางไม่สําเร็จ โปรดลองอีกครั้งTwT');
                        }
                      });
                }
                },
                child: Text(
                  'บันทึกการเดินทาง',
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
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
//cancel button              
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  'ยกเลิก',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  fixedSize: Size(
                    MediaQuery.of(context).size.width * 0.8,
                    MediaQuery.of(context).size.height * 0.07,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              ],
            ),
          ),
        ),
        ),
    );
  }
}