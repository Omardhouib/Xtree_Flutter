import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sidebar_animation/Services/DataHelpers.dart';
import 'package:sidebar_animation/pages/Device/UpdateSens.dart';
import 'package:sidebar_animation/pages/Device/VerfiyDevice.dart';
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

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: 200,
              height: 130,
              decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              color: Colors.white,
            ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 18, 0, 20),
                    child: IconButton(
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: Colors.amber,
                        size: 50,
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(
                        "ADD DEVICE",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder(
//                future: databaseHelper.getData(),
              future: databaseHelper2.AllDeviceByUser1(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  print("mochkla lenaa *");
                }
                if (snapshot.hasData) {
                  return ItemList(list: snapshot.data);
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
                                          identifier: widget.list[i]["_id"]

                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Container(
                                    width: 250,
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            //list[i].toString() ?? '',
                                            widget.list[i]["name"].toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                            ),
                                          ),
                                          Text(
                                            //list[i].toString() ?? '',
                                            "Description: "+widget.list[i]["Description"].toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 11,
                                                color: Colors.grey
                                            ),
                                          ),
                                          Text(
                                            //list[i].toString() ?? '',
                                            "Type: "+widget.list[i]["SensorType"].toString(),
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
                                      identifier: widget.list[i]["_id"],
                                    ));
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 27,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: FutureBuilder(
//                future: databaseHelper.getData(),
                          future: databaseHelper2.getdataDeviceByID(widget.list[i]["_id"]),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              print(snapshot.error);
                              print("mochkla lenaa *");
                            }
                            if (snapshot.hasData) {
                              type = widget.list[i]["SensorType"];
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
