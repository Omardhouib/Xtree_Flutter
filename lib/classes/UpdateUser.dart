import 'dart:async';
import 'dart:convert';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebar_animation/Models/Location.dart';
import 'package:sidebar_animation/Services/DataHelpers.dart';
import 'package:http/http.dart' as http;
import 'package:sidebar_animation/pages/Device/AddDevice.dart';
import 'package:sidebar_animation/sidebar/sidebar_layout.dart';

class UpdateUser extends StatefulWidget {
  UpdateUser({Key key, this.title, this.onValueChange, this.initialValue}) : super(key: key);
  final String title;
  final String initialValue;
  final void Function(String) onValueChange;
  @override
  UpdateUserState createState() => UpdateUserState();
}

class UpdateUserState extends State<UpdateUser> {
  void _onValueChange(String value) {
    setState(() {
      _selectedId = value;
    });
  }
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }
  String _selectedId;
  bool _isLoading = false;
  bool t3ada = false;
  bool faregh = false;
  final RoundedLoadingButtonController _btnController =
  new RoundedLoadingButtonController();
  final TextEditingController FirstNameController = new TextEditingController();
  final TextEditingController LastNameController = new TextEditingController();
  final TextEditingController EmailController = new TextEditingController();
  final TextEditingController OldPassController = new TextEditingController();
  final TextEditingController NewPassController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey<FormState>();
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        contentPadding: EdgeInsets.only(top: 10.0),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Update Profile",style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                ),
                ),
              ),
              Form(
                key: _key,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey[100]))),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "First name cannot be empty !";
                          } else
                            return null;
                        },
                        controller: FirstNameController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.person, color: Colors.grey[400]),
                            border: InputBorder.none,
                            hintText: "New First Name",
                            hintStyle: TextStyle(color: Colors.grey[400])),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey[100]))),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Device name cannot be empty !";
                          } else
                            return null;
                        },
                        controller: LastNameController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.perm_identity, color: Colors.grey[400]),
                            border: InputBorder.none,
                            hintText: "New Last Name",
                            hintStyle: TextStyle(color: Colors.grey[400])),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey[100]))),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Device name cannot be empty !";
                          } else
                            return null;
                        },
                        controller: EmailController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.email, color: Colors.grey[400]),
                            border: InputBorder.none,
                            hintText: "New Email",
                            hintStyle: TextStyle(color: Colors.grey[400])),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TextFormField(
                        validator: (value) =>
                        value.isEmpty ? 'Password cannot be blank' : null,
                        controller: OldPassController,
                        style: TextStyle(color: Colors.black),
//                    obscureText: true,
                        obscureText:
                        !_passwordVisible, //This will obscure text dynamically
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.security, color: Colors.grey[400]),
                          hintText: "Old password",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TextFormField(
                        validator: (value) =>
                        value.isEmpty ? 'Password cannot be blank' : null,
                        controller: NewPassController,
                        style: TextStyle(color: Colors.black),
//                    obscureText: true,
                        obscureText:
                        !_passwordVisible, //This will obscure text dynamically
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.security, color: Colors.grey[400]),
                          hintText: "New password",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 200,
                child: FlatButton(
                  color: Colors.amberAccent,
                  child: Text("Update Profile", style: TextStyle(color: Colors.white)),
                  onPressed: _doSomething,
                ),
              ),
            ],
          ),
        )
    );
  }

  DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();
  final _key = GlobalKey<FormState>();
  void _doSomething() async {
    Timer(Duration(seconds: 1), () {
      print("button pressed ");
      Addlocation(FirstNameController.text, LastNameController.text, EmailController.text, OldPassController.text, NewPassController.text);
    });
  }

  void Addlocation(String firstname, String lastname, String email, String oldpass, String newpass) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    var jsonResponse = null;
    Map data = {
      "FirstName": "$firstname",
      "LastName": "$lastname",
      "email": "$email",
      "password": "$oldpass",
      "newPassword": "$newpass",
      "smsNotif": false,
      "emailNotif": true,
      "pushNotif": false
    };
    String myUrl = DatabaseHelper2.serverUrl + "/dashboard/UpdateProfile?token=" + value;
    var response = await http.post(myUrl,
        headers: {"Content-Type": "application/json"},
        body:
        json.encode(data)
    );
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] == "ok") {
        setState(() {
          t3ada = true;
          _isLoading = false;
        });
        await Fluttertoast.showToast(
            msg: "Profile updated !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 10.0);
        showDialog(
            context: context,
            child: SideBarLayout());
      } else if ((jsonResponse['message'] == "Wrong Password")) {
        await Fluttertoast.showToast(
            msg: "Something goes wrong !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 10.0);
      }
    }
  }
}
