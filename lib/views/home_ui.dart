// ignore_for_file: prefer_const_constructors, must_be_immutable, unused_local_variable, unused_import

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:my_trip_project/models/user.dart';
import 'package:my_trip_project/models/trip.dart';
import 'package:my_trip_project/services/call_api.dart';
import 'package:my_trip_project/utils/env.dart';
import 'package:my_trip_project/views/new_trip_ui.dart';
import 'package:my_trip_project/views/up_del_trip_ui.dart';
import 'package:my_trip_project/views/update_profile_ui.dart';

class HomeUI extends StatefulWidget {
  User? user;
  Trip? trip;

  HomeUI({super.key, this.user, this.trip});
  

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  //ตัวแปรเก็บข้อมูลการกินที่ได้ขากการเรียกใช้API
  Future<List<Trip>>? tripData;

  //สร้างฟังก์ชันเรียกใช้API
  getAlltripByUserId(Trip trip) {
    setState(() {
      tripData = CallAPI.callgetAlltripByUserId(trip);
    });
  }

  @override
  void initState() {
    Trip trip = Trip(
      user_id: widget.user!.user_id,
    );
    getAlltripByUserId(trip);
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
//AppBar
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          'บันทึกการเดินทาง',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                // Navigator.pop(context,);
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                } else if (Platform.isIOS) {
                  exit(0);
                }
              },
              icon: Icon(
                Icons.logout,
              ))
        ],
      ),
      body: Center(
          child: Container(
            child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.045,
            ),
            //Profile
            ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              '${Env.hostName}/mt6552410011/pickupload/user/${widget.user!.userImage}',
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.width * 0.35,
              fit: BoxFit.cover,
            ),
          ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),
            //username
            Text(
              'ชื่อผู้ใช้ : ${widget.user!.username}',
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),
            //Email
            Text(
              'อีเมล : ${widget.user!.email}',
            ),
            //update profile button
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateProfileUi(
                      user: widget.user,
                    ),
                  ),
                ).then((value) {
                  if (value != null) {
                    //เอาค่าที่ส่งกลับมาหลังจากแก้ไขเสร็จมาแก้ไขให้กับwidget.user
                    setState(() {
                      widget.user?.username = value.username;
                      widget.user?.password = value.password;
                      widget.user?.email = value.email;
                    });
                  }
                });
              },
              child: Text(
                'UPDATE PROFILE',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.015,
                    color: Colors.orange),
              ),
            ),
            //TripList
            Expanded(
              child: FutureBuilder<List<Trip>>(
                future: tripData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data![0].message == "0") {
                      return Text("ยังไม่ได้บันทึกการเดินทาง");
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpDelTripUi(
                                          trip: snapshot.data![index],
                                        ),
                                      ),
                                    ).then((value) {
                                      setState(() {
                                        Trip trip = Trip(
                                          user_id: widget.user!.user_id,
                                        );
                                        getAlltripByUserId(trip);
                                      });
                                    });
                                },
                                
                                tileColor: index % 2 == 0
                                    ? Colors.blue[50]
                                    : Colors.orange[50],
                                leading: ClipRRect(
                                      child: Image.network(
                                        '${Env.hostName}/mt6552410011/pickupload/trip/${snapshot.data![index].tripImage}',
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),  
                                title: Text(
                                  snapshot.data![index].locationName!,
                                ),
                                subtitle: Text(
                                      'วันที่เริ่มการเดินทาง : ${snapshot.data![index].startDate}',
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.orange[800],
                                    ),
                                
                              ),
                              Divider(),
                            ]);
                          });
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.045,
            ),
                    ],
                  ),
          )),
//new trip button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewTripUi(
              user_id: widget.user!.user_id!,
            )
            ),
            ).then((value) {
            setState(() {
              Trip diaryfood = Trip(
                user_id: widget.user!.user_id!,
              );
              getAlltripByUserId(diaryfood);
            });
          }
          );
        },
        // child: Icon(
        //   Icons.add,
        //   color: Colors.white,
        // ),
        // child: Text(
        //   'เพิ่มการกิน',
        //   textAlign: TextAlign.center,
        // ),
        label: Text(
          'เพิ่มการกิน',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.orange[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
