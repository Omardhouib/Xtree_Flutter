import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sidebar_animation/Services/DataHelpers.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebar_animation/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:sidebar_animation/pages/homepage.dart';
import 'package:sidebar_animation/sidebar/sidebar.dart';
import 'dart:io';

import 'package:sidebar_animation/sidebar/sidebar_layout.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _key = GlobalKey<FormState>();
  final focusNode = FocusNode();
  bool _isLoading = false;
  bool t3ada = false;
  bool faregh = false;

  String _selectedId;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              focusNode.unfocus();
            },
            child: Container(
                height: 995,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/login.jpg'),
                        fit: BoxFit.fill,)),
                child: Column(
                  children: <Widget>[
                Container(
                    margin: EdgeInsets.fromLTRB(0, 150, 0, 0),
              child: Center(
                child: Text(
                  "XTREE",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 300, 15, 0),
                      child: Column(
                        children: <Widget>[
                          textSection(),

                          SizedBox(
                            height: 30,
                          ),

                          buttonSection(),

                          SizedBox(
                            height: 40,
                          ),

//                          Text(
//                            "Forgot Password?",
//                            style: TextStyle(
//                                color: Color.fromRGBO(143, 148, 251, 1)),
//                          )

                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: "If you don't have an account you can ",
                                    style: TextStyle(color: Colors.white)),
                                TextSpan(
                                    text: ' Sign Up',
                                    style: TextStyle(
                                        color: Colors.cyan[800],
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                                    recognizer: TapGestureRecognizer()
//                                      ..onTap = () => print('click')),
                                      ..onTap = () => showDialog(
                                          context: context,
                                          child: MyDialog(
                                            onValueChange: _onValueChange,
                                            initialValue: _selectedId,
                                          ))),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ),
          ),
    );
  }

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();

  void _doSomething() async {
    Timer(Duration(seconds: 1), () {
      print("button pressed ");
      print(" email" + emailController.text);
      print(" email" + passwordController.text);

      _btnController.stop();
      print(" key :" + _key.currentState.validate().toString());
      if (_key.currentState.validate()) {
        signIn(emailController.text, passwordController.text);
        _btnController.stop();
      }
    });
  }

  signIn(String email, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'email': email, 'password': pass};
    var jsonResponse = null;
    var response = await http.post(DatabaseHelper2.serverUrl + "/users/login",
        headers: {"Content-Type": "application/json"},
//        "http://192.168.56.81:3000/api/users/login",
        body: json.encode(data));
    log(response.statusCode);
    print('statusCode  :' + response.statusCode.toString());
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      if (jsonResponse['message'] == "Welcome Back") {
        setState(() {
          t3ada = true;
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse["token"]);

        print(jsonResponse.toString());
        await Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => SideBarLayout()),
            (Route<dynamic> route) => false);
      } else if ((jsonResponse['message'] == "Email Does not Exists") ||
          (jsonResponse['message'] == "Wrong Password")) {
        await Fluttertoast.showToast(
            msg: "Email or password is incorrect !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 10.0);
      }
    }

    print(response.body);
  }

  buttonSection() {
    return Container(
      height: 50,
      child: AspectRatio(
        child: RoundedLoadingButton(
          color: Colors.cyan[800],
          child: Text("Login", style: TextStyle(color: Colors.white)),
          controller: _btnController,
          onPressed: _doSomething,
        ),
        aspectRatio: 8,
      ),
    );
  }

  textSection() {
    return Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(143, 148, 251, .2),
                  blurRadius: 20.0,
                  offset: Offset(0, 10))
            ]),
        child: Form(
          key: _key,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Colors.white))),
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return " Mail can not be empty";
                    } else if (value.length <= 5) {
                      return "User name should be greater then 5";
                    } else
                      return null;
                  },
                  controller: emailController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      icon: Icon(Icons.email, color: Colors.cyan[800]),
                      border: InputBorder.none,
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.white)),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) =>
                      value.isEmpty ? 'Password cannot be blank' : null,
                  controller: passwordController,
                  style: TextStyle(color: Colors.white),
//                    obscureText: true,
                  obscureText:
                      !_passwordVisible, //This will obscure text dynamically
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.lock, color: Colors.cyan[800]),
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.white),
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.cyan[800],
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
              )
            ],
          ),
        ));
  }

  void _onValueChange(String value) {
    setState(() {
      _selectedId = value;
    });
  }
}

class MyDialog extends StatefulWidget {
  const MyDialog({this.onValueChange, this.initialValue});

  final String initialValue;
  final void Function(String) onValueChange;

  @override
  State createState() => new MyDialogState();
}

class MyDialogState extends State<MyDialog> {
  final _key = GlobalKey<FormState>();
  final _key2 = GlobalKey<FormState>();
  Color myColor = Color(0xff00bfa5);

