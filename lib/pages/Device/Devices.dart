import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebar_animation/Models/DevicesHome.dart';
import 'package:sidebar_animation/Models/Sensor.dart';
import 'package:sidebar_animation/Services/DataHelpers.dart';
import 'package:sidebar_animation/pages/Device/UpdateSens.dart';
import 'package:sidebar_animation/pages/Device/VerfiyDevice.dart';
import 'package:sidebar_animation/pages/Device/deleteDevVerifyLoc.dart';
import 'package:sidebar_animation/pages/Device/deviceDetails.dart';
import 'package:sidebar_animation/pages/homepage.dart';
import '../../bloc.navigation_bloc/navigation_bloc.dart';
import 'dart:async';

// ignore: must_be_immutable
class Devices extends StatefulWidget with NavigationStates {
  @override
  _DevicesState createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  @override
  String type;
  DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();

  void _onValueChange(String value) {
    setState(() {
      _selectedId = value;
    });
  }
  String _selectedId;
  Sensor Electro;
  Future<DevicesHome> DevicesHomedetails;

  @override
  void initState() {
    DevicesHomedetails = databaseHelper2.getDevicesdetails();


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 50, 0, 15),
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                Text(
                "Devices",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                ),
              ),
                      Text(
                        'Welcome Omar dhouib',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(190, 0, 0, 0),
                    child: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      child: Icon(
                        Icons.perm_identity,
                        size: 30,
                        color: Colors.blue,
                      ),
                      radius: 33,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            height: 90,
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 4,
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Row(
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.fromLTRB(15, 0, 40, 0),
                    child: CircleAvatar(
                      backgroundColor: Colors.amberAccent,
                      child: Icon(
                        Icons.add_circle,
                        color: Colors.white,
                      ),
                      radius: 25,
                    ),
                  ),
                  Text(
                    "ADD DEVICE ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(120, 0, 0, 0),
                    child: FlatButton(
                      child: Icon(
                        Icons.add_circle_outline,
                        color: Colors.amberAccent,
                        size: 35,
                      ),
                      onPressed: (){
                        showDialog(
                            context: context,
                            child: VerfiyDevice(
                              onValueChange: _onValueChange,
                              initialValue: _selectedId,
                            ));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 90,
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 4,
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Row(
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.fromLTRB(15, 0, 40, 0),
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      radius: 25,
                    ),
                  ),
                  Text(
                    "DELETE DEVICE ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(90, 0, 0, 0),
                    child: FlatButton(
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 35,
                      ),
                      onPressed: (){
                        showDialog(
                            context: context,
                            child: deleteDevVerifyLoc(
                              onValueChange: _onValueChange,
                              initialValue: _selectedId,
                            ));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder<DevicesHome>(
//                future: databaseHelper.getData(),
              future: DevicesHomedetails,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  print("mochkla lenaa *");
                }
                if (snapshot.hasData) {
                  return ItemList(list: snapshot.data.sensors);
                } else {
                  return Container();
                }
              }),
          FutureBuilder<DevicesHome>(
//                future: databaseHelper.getData(),
              future: DevicesHomedetails,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
               /* snapshot.data.electro.forEach((element) {
                  Electro.add(element);
                });*/
                  return ItemListElectro(list: snapshot.data.electro);
                } else {
                  return Container();
                }
              }),
        ],
      ),
    );

  }
}

class ItemList extends StatefulWidget {
  List list;
  ItemList({this.list});

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  String type;
  void _onValueChange(String value) {
    setState(() {
      _selectedId = value;
    });
  }
  String _selectedId;
  ScrollController _controller = new ScrollController();

  DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.list == null ? 0 : widget.list.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, i) {
            return Container(
              height: 460,
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 0,
                margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 00),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                        child: Row(

                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Icon(
                                Icons.developer_board,
                                color: Colors.white,
                              ),
                              radius: 25,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => deviceDetails(
                                        list:widget.list,
                                        index: i,
                                        identifier: widget.list[i].id

                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Container(
                                  width: 280,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        //list[i].toString() ?? '',
                                        widget.list[i].name.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        //list[i].toString() ?? '',
                                        "Identifier: "+widget.list[i].sensorIdentifier.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 11,
                                            color: Colors.grey
                                        ),
                                      ),
                                      Text(
                                        //list[i].toString() ?? '',
                                        "Type: "+widget.list[i].sensorType.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 11,
                                            color: Colors.grey
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                  size: 27,
                                ),
                                onPressed: (){
                                  showDialog(
                                      context: context,
                                      child: UpdateSens(
                                          onValueChange: _onValueChange,
                                          initialValue: _selectedId,
                                          identifier: widget.list[i].id,
                                          name: widget.list[i].name
                                      ));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: FutureBuilder(
//                future: databaseHelper.getData(),
                            future: databaseHelper2.getdataDeviceByID(widget.list[i].id),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                print(snapshot.error);
                                print("mochkla lenaa *");
                              }
                              if (snapshot.hasData) {
                                type = widget.list[i].sensorType;
                                return chart(snapshot.data, type);
                              } else {
                                return Container();
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            );

        });
  }

}
