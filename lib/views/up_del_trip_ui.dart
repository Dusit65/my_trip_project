// ignore_for_file: unused_field, unused_element, must_be_immutable

import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_trip_project/models/trip.dart';
import 'package:my_trip_project/services/call_api.dart';
import 'package:my_trip_project/utils/env.dart';

class UpDelTripUi extends StatefulWidget {
  Trip? trip;
  UpDelTripUi({super.key, this.trip});

  @override
  State<UpDelTripUi> createState() => _UpDelTripUiState();
}

class _UpDelTripUiState extends State<UpDelTripUi> {
  //=========================================Variable v =================================================

//Textfield Controller
  TextEditingController locationNameCtrl = TextEditingController();
  TextEditingController costCtrl = TextEditingController();
  TextEditingController startDateCtrl = TextEditingController();
  TextEditingController endDateCtrl = TextEditingController();
//image variable
  File? _imageSelected;
  File? _imageSelected2;
  File? _imageSelected3;

//Variable store camera/gallery convert to Base64 for sent to api
  String _image64Selected = '';
  String _image64Selected2 = '';
  String _image64Selected3 = '';

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
  Future<void> _getCurrentLocation() async {
    Position position = await _determinePosition();
    if (!mounted) return; // Check if the widget is still in the tree
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

  Future<void> _openCamera2() async {
    final XFile? _picker = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (_picker != null) {
      setState(() {
        _imageSelected2 = File(_picker.path);
        _image64Selected2 = base64Encode(_imageSelected2!.readAsBytesSync());
      });
    }
  }

  Future<void> _openCamera3() async {
    final XFile? _picker = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (_picker != null) {
      setState(() {
        _imageSelected3 = File(_picker.path);
        _image64Selected3 = base64Encode(_imageSelected3!.readAsBytesSync());
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

  Future<void> _openGallery2() async {
    final XFile? _picker = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (_picker != null) {
      setState(() {
        _imageSelected2 = File(_picker.path);
        _image64Selected2 = base64Encode(_imageSelected2!.readAsBytesSync());
      });
    }
  }

  Future<void> _openGallery3() async {
    final XFile? _picker = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (_picker != null) {
      setState(() {
        _imageSelected3 = File(_picker.path);
        _image64Selected3 = base64Encode(_imageSelected3!.readAsBytesSync());
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
  void initState() {
    _getCurrentLocation();
    locationNameCtrl.text = widget.trip!.locationName!;
    costCtrl.text = widget.trip!.cost!;
    startDateCtrl.text = widget.trip!.startDate!;
    endDateCtrl.text = widget.trip!.endDate!;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
//AppBar
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          'แก้ไข/ลบ บันทึกการเดินทาง',
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
          child: Column(children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.075,
            ),
            //Avatar
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.end,
            //   children: [
            //     Container(
            //       width: MediaQuery.of(context).size.width * 0.5,
            //       height: MediaQuery.of(context).size.width * 0.5,
            //       decoration: BoxDecoration(
            //         border: Border.all(width: 4, color: Colors.orange),
            //         shape: BoxShape.circle,
            //         image: DecorationImage(
            //           image: _imageSelected == null
            //               ? NetworkImage(
            //                   '${Env.hostName}/mt6552410011/pickupload/trip/${widget.trip!.tripImage!}',
            //                 )
            //               : FileImage(_imageSelected!),
            //           fit: BoxFit.cover,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            CarouselSlider(
              options: CarouselOptions(
                enableInfiniteScroll: false,
              ),
              items: [
                //Pic1
                GestureDetector(
                  onTap: () {
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(width: 4, color: Colors.orange),
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                            image: _imageSelected == null
                                ? NetworkImage(
                                    '${Env.hostName}/mt6552410011/pickupload/trip/${widget.trip!.tripImage!}',
                                  )
                                : FileImage(_imageSelected!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //Pic2
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //open camera
                          ListTile(
                            onTap: () {
                              _openCamera2().then(
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
                              _openGallery2().then(
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(width: 4, color: Colors.orange),
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                            image: _imageSelected2== null
                                ? NetworkImage(
                                    '${Env.hostName}/mt6552410011/pickupload/trip/${widget.trip!.tripImage2!}',
                                  )
                                : FileImage(_imageSelected2!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //Pic3
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //open camera
                          ListTile(
                            onTap: () {
                              _openCamera3().then(
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
                              _openGallery3().then(
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(width: 4, color: Colors.orange),
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                            image: _imageSelected3 == null
                                ? NetworkImage(
                                    '${Env.hostName}/mt6552410011/pickupload/trip/${widget.trip!.tripImage3!}',
                                  )
                                : FileImage(_imageSelected3!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
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
            //save edit button
            ElevatedButton(
              onPressed: () {
                //validate Texfield location and cost
                if (locationNameCtrl.text.trim().length == 0) {
                  showWaringDialog(context, 'ป้อนชื่อสถานที่ด้วย');
                } else if (costCtrl.text.trim().length == 0) {
                  showWaringDialog(context, 'ป้อนค่าใช้จ่ายด้วย');
                } else {
                  //Packing Date
                  Trip trip;
                  if (_imageSelected == null) {
                    //in case not update image => Don't add "tripImage: _image64Selected,"
                    trip = Trip(
                      trip_id: widget.trip!.trip_id,
                      user_id: widget.trip!.user_id,
                      locationName: locationNameCtrl.text.trim(),
                      cost: costCtrl.text.trim(),
                      startDate: startDateCtrl.text.trim(),
                      endDate: endDateCtrl.text.trim(),
                      latitude: widget.trip!.latitude,
                      longitude: widget.trip!.longitude,
                    );
                  } else {
                    //in case update image
                    trip = Trip(
                      trip_id: widget.trip!.trip_id,
                      user_id: widget.trip!.user_id,
                      locationName: locationNameCtrl.text.trim(),
                      cost: costCtrl.text.trim(),
                      startDate: startDateCtrl.text.trim(),
                      endDate: endDateCtrl.text.trim(),
                      latitude: widget.trip!.latitude,
                      longitude: widget.trip!.longitude,
                      tripImage: _image64Selected, // add tripImage
                      tripImage2: _image64Selected, // add tripImage2
                      tripImage3: _image64Selected, // add tripImage3
                    );
                  }
                  //call api
                  CallAPI.callupdateTripAPI(trip).then((value) {
                    //ถ้าส่งข้อมูลสําเร็จ
                    if (value.message == '1') {
                      showCompleteDialog(
                          context, 'แก้ไขบันทึกเดินทางสําเร็จOvO').then((value) {
                          Navigator.pop(context, trip);
                      });
                    
                    } else {
                      showWaringDialog(context,
                          'แก้ไขบันทึกเดินทางไม่สําเร็จ โปรดลองใหม่อีกครั้งTwT');
                    }
                  });
                }
              },
              child: Text(
                'แก้ไขบันทึกการเดินทาง',
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
//delete button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  //packing data
                  Trip diaryfood = Trip(
                    trip_id: widget.trip!.trip_id,
                  );

                  // call API
                  CallAPI.calldeleteTripAPI(diaryfood).then((value) {
                    // if the data is successfully sent
                    if (value.message == '1') {
                      Navigator.pop(
                          context); // navigate back to the previous page
                      showCompleteDialog(context, 'ลบการกินสําเร็จOvO');
                    } else {
                      showWaringDialog(
                          context, 'ลบการกินไม่สําเร็จ โปรดลองใหม่อีกครั้งTwT');
                    }
                  });
                });
              },
              child: Text(
                'ลบการบันทึกเดินทาง',
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
          ]),
        )),
      ),
    );
  }
}
