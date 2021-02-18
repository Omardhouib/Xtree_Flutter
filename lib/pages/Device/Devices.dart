import 'package:flutter/material.dart';
import 'package:sidebar_animation/Services/DataHelpers.dart';
import 'package:sidebar_animation/pages/Device/deviceDetails.dart';
import '../../bloc.navigation_bloc/navigation_bloc.dart';
import 'dart:async';

class Devices extends StatelessWidget with NavigationStates {
  DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
//                future: databaseHelper.getData(),
          future: databaseHelper2.AllDeviceByUser1(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              print("mochkla lenaa *");
            }
            return snapshot.hasData
                ? ItemList(list: snapshot.data)
                : Center(
                    child: CircularProgressIndicator(),
                  );
          }),
    );
  }
}

class ItemList extends StatelessWidget {
  List list;
  ItemList({this.list});

  ScrollController _controller = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list == null ? 0 : list.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, i) {
//            DateTime t = DateTime.parse(list[i]['date_published'].toString());

          return Container(
            margin: EdgeInsets.symmetric(vertical: 2),
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.7,
            child: Stack(
              children: <Widget>[
                Positioned(
//                    top: 60,
                  top: MediaQuery.of(context).size.height * 0.08,
                  left: MediaQuery.of(context).size.width / 3.2,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 24),
                        child: Text(
                          'Device name is',
                        ),
                      ),
                        Padding(
                            padding: EdgeInsets.only(left: 24),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => deviceDetails(
                                        list:list,
                                        index: i,
                                        identifier: list[i]["_id"]

                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                //list[i].toString() ?? '',
                                list[i]["name"].toString(),
                              ),
                            )),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