  bool _passwordVisible;
  bool _password2Visible;
  var status;
  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _password2Visible = false;
  }

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController FirstNameController = new TextEditingController();

  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController password2Controller = new TextEditingController();

  final TextEditingController LastNameController = new TextEditingController();

  DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();

//  void _doSomething() async {
//    if (_key2.currentState.validate()) {
//      databaseHelper2.registerData(
//        emailController.text, usernameController.text, passwordController.text, password2Controller.text,numTelController.text);
//
//
//
//    }else{
//
//
//      await Fluttertoast.showToast(
//          msg: "There field are empty , try again . ",
//          toastLength: Toast.LENGTH_SHORT,
//          gravity: ToastGravity.BOTTOM,
//          timeInSecForIosWeb: 3,
//          backgroundColor: Colors.red,
//          textColor: Colors.white,
//          fontSize: 10.0
//      );
//    }
//  }

  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        contentPadding: EdgeInsets.only(top: 10.0),
        content: SingleChildScrollView(
//        width: 300.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Register",
                    style: TextStyle(fontSize: 24.0),
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Divider(
                color: Colors.grey,
                height: 4.0,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Form(
                        key: _key2,
                        child: Column(children: <Widget>[
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return " First name can not be empty";
                              } else
                                return null;
                            },
                            controller: FirstNameController,
                            decoration: InputDecoration(
                                icon:
                                    Icon(Icons.person, color: Colors.grey[400]),
                                border: InputBorder.none,
                                hintText: "First name",
                                hintStyle: TextStyle(color: Colors.grey[400])),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return "  Last name can not be empty";
                              } else
                                return null;
                            },
                            controller: LastNameController,
                            decoration: InputDecoration(
                              icon: Icon(Icons.person, color: Colors.grey[400]),
                              border: InputBorder.none,
                              hintText: "Last name",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return " Email can not be empty";
                              } else
                                return null;
                            },
                            controller: emailController,
                            decoration: InputDecoration(
                                icon: Icon(Icons.alternate_email,
                                    color: Colors.grey[400]),
                                border: InputBorder.none,
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.grey[400])),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return " Password can not be empty";
                              } else
                                return null;
                            },
                            controller: passwordController,
                            obscureText:
                                !_passwordVisible, //This will obscure text dynamically

                            decoration: InputDecoration(
                              icon: Icon(Icons.power_input,
                                  color: Colors.grey[400]),
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.cyan[800],
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
                        ]),
                      ),
                    ],
                  )),
              InkWell(
                splashColor: myColor,
                child: Container(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.cyan[800],
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32.0),
                        bottomRight: Radius.circular(32.0)),
                  ),
                  child: Text(
                    "Confirm",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () {
                  if(FirstNameController.text == ""){
                    Fluttertoast.showToast(
                        msg: "Please define your first name !",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 5,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 10.0);
                  }
                  else if(LastNameController.text == ""){
                    Fluttertoast.showToast(
                        msg: "Please define your last name !",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 5,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 10.0);
                  }
                  else if(LastNameController.text == ""){
                    Fluttertoast.showToast(
                        msg: "Please define your email address !",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 5,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 10.0);
                  }
                  else if(LastNameController.text == ""){
                    Fluttertoast.showToast(
                        msg: "Please define your password !",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 5,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 10.0);
                  }
                  else if(LastNameController.text == ""){
                    Fluttertoast.showToast(
                        msg: "Please confirm your password !",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 5,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 10.0);
                  }
                  _doSomething();
//
                },
              ),
            ],
          ),
        ));
  }

  void _doSomething() async {
    Timer(Duration(seconds: 1), () {
      if (_key2.currentState.validate()) {
        registerData(FirstNameController.text, LastNameController.text,
            emailController.text, passwordController.text, 1);
      }
    });
  }

  registerData(String FirstName, String LastName, String email, String password,
      num enabled) async {
    Map data = {
      "FirstName": "$FirstName",
      "LastName": "$LastName",
      "email": "$email",
      "password": "$password",
      "enabled": 1
    };

    final response =
        await http.post(DatabaseHelper2.serverUrl + "/users/register",

            headers: {"Content-Type": "application/json"},
            body: json.encode(data));
    status = response.body.contains('error');

    var statu = response.statusCode;

    print(' datas : ' + response.body);
    print(' message : ' + json.decode(response.body)['message']);
    print(' statu : ' + statu.toString());

    if (json.decode(response.body)['message'] !=
        "Account Create ! You can now Login") {
      await Fluttertoast.showToast(
          msg: "Email Already Exists",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 10.0);
    }
    else {
      await Fluttertoast.showToast(
          msg: "Registration successfully completed !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 10.0);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPage()));
    }

  }
}
