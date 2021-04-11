
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebar_animation/Models/Location.dart';
import 'package:sidebar_animation/Models/LocationHome.dart';
import 'package:sidebar_animation/Models/Relay.dart';
import 'package:sidebar_animation/Models/Sensor.dart';
import 'package:sidebar_animation/Models/User.dart';
import 'package:sidebar_animation/Services/DataHelpers.dart';
import 'package:sidebar_animation/classes/ChartHistory.dart';
import 'package:sidebar_animation/classes/ChartLineClass.dart';
import 'package:sidebar_animation/classes/MultiSelectFormField.dart';
import 'package:sidebar_animation/classes/WeatherClass.dart';
import 'package:sidebar_animation/pages/homepage.dart';
import 'package:sidebar_animation/sidebar/sidebar_layout.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';
import 'package:sidebar_animation/constants.dart';
import 'package:sidebar_animation/graphic.dart' as graphic;
import 'package:flutter/gestures.dart';
import 'package:sidebar_animation/bloc.navigation_bloc/navigation_bloc.dart';

class schedulePage extends StatefulWidget with NavigationStates {
  Location location;
  Sensor sens;
  List<Sensor> Electro;
  List<Sensor> relay;
  schedulePage({this.location, this.sens, this.Electro, this.relay});

  @override
  schedulePageState createState() => schedulePageState();
}

