import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebar_animation/Models/User.dart';
import 'package:sidebar_animation/Services/DataHelpers.dart';
import 'package:sidebar_animation/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:sidebar_animation/classes/UpdateUser.dart';
import 'package:sidebar_animation/classes/schedulePage.dart';
import 'package:sidebar_animation/constants.dart';

class AccountSettings extends StatefulWidget with NavigationStates {
  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
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
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            height: 820,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/accountsettings.png'),
              fit: BoxFit.cover,
            )),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 100, 210, 0),
                  child: Center(
                    child: Text(
                      "Profile",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                FutureBuilder<User>(
//                future: databaseHelper.getData(),
                    future: databaseHelper2.getUser(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        print("mochkla lenaa *");
                      }
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 180, 20, 0),
                              child: Container(
                                height: 80,
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
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 0, 20, 0),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.green,
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.white,
                                          ),
                                          radius: 25,
                                        ),
                                      ),
                                      Text(
                                        "First name: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        snapshot.data.firstName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: Container(
                                height: 80,
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
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 0, 20, 0),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.red,
                                          child: Icon(
                                            Icons.perm_identity,
                                            color: Colors.white,
                                          ),
                                          radius: 25,
                                        ),
                                      ),
                                      Text(
                                        "Last name: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        snapshot.data.lastName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: Container(
                                height: 80,
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
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 0, 20, 0),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.amberAccent,
                                          child: Icon(
                                            Icons.email,
                                            color: Colors.white,
                                          ),
                                          radius: 25,
                                        ),
                                      ),
                                      Text(
                                        "Email: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        snapshot.data.email,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: Container(
                                height: 80,
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
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 0, 20, 0),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.orangeAccent,
                                          child: Icon(
                                            Icons.date_range,
                                            color: Colors.white,
                                          ),
                                          radius: 25,
                                        ),
                                      ),
                                      Text(
                                        "Created date: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        snapshot.data.createdDate.year
                                                .toString() +
                                            "-" +
                                            snapshot.data.createdDate.month
                                                .toString() +
                                            "-" +
                                            snapshot.data.createdDate.day
                                                .toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    }),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 60, 0, 5),
                  child: Container(
                    height: 60,
                    width: 350,
                    child: FlatButton(
                      child: Text(
                        "EDIT PROFILE",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue[600],
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            child: UpdateUser(
                              onValueChange: _onValueChange,
                              initialValue: _selectedId,
                            ));
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side:
                              BorderSide(color: Colors.blue[300], width: 1.5)),
                      color: Colors.blue[100],
                      splashColor: Colors.blue[300],
                      textColor: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
