import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebar_animation/Models/Location.dart';
import 'package:sidebar_animation/Models/User.dart';
import 'package:sidebar_animation/Services/DataHelpers.dart';
import 'package:sidebar_animation/pages/Location/LocationDetails.dart';
import 'package:sidebar_animation/pages/loginPage.dart';

import '../bloc.navigation_bloc/navigation_bloc.dart';
import '../sidebar/menu_item.dart';

class SideBar extends StatefulWidget with NavigationStates {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar>
    with SingleTickerProviderStateMixin<SideBar> {
  DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();
  AnimationController _animationController;
  StreamController<bool> isSidebarOpenedStreamController;
  Stream<bool> isSidebarOpenedStream;
  StreamSink<bool> isSidebarOpenedSink;
  final _animationDuration = const Duration(milliseconds: 350);
  Future<List<Location>> AllLocation;

  @override
  void initState() {
    AllLocation = databaseHelper2.AllUserLocation();
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
  }

  @override
  void dispose() {
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();
    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted) {
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();
    return StreamBuilder<bool>(
      initialData: false,
      stream: isSidebarOpenedStream,
      builder: (context, isSideBarOpenedAsync) {
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          left: isSideBarOpenedAsync.data ? 0 : -screenWidth,
          right: isSideBarOpenedAsync.data ? 0 : screenWidth - 35,
          child: Row(
            children: <Widget>[
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                        Color(0xff222d33),
                        Color(0xff222d33),
                        Color(0xff222d33)
                      ])),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title:FutureBuilder<User>(
//                future: databaseHelper.getData(),
                              future: databaseHelper2.getUser(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  print(snapshot.error);
                                  print("mochkla lenaa *");
                                }
                                if (snapshot.hasData) {
                                  return Text(
                                    "Omar dhouib",
                                    style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 25,
                                        fontWeight: FontWeight.w800),
                                  );
                                } else {
                                return Container();
                                }
                              }),
                          subtitle: Text(
                            "XTREE",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 18,
                            ),
                          ),
                          leading: CircleAvatar(
                            child: Icon(
                              Icons.perm_identity,
                              color: Colors.grey[400],
                            ),
                            radius: 40,
                          ),
                        ),
                        Divider(
                          height: 34,
                          thickness: 0.9,
                          color: Colors.grey[400].withOpacity(0.3),
                          indent: 32,
                          endIndent: 32,
                        ),
                        ListTile(
                          leading: Icon(Icons.home),
                          title: Text(
                            "Dashboard",
                            style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 20,
                                fontWeight: FontWeight.normal),
                          ),
                          onTap: () {
                            onIconPressed();
                            BlocProvider.of<NavigationBloc>(context)
                                .add(NavigationEvents.HomePageClickedEvent);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.place),
                          title: Text(
                            "My sites",
                            style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 20,
                                fontWeight: FontWeight.normal),
                          ),
                          onTap: () {
                            onIconPressed();
                            BlocProvider.of<NavigationBloc>(context)
                                .add(NavigationEvents.MyOrdersClickedEvent);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.device_hub),
                          title: Text(
                            "My devices",
                            style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 20,
                                fontWeight: FontWeight.normal),
                          ),
                          onTap: () {
                            onIconPressed();
                            BlocProvider.of<NavigationBloc>(context)
                                .add(NavigationEvents.MyAccountClickedEvent);
                          },
                        ),
                        Divider(
                          height: 34,
                          thickness: 0.9,
                          color: Colors.grey[400].withOpacity(0.3),
                          indent: 32,
                          endIndent: 32,
                        ),
                        FutureBuilder<List<Location>>(
//                future: databaseHelper.getData(),
                            future: databaseHelper2.AllUserLocation(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                print(snapshot.error);
                                print("mochkla lenaa *");
                              }
                              if (snapshot.hasData) {
                                return itemList(list: snapshot.data);
                              } else {
                                return Container();
                              }
                            }),
                        Divider(
                          height: 34,
                          thickness: 0.9,
                          color: Colors.grey[400].withOpacity(0.3),
                          indent: 32,
                          endIndent: 32,
                        ),
                        ListTile(
                          leading: Icon(Icons.settings),
                          title: Text(
                            "Account settings",
                            style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 20,
                                fontWeight: FontWeight.normal),
                          ),
                          onTap: (){
                            onIconPressed();
                            BlocProvider.of<NavigationBloc>(context)
                                .add(NavigationEvents.MyProfileClickedEvent);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.exit_to_app),
                          title: Text(
                            "Logout",
                            style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 20,
                                fontWeight: FontWeight.normal),
                          ),
                          onTap: () async {
                            onIconPressed();
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            await preferences.clear();
                            await Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LoginPage()),
                                (Route<dynamic> route) => false);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  onIconPressed();
                },
                child: Container(
                  width: 70,
                  height: 1000,
                  color: Colors.transparent,
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40, 45, 0, 0),
                    child: AnimatedIcon(
                      progress: _animationController.view,
                      icon: AnimatedIcons.menu_arrow,
                      color: Colors.black,
                      size: 34,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget itemList({List list}) {
    return Container(
      height: 250,
      child: ListView.builder(
          itemCount: list == null ? 0 : list.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, i) {
//            DateTime t = DateTime.parse(list[i]['date_published'].toString());

            return Container(
              child: Column(
                children: <Widget>[
                  if (list[i].sensorIds.length == 0)
                    Row(
                      children: [
                        MenuItem(
                          icon: Icons.place,
                          title: list[i].siteName.toString(),
                          onTap: () => {
                          Fluttertoast.showToast(
                          msg: list[i].siteName+" does not have any device !",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 3,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 10.0)

                          },
                        ),
                        Container(
                          width: 17.0,
                          height: 27.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            color: Colors.red,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            list[i].sensorIds.length.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        MenuItem(
                          icon: Icons.place,
                          title: list[i].siteName.toString(),
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LocationDetails(identifier: list[i].id))),
                          },
                        ),
                        Container(
                          width: 17.0,
                          height: 27.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            color: Colors.green,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            //list[i].toString() ?? '',
                            list[i].sensorIds.length.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 20),
                ],
              ),
            );
          }),
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.grey[400];

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(-2, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

/*class ItemList extends StatelessWidget with NavigationStates {
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
            child: Column(
              children: <Widget>[
                if (list[i].sensorIds.length == 0)
                  Row(
                    children: [
                     MenuItem(
                          icon: Icons.place,
                          title: list[i].siteName.toString(),
                       onTap: () => {
                       onIconPressed();
              BlocProvider.of<NavigationBloc>(context)
              .add(NavigationEvents.HomePageClickedEvent);
        },
                        ),

                      Container(
                        width: 17.0,
                        height: 27.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          color: Colors.red,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          list[i].sensorIds.length.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      MenuItem(
                        icon: Icons.place,
                        title: list[i].siteName.toString(),
                        onTap: () => {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => LocationDetails( identifier: list[i].id))),
                        },
                      ),
                      Container(
                        width: 17.0,
                        height: 27.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          color: Colors.green,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          //list[i].toString() ?? '',
                          list[i].sensorIds.length.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 20),
              ],
            ),
          );
        });
  }
}*/