class schedulePageState extends State<schedulePage> {
  DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();
  DateTime selectedDate = DateTime.now();
  List<dynamic> sensors = [];
  List<dynamic> Elec = [];
  final _formKey = GlobalKey<FormState>();
  List<String> _mode = ['Manuel mode', 'AI mode']; // Option 2
  String _selectedLocation;
  String _selectedGender = null;
  bool toast= true;
  final TextEditingController TmaxController = new TextEditingController();
  final TextEditingController TminController =
  new TextEditingController();
  _renderWidget() {
    if (_selectedLocation == "Manuel mode") {
      widget.Electro.forEach((element) {
        Elec.add({"item_id": element.id, "item_text": element.name});
      });
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0), color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 15),
                  child: Row(
                    children: [
                      Text(
                        'Device name: ',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        widget.sens.name,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 15),
                  child: Row(
                    children: [
                      Text(
                        'Device description: ',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        widget.sens.description,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                  child: Row(
                    children: [
                      Text(
                        'Device status: ',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        widget.sens.status.toString(),
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 15),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Start date:  ',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "${selectedDate.toLocal()}".split(' ')[0],
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Container(
                          width: 180,
                          height: 40,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(
                                    color: Colors.blue[300], width: 1.5)),
                            onPressed: () => _selectDate(context),
                            color: Colors.transparent,
                            textColor: Colors.blue,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.blue,
                                ),
                                Text(
                                  '      Select date',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 15),
                  child: Row(
                    children: [
                      Text(
                        'T max:  ',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      Container(
                        width: 80,
                        height: 50,
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "T max cannot be empty !";
                            } else
                              return null;
                          },
                          controller: TmaxController,
                          decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: Colors.blue[300], width: 1.0),
                            ),
                            hintText: "80",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          'T min:  ',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 50,
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "T min cannot be empty !";
                            } else
                              return null;
                          },
                          controller: TminController,
                          decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    color: Colors.blue[300], width: 1.5),
                              ),
                              hintText: "20",
                              hintStyle: TextStyle(color: Colors.grey[400])),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                  child: Row(
                    children: [
                      Text(
                        'Alert type: ',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Email',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 15),
                  child: Row(
                    children: [
                      Text(
                        'Relays:     ',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 13, 0, 0),
                        child: Form(
                          key: _formKey,
                          child: MultiSelectFormField(
                            context: context,
                            buttonText: 'Relays',
                            itemList: widget.Electro,
                            questionText: 'Select Your Relays',
                            validator: (flavours) => flavours.length == 0
                                ? 'Please select at least one Relay!'
                                : null,
                            onSaved: (flavours) {
                              print(widget.Electro);
                              // Logic to save selected flavours in the database
                            },
                          ),
                          onChanged: () {
                            if (_formKey.currentState.validate()) {
                              // Invokes the OnSaved Method
                              _formKey.currentState.save();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(37, 40, 0, 5),
                  child: Container(
                    height: 45,
                    width: 350,
                    child: FlatButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.save,
                            color: Colors.blue,
                          ),
                          Text(
                            '  Save',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      onPressed: (){
                        _doSomething();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                          side: BorderSide(color: Colors.grey,width: 1.5)

                      ),
                      color: Colors.white,
                      splashColor: Colors.grey,
                      textColor: Colors.black,
                    ),

                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(58, 0, 5, 0),
                      child: Container(
                        height: 45,
                        width: 150,
                        child: FlatButton(
                          child: Text("Start process",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),),
                          onPressed: (){
                            TurnOn(widget.sens.id);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              side: BorderSide(color: Colors.black,width: 0.5)

                          ),
                          color: Colors.green,
                          splashColor: Colors.green,
                          textColor: Colors.black,
                        ),

                      ),
                    ),
                    Container(
                      height: 45,
                      width: 150,
                      child: FlatButton(
                        child: Text("Stop process",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),),
                        onPressed: (){
                          TurnOff(widget.sens.id);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                            side: BorderSide(color: Colors.black,width: 0.5)

                        ),
                        color: Colors.red,
                        splashColor: Colors.red,
                        textColor: Colors.black,
                      ),

                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ); // this could be any Widget
    }
    else if (_selectedLocation == "AI mode"){
      widget.Electro.forEach((element) {
        Elec.add({"item_id": element.id, "item_text": element.name});
      });
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      String date = formatter.format(now);
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0), color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 15),
                  child: Row(
                    children: [
                      Text(
                        'Device name: ',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        widget.sens.name,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 15),
                  child: Row(
                    children: [
                      Text(
                        'Device description: ',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        widget.sens.description,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                  child: Row(
                    children: [
                      Text(
                        'Device status: ',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        widget.sens.status.toString(),
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 15),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Start date:  ',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        date.toString(),
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 15),
                  child: Row(
                    children: [
                      Text(
                        'T max:  ',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      Container(
                        width: 80,
                        height: 50,
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "T max cannot be empty !";
                            } else
                              return null;
                          },
                          controller: TmaxController,
                          decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: Colors.blue[300], width: 1.0),
                            ),
                            hintText: "80",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          'T min:  ',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 50,
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "T min cannot be empty !";
                            } else
                              return null;
                          },
                          controller: TminController,
                          decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    color: Colors.blue[300], width: 1.5),
                              ),
                              hintText: "20",
                              hintStyle: TextStyle(color: Colors.grey[400])),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                  child: Row(
                    children: [
                      Text(
                        'Alert type: ',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Email',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 15),
                  child: Row(
                    children: [
                      Text(
                        'Relays:     ',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 13, 0, 0),
                        child: Form(
                          key: _formKey,
                          child: MultiSelectFormField(
                            context: context,
                            buttonText: 'Relays',
                            itemList: widget.Electro,
                            questionText: 'Select Your Relays',
                            validator: (flavours) => flavours.length == 0
                                ? 'Please select at least one Relay!'
                                : null,
                            onSaved: (flavours) {
                              print(widget.Electro);
                              // Logic to save selected flavours in the database
                            },
                          ),
                          onChanged: () {
                            if (_formKey.currentState.validate()) {
                              // Invokes the OnSaved Method
                              _formKey.currentState.save();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(37, 40, 0, 5),
                  child: Container(
                    height: 45,
                    width: 350,
                    child: FlatButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.save,
                            color: Colors.blue,
                          ),
                          Text(
                            '  Save',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      onPressed: (){
                        Fluttertoast.showToast(
                            msg: "AI configurations are saved with success !",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 10,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 10.0);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                          side: BorderSide(color: Colors.grey,width: 1.5)

                      ),
                      color: Colors.white,
                      splashColor: Colors.grey,
                      textColor: Colors.black,
                    ),

                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(58, 0, 5, 0),
                      child: Container(
                        height: 45,
                        width: 150,
                        child: FlatButton(
                          child: Text("Start process",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),),
                          onPressed: (){
                            Fluttertoast.showToast(
                                msg: "Process started",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 10,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 10.0);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              side: BorderSide(color: Colors.black,width: 0.5)

                          ),
                          color: Colors.green,
                          splashColor: Colors.green,
                          textColor: Colors.black,
                        ),

                      ),
                    ),
                    Container(
                      height: 45,
                      width: 150,
                      child: FlatButton(
                        child: Text("Stop process",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),),
                        onPressed: (){
                          Fluttertoast.showToast(
                              msg: "Process stopped",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 10,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 10.0);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                            side: BorderSide(color: Colors.black,width: 0.5)

                        ),
                        color: Colors.red,
                        splashColor: Colors.red,
                        textColor: Colors.black,
                      ),

                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> flavours = [];
    String _chosenValue;
    var hour = DateTime.now().hour;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new IconButton(
                    icon: new Icon(Icons.arrow_back, color: Colors.black,size: 30,),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 25),
                      child: Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.location.siteName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
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
                                      return Text(
                                          'Welcome '+snapshot.data.firstName+' '+snapshot.data.lastName,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.grey,
                                            fontWeight:
                                            FontWeight.w500,
                                            fontStyle:
                                            FontStyle.normal,
                                          ));
                                    } else {
                                      return Container();
                                    }
                                  }),
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
                ]),
            FutureBuilder(
                future: databaseHelper2.Getweather(widget.location.id),
                builder: (context, snapshot2) {
                  if (snapshot2.hasError) {
                    print(snapshot2.error);
                    Container();
                  }
                  return snapshot2.hasData
                      ? WeatherClass(list: snapshot2.data)
                      : Container();
                }),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: Text(
                'Irrigation mode: ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey[300], width: 4),
                    color: Colors.white),
                child: DropdownButton(
                  hint: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(
                      'Please choose the mode',
                      style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                  ), // Not necessary for Option 1
                  value: _selectedLocation,
                  onChanged: (newValue) {
                    if (newValue == 'Manuel mode') {
                      setState(() {
                        _selectedLocation = newValue; // A, B or C
                      });
                    } else if (newValue == 'AI mode') {
                      setState(() {
                        _selectedLocation = newValue; // A, B or C
                      });
                    }
                  },
                  items: _mode.map((mode) {
                    return DropdownMenuItem(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Text(
                          mode,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                      value: mode,
                    );
                  }).toList(),
                ),
              ),
            ),
            Container(child: _renderWidget()),
            Itemchart(sensor: widget.sens)
          ],
        ),
      ),
    );
  }


  // DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();
  final _key = GlobalKey<FormState>();
  List<dynamic> NotifSelection = [];
  void _doSomething() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final prefs = await SharedPreferences.getInstance();
    final key = 'Electro';
    final value = Relay.relayFromJson(prefs.get(key)) ?? 0;

    NotifSelection.add({"item_id": 1, "item_text": "Email"});
    print("button pressed ");
    print(" max" + TmaxController.text);
    print(" min" + TminController.text);
    print(" date" + selectedDate.toIso8601String()+"Z");
    print(" relays" + value.toString());
    print(" relays" + NotifSelection.toString());
    if (TmaxController.text.isEmpty){
      Fluttertoast.showToast(
          msg: "T Max Cannot be empty!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 10,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 10.0);
    }
    else if (TminController.text.isEmpty){
      Fluttertoast.showToast(
          msg: "T Min Cannot be empty!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 10,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 10.0);
    }
    else if (int.parse(TmaxController.text) < int.parse(TminController.text) ){
      Fluttertoast.showToast(
          msg: "T Min Cannot be greater than T Max!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 10,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 10.0);
    }
    else if (int.parse(TmaxController.text) == int.parse(TminController.text) ){
      Fluttertoast.showToast(
          msg: "T Max and T Min Cannot be equal!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 10,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 10.0);
    }
    AddRules(widget.sens.id, NotifSelection, selectedDate, TmaxController.text, TminController.text, value);
    Fluttertoast.showToast(
        msg: "Manuel configurations are saved with success !",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 10.0);
    NotifSelection.clear();
    print(" relays" + value.toString());
    print(" relays" + NotifSelection.toString());


  }

  void AddRules(String id, List NotifSelection, DateTime startDate, String Tmax, String Tmin, Object value) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final token = prefs.get(key) ?? 0;
    var jsonResponse = null;
    List<dynamic> RelayConfiguration = [];
    RelayConfiguration.add({"NotifSelection": NotifSelection, "RelaySelection": value, "date": selectedDate.toIso8601String(), "TMax": Tmax, "TMin": Tmin});
    Map data = {
      "SensorId": "$id",
      "Rules": RelayConfiguration
    };    String myUrl = DatabaseHelper2.serverUrl + "/sensors/AddRules?token=" + token;
    var response = await http.post(myUrl,
        headers: {"Content-Type": "application/json"},
        body:
        json.encode(data)
    );
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      if (jsonResponse['message'] == "schedule saved") {
        await Fluttertoast.showToast(
            msg: "Schedule saved !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 10.0);
        NotifSelection.clear();
      } else if (jsonResponse['status'] == "err"){
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


  TurnOff(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    Map data = {'ProcessState': false, 'SensorId': "$id"};
    var jsonResponse = null;
    var response = await http.post(
        DatabaseHelper2.serverUrl + "/dashboard/ProcessConfiguration?token=" + value,
        headers: {"Content-Type": "application/json"},
//        "http://192.168.56.81:3000/api/users/login",
        body: json.encode(data));
    print('statusCode  :' + response.statusCode.toString());
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse['message'] == "Process Stopped") {
        await Fluttertoast.showToast(
            msg: "Process Stopped !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 10.0);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SideBarLayout(
                    )));
      }
    }
    print(response.body);
  }

  TurnOn(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    Map data = {'ProcessState': true, 'SensorId': "$id"};
    var jsonResponse = null;
    var response = await http.post(
        DatabaseHelper2.serverUrl + "/dashboard/ProcessConfiguration?token=" + value,
        headers: {"Content-Type": "application/json"},
//        "http://192.168.56.81:3000/api/users/login",
        body: json.encode(data));
    print('statusCode  :' + response.statusCode.toString());
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse['message'] == "Process Started") {
        await Fluttertoast.showToast(
            msg: "Process Started !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 10.0);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SideBarLayout(
                    )));
      }
    }
    print(response.body);
  }

  List<DropdownMenuItem<String>> _dropDownItem() {
    List<String> ddl = ['AI mode', 'Manuel mode'];
    return ddl
        .map((value) => DropdownMenuItem(
      value: value,
      child: Text(value),
    ))
        .toList();
  }
}

