
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
import 'package:sidebar_animation/Services/DataHelpers.dart';
import 'package:sidebar_animation/classes/ChartHistory.dart';
import 'package:sidebar_animation/classes/MultiSelectFormField.dart';
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
      if("hello" == "hi"){
        return Container();
      }
      else Fluttertoast.showToast(
          msg: "AI mode activated with success!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 10,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 10.0);
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
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 15, 0, 25),
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
                ]),
            FutureBuilder(
                future: databaseHelper2.Getweather(widget.location.id),
                builder: (context, snapshot2) {
                  if (snapshot2.hasError) {
                    print(snapshot2.error);
                    Container();
                  }
                  return snapshot2.hasData
                      ? Itemclass(list: snapshot2.data)
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
            ItemListchart(sensor: widget.sens)
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

  Widget Itemclass({List list}) {
    var hour = DateTime.now().hour;
    DateTime date = DateTime.now();
    String dateFormat = DateFormat('EEEE').format(date);
    //  final hour formattedDate = DateFormat.j().format(now);
    dynamic currentTime = DateFormat.j().format(DateTime.now());
    return SizedBox(
      height: 290.0,
      child: ListView.builder(
          itemCount: 6,
          scrollDirection: Axis.horizontal,
          itemExtent: 200.0,
          // ignore: missing_return
          itemBuilder: (context, i) {
            int date = (list[i]["dt"]);
            int zero = 100;
            DateTime finalday = DateTime.fromMillisecondsSinceEpoch(
                int.parse(("$date" + "$zero")))
                .toUtc();
            String dateFormat = DateFormat('EEEE').format(finalday);
            var item = list[i];
            if ((hour < 17) && (hour >= 6)) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Container(
                  /* decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                       image: DecorationImage(
                           image: NetworkImage(
                               "https://www.pngarts.com/files/5/Lines-Transparent-Background-PNG.png"),
                           fit: BoxFit.cover),
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Color(0xff152238),
                            Color(0xff152238),
                            Color(0xff152238),
                          ])),*/
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                          image: NetworkImage(
                              "https://images.unsplash.com/photo-1559628376-f3fe5f782a2e?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=1000&q=80"),
                          fit: BoxFit.cover)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(95, 10, 0, 0),
                        child: Text(
                          list[i]["temp"]["morn"].round().toString() + "°C",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(95, 0, 0, 0),
                        child: Text(
                          dateFormat,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      if (list[i]["pop"] > 0.1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/rain.png'),
                          ),
                        ),
                      if (list[i]["clouds"] > 0 && list[i]["pop"] < 0.1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/overcast.png'),
                          ),
                        ),
                      if (list[i]["pop"] < 0.1 && list[i]["clouds"] < 1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/day_clear.png'),
                          ),
                        ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 4, 0),
                            child: Text(
                              list[i]["temp"]["min"].round().toString() + "°C",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              "/",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              list[i]["temp"]["max"].round().toString() + "°C",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                            child: Text(
                              "Humidity: ",
                              style:
                              TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: Text(
                              list[i]["humidity"].toString() + "%",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                            child: Text(
                              "Precipitation: ",
                              style:
                              TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              list[i]["pop"].toString() + "mm",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                            child: Text(
                              "Uv: ",
                              style:
                              TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              list[i]["uvi"].toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else if ((hour < 20) && (hour >= 17)) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Container(
                  /* decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                       image: DecorationImage(
                           image: NetworkImage(
                               "https://www.pngarts.com/files/5/Lines-Transparent-Background-PNG.png"),
                           fit: BoxFit.cover),
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Color(0xff152238),
                            Color(0xff152238),
                            Color(0xff152238),
                          ])),*/
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                          image: NetworkImage(
                              "https://image.freepik.com/free-photo/oyster-farm-sea-beautiful-sky-sunset-background_1150-10229.jpg"),
                          fit: BoxFit.cover)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(95, 10, 0, 0),
                        child: Text(
                          list[i]["temp"]["eve"].round().toString() + "°C",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(95, 0, 0, 0),
                        child: Text(
                          dateFormat,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      if (list[i]["pop"] > 0.1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/rain.png'),
                          ),
                        ),
                      if (list[i]["clouds"] > 0 && list[i]["pop"] < 0.1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/overcast.png'),
                          ),
                        ),
                      if (list[i]["pop"] < 0.1 && list[i]["clouds"] < 1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/day_clear.png'),
                          ),
                        ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 4, 0),
                            child: Text(
                              list[i]["temp"]["min"].round().toString() + "°C",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              "/",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              list[i]["temp"]["max"].round().toString() + "°C",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                            child: Text(
                              "Humidity: ",
                              style:
                              TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: Text(
                              list[i]["humidity"].toString() + "%",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                            child: Text(
                              "Precipitation: ",
                              style:
                              TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              list[i]["pop"].toString() + "mm",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                            child: Text(
                              "Uv: ",
                              style:
                              TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              list[i]["uvi"].toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Container(
                  /* decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                       image: DecorationImage(
                           image: NetworkImage(
                               "https://www.pngarts.com/files/5/Lines-Transparent-Background-PNG.png"),
                           fit: BoxFit.cover),
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Color(0xff152238),
                            Color(0xff152238),
                            Color(0xff152238),
                          ])),*/
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                          image: NetworkImage(
                              "https://image.freepik.com/free-vector/milky-way-night-star-sky-stars-dark-background_172933-70.jpg"),
                          fit: BoxFit.cover)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(95, 10, 0, 0),
                        child: Text(
                          list[i]["temp"]["night"].round().toString() + "°C",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(95, 0, 0, 0),
                        child: Text(
                          dateFormat,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      if (list[i]["pop"] > 0.1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/rain.png'),
                          ),
                        ),
                      if (list[i]["clouds"] > 0 && list[i]["pop"] < 0.1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/overcast.png'),
                          ),
                        ),
                      if (list[i]["pop"] < 0.1 && list[i]["clouds"] < 1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: new Image.network(
                                'https://www.dovora.com/resources/weather-icons/showcase/modern_showcase/day_clear.png'),
                          ),
                        ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 4, 0),
                            child: Text(
                              list[i]["temp"]["min"].round().toString() + "°C",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              "/",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              list[i]["temp"]["max"].round().toString() + "°C",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                            child: Text(
                              "Humidity: ",
                              style:
                              TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: Text(
                              list[i]["humidity"].toString() + "%",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                            child: Text(
                              "Precipitation: ",
                              style:
                              TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              list[i]["pop"].toString() + "mm",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                            child: Text(
                              "Uv: ",
                              style:
                              TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              list[i]["uvi"].toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}

class ItemListchart extends StatefulWidget {
  Sensor sensor;
  ItemListchart({this.sensor});

  @override
  _ItemListchartState createState() => _ItemListchartState();
}

class _ItemListchartState extends State<ItemListchart> {
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
                              padding: const EdgeInsets.fromLTRB(0, 22, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data.name.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    snapshot.data.description.toString(),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
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
                                chart(snapshot2.data, type),
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

Widget chart(List data, String type) {
  List<dynamic> adjustData = [];
  if (data.isNotEmpty) {
    if (type == "CarteDeSol") {
      print(' data is not empty');
      data = data.sublist(data.length - 10, data.length);
      //print(data.length);

      data.forEach((element) {
        //  print(element.toString());
        var hour = DateTime.fromMillisecondsSinceEpoch(element['time'])
            .hour
            .toString();
        var minute = DateTime.fromMillisecondsSinceEpoch(element['time'])
            .minute
            .toString();
        var hum1 = element["humdity1"];
        var hum2 = element["humdity2"];
        var hum3 = element["humdity3"];
        var tot = (hum1 + hum2 + hum3) / 3;
        String time = hour + ":" + minute;
        // print(time);
        adjustData.add({"type": "humdity1", "index": time, "value": hum1});
        adjustData.add({"type": "humdity2", "index": time, "value": hum2});
        adjustData.add({"type": "humdity3", "index": time, "value": hum3});
        adjustData.add({"type": "humdity4", "index": time, "value": tot});
        adjustData.add({
          "type": "temperatureSol",
          "index": time,
          "value": element["temperatureSol"]
        });
      });
      return Column(
        children: [
          Row(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                    child: Container(
                      width: 40,
                      height: 5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                    child: Text(
                      "Humidity 1",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.grey),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Container(
                      width: 40,
                      height: 5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        color: Colors.green,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                    child: Text(
                      "Humidity 2",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.grey),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Container(
                      width: 40,
                      height: 5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        color: Colors.amber,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                    child: Text(
                      "Humidity 3",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 5, 0, 20),
                    child: Container(
                      width: 40,
                      height: 5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 10, 20),
                    child: Text(
                      "Average humidity",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.grey),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 20),
                    child: Container(
                      width: 40,
                      height: 5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 10, 20),
                    child: Text(
                      "Temperature",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            width: 650,
            height: 300,
            child: graphic.Chart(
              data: adjustData,
              margin: EdgeInsets.all(10),
              scales: {
                'index': graphic.CatScale(
                  accessor: (map) => map['index'].toString(),
                  range: [0, 0.99],
                ),
                'type': graphic.CatScale(
                  accessor: (map) => map['type'] as String,
                ),
                'value': graphic.LinearScale(
                  accessor: (map) => map['value'] as num,
                  nice: true,
                  range: [0, 1],
                ),
              },
              geoms: [
                graphic.LineGeom(
                  position: graphic.PositionAttr(field: 'index*value'),
                  color: graphic.ColorAttr(field: 'type'),
                  size: graphic.SizeAttr(field: 'value'),
                  shape: graphic.ShapeAttr(
                      values: [graphic.BasicLineShape(smooth: true)]),
                )
              ],
              axes: {
                'index': graphic.Defaults.horizontalAxis,
                'value': graphic.Defaults.verticalAxis,
              },
            ),
          ),
        ],
      );
    } else
      print(' data is not empty');
    data = data.sublist(data.length - 10, data.length);
    //print(data.length);

    data.forEach((element) {
      var hour =
      DateTime.fromMillisecondsSinceEpoch(element['time']).hour.toString();
      var minute = DateTime.fromMillisecondsSinceEpoch(element['time'])
          .minute
          .toString();
      String time = hour + ":" + minute;
      // print("hello " + element.toString());
      adjustData.add(
          {"type": "temp", "index": time, "value": element["temperature"]});
      adjustData
          .add({"type": "hum", "index": time, "value": element["humidite"]});
    });
    return Column(
      children: [
        Row(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 0, 20),
                  child: Container(
                    width: 40,
                    height: 5,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      color: Colors.green,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 10, 20),
                  child: Text(
                    "Humidity",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.grey),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                  child: Container(
                    width: 40,
                    height: 5,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      color: Colors.blue,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 10, 20),
                  child: Text(
                    "Temperature",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.grey),
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          width: 650,
          height: 300,
          child: graphic.Chart(
            data: adjustData,
            margin: EdgeInsets.all(10),
            scales: {
              'index': graphic.CatScale(
                accessor: (map) => map['index'].toString(),
                range: [0, 0.99],
              ),
              'type': graphic.CatScale(
                accessor: (map) => map['type'] as String,
              ),
              'value': graphic.LinearScale(
                accessor: (map) => map['value'] as num,
                nice: true,
                range: [0, 1],
              ),
            },
            geoms: [
              graphic.LineGeom(
                position: graphic.PositionAttr(field: 'index*value'),
                color: graphic.ColorAttr(field: 'type'),
                size: graphic.SizeAttr(field: 'value'),
                shape: graphic.ShapeAttr(
                    values: [graphic.BasicLineShape(smooth: true)]),
              )
            ],
            axes: {
              'index': graphic.Defaults.horizontalAxis,
              'value': graphic.Defaults.verticalAxis,
            },
          ),
        ),
      ],
    );
  }
}