class Itemchart extends StatefulWidget {
  Sensor sensor;
  Itemchart({this.sensor});

  @override
  _ItemchartState createState() => _ItemchartState();
}

class _ItemchartState extends State<Itemchart> {
  DatabaseHelper2 databaseHelper2 = new DatabaseHelper2();

  ScrollController _controller = new ScrollController();
  void _onValueChange(String value) {
    setState(() {
      _selectedId = value;
    });
  }

  String _selectedId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Sensor>(
        future: databaseHelper2.getDevById(widget.sensor.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            print("there is problem !");
          }

          if (snapshot.hasData) {
            //  print("helloo" + snapshot.data.toString());
            String type = snapshot.data.sensorType;
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 90,
                      child: Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 0,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.lightBlue,
                                  child: IconButton(
                                    icon: Icon(Icons.history),
                                    color: Colors.white,
                                    iconSize: 30,
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          child: ChartHistory(
                                            onValueChange: _onValueChange,
                                            initialValue: _selectedId,
                                            identifier: snapshot.data.id,
                                            type: snapshot.data.sensorType,
                                            name: snapshot.data.name,
                                          ));
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0, 15, 0, 0),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data.name.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    "Identifier: "+snapshot.data.sensorIdentifier
                                        .toString(),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11,
                                    ),
                                  ),
                                  Text(
                                    "Type: "+snapshot.data.sensorType
                                        .toString(),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    FutureBuilder(
                        future:
                        databaseHelper2.getdataDeviceByID(snapshot.data.id),
                        builder: (context, snapshot2) {
                          if (snapshot2.hasError) {
                            print(snapshot2.error);
                            Text(
                              "",
                              style: TextStyle(
                                backgroundColor: Colors.transparent,
                              ),
                            );
                          }
                          if (snapshot2.hasData) {
                            return Column(
                              children: [
                                ChartLineClass(data: snapshot2.data, type: type),
                                Container(
                                  height: 90,
                                  child: Card(
                                    semanticContainer: true,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    elevation: 0,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 60,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.battery_charging_full,
                                              color: Colors.amberAccent,
                                              size: 30,
                                            ),
                                            radius: 28,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 20, 0),
                                          child: Text(
                                            snapshot2.data[
                                            snapshot2.data.length -
                                                1]["batterie"]
                                                .round()
                                                .toString() +
                                                "%",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 60,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.signal_cellular_4_bar,
                                              color: Colors.redAccent,
                                              size: 30,
                                            ),
                                            radius: 28,
                                          ),
                                        ),
                                        Text(
                                          "50%",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ],
                ),
              ),
            );
            // print("helloo"+snapshot.data.id);

          }
          return Container();
        });
  }
}
