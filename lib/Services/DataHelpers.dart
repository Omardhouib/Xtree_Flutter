import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebar_animation/Models/Location.dart';
import 'package:sidebar_animation/Models/LocationHome.dart';
import 'package:sidebar_animation/Models/Locationdetails.dart';
import 'package:sidebar_animation/Models/Sensor.dart';
import 'package:sidebar_animation/Models/Weather.dart';

class DatabaseHelper2 {

//  String serverUrl = "http://51.210.182.172:3003/api";
  static String serverUrl = "http://192.168.1.113:3000/api";
//  String serverUrl = "http://192.168.56.247:3000/api";



  var status = false;

  var token;

  loginData(String email, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonResponse;

    String myUrl = "$serverUrl/users/login";
    var  response = await http.post(myUrl,
        body: {
          "email": "$email",
          "password": "$password"
        });

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        sharedPreferences.setString("token", jsonResponse['token']);
      }
    }
    else {
      print(response.body);
    }

    log('email : $email');
    log('password : $password');

//    status = response.body.contains('error');
    var data = json.decode(response.body);

    log('Data : $data');

    if (status) {
      print('data : ${data["error"]}');
    } else {
      print('data : ${data["token"]}');
      _save(data["token"]);
    }
  }

  registerData(String FirstName ,String LastName , String email, String password) async{

    String myUrl = "$serverUrl/users/register";
    final response = await  http.post(myUrl,
        headers: {
          'Accept':'application/json'
        },
        body: {
          "FirstName": "$FirstName",
          "LastName": "$LastName",
          "email": "$email",
          "password" : "$password",
          "enabled" : 1
        }
    ) ;
    status = response.body.contains('error');


//    print(' response.body 9bal if' + json.decode(response.body).toString());
    print(' Status : ' + response.statusCode.toString());

//    print(' Status2 : ' + status.toString());

    var data = json.decode(response.body);

    if(status){
//      print('data : ${data["error"]}');

      await Fluttertoast.showToast(
          msg: "there is somethings wrang :[ , try again . ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 10.0
      );

      print('data : ${data["error"]}');

    }
    else{
      print(' else status' + json.decode(response.body).toString());
      print(data['message']);

      if (data['message']=="Email Already Exists"){
        await Fluttertoast.showToast(
            msg: "Email or Username Already Exists , try again . ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 10.0
        );
      }

      else{
        await Fluttertoast.showToast(
            msg: "  Registration successfully completed :D  . ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 10.0
        );
      }


//      print('data : ${data["token"]}');
//      _save(data["token"]);

    }

  }

  Future<List<Location>> AllLocationByUser() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/location/getlocation?token=" + value;
    http.Response response = await http.get(
      myUrl,
      headers: {
        'Accept': 'application/json',
        //'Authorization': 'token $value'
      },
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      List<dynamic> body = jsonDecode(response.body);
      List<Location> locations = body.map((dynamic item) => Location.fromJson(item)).toList();
    //  await Future.delayed(Duration(milliseconds: 1200));
      return locations;
    } else {
      throw "Can't get orders";
    }
  }

  Future<List> AllDeviceByUser1() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/sensors/getSensors?token=" + value;
    http.Response response = await http.get(
        myUrl,
        headers: {
          'Accept': 'application/json',
          //'Authorization': 'token $value'
        },
    );

    return json.decode(response.body);
  }

  /*Future<List<Sensor>> AllElectoByUser() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/sensors/getElectroSensors?token=" + value;
    http.Response response = await http.get(
      myUrl,
      headers: {
        'Accept': 'application/json',
        //'Authorization': 'token $value'
      },
    );
    await Future.delayed(Duration(milliseconds: 2100));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      List<dynamic> body = jsonDecode(response.body);
      List<Sensor> sens = body.map((dynamic item) => Sensor.fromJson(item)).toList();
      //  await Future.delayed(Duration(milliseconds: 1200));
      return sens;
    } else {
      throw "Can't get orders";
    }
  }*/

  Future<Location> Lastlocation() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/location/getlastlocation?token=" + value;
    http.Response response = await http.get(
      myUrl,
      headers: {
        'Accept': 'application/json',
        //'Authorization': 'token $value'
      },
    );
    if (response.statusCode == 200) {
      await Future.delayed(Duration(milliseconds: 800));
      // If the server did return a 200 OK response,
      return Location.fromJson(json.decode(response.body));
    } else {
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
  //final AsyncMemoizer _memoizer = AsyncMemoizer();

  Future<LocationHome> getHomedetails() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/sensors/getElectroSensors?token=" + value;
    http.Response response = await http.get(
      myUrl,
      headers: {
        'Accept': 'application/json',
        //'Authorization': 'token $value'
      },
    );
    if (response.statusCode == 200) {
   //   await Future.delayed(Duration(milliseconds: 900));
      return LocationHome.fromJson(json.decode(response.body));
    } else {
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<Locationdetails> getLocationsdetailsByid(String ID) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/sensors/getLocationsdetailsByid/$ID?token=" + value;
    http.Response response = await http.get(
      myUrl,
      headers: {
        'Accept': 'application/json',
        //'Authorization': 'token $value'
      },
    );
    if (response.statusCode == 200) {
      //   await Future.delayed(Duration(milliseconds: 900));
      return Locationdetails.fromJson(json.decode(response.body));
    } else {
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }


  Future<Location> getLocationByid(String ID) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/location/getLocationByid/$ID?token=" + value;
    http.Response response = await http.get(myUrl,
        headers: {
          'Accept': 'application/json',
        });

    if (response.statusCode == 200) {
      await Future.delayed(Duration(milliseconds: 800));

      // If the server did return a 200 OK response,
      return Location.fromJson(json.decode(response.body));
    } else {
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<List> Getweather(String ID) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/dashboard/getweather/$ID?token=" + value;
    http.Response response = await http.get(myUrl,
        headers: {
          'Accept': 'application/json',
        });
   /* print('Response status : ${response.statusCode}');
    print('Response body : ${response.body}');*/
    //print("result"+json.decode(response.body).toString());
    return json.decode(response.body);

  }
  Future<Weather> GetUV(String ID) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/dashboard/getUltraV/$ID?token=" + value;
    http.Response response = await http.get(myUrl,
        headers: {
          'Accept': 'application/json',
        });
    await Future.delayed(Duration(milliseconds: 1));
    if (response.statusCode == 200) {
      await Future.delayed(Duration(milliseconds: 800));

      // If the server did return a 200 OK response,
      return Weather.fromJson(json.decode(response.body));
    } else {
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }



  Future<int> NumberofDeviceByUser() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    await Future.delayed(Duration(milliseconds: 1000));
    String myUrl = "$serverUrl/sensors/getnumberSensors?token=" + value;
    http.Response response = await http.get(
      myUrl,
      headers: {
        'Accept': 'application/json',
        //'Authorization': 'token $value'
      },
    );

    return json.decode(response.body);
  }


  Future<int> NumberofLocationByUser() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    await Future.delayed(Duration(milliseconds: 1500));
    String myUrl = "$serverUrl/sensors/getnumberLocations?token=" + value;
    http.Response response = await http.get(
      myUrl,
      headers: {
        'Accept': 'application/json',
        //'Authorization': 'token $value'
      },
    );
    return json.decode(response.body);
  }

  Future<List> getdataDeviceByID(String ID) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/sensors/getDeviceByiddata/$ID?token=" + value;
    http.Response response = await http.get(myUrl,
        headers: {
          'Accept': 'application/json',
        });
    return json.decode(response.body);
  }

  Future<Sensor> getDeviceById(String ID) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/sensors/getDeviceByid/$ID?token=" + value;
    http.Response response = await http.get(myUrl,
        headers: {
          'Accept': 'application/json',
        });
    if (response.statusCode == 200) {
      await Future.delayed(Duration(milliseconds: 800));

      // If the server did return a 200 OK response,
      return Sensor.fromJson(json.decode(response.body));
    } else {
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<Sensor> getAllDeviceById(String ID) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/sensors/getAllDevById/$ID?token=" + value;
    http.Response response = await http.get(myUrl,
        headers: {
          'Accept': 'application/json',
        });
    if (response.statusCode == 200) {
      await Future.delayed(Duration(milliseconds: 800));

      // If the server did return a 200 OK response,
      return Sensor.fromJson(json.decode(response.body));
    } else {
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<Sensor> getSolDeviceById(String ID) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/sensors/getSolDeviceByid/$ID?token=" + value;
    http.Response response = await http.get(myUrl,
        headers: {
          'Accept': 'application/json',
        });
    if (response.statusCode == 200) {
      await Future.delayed(Duration(milliseconds: 800));

      // If the server did return a 200 OK response,
      return Sensor.fromJson(json.decode(response.body));
    } else {
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<Sensor> getDevById(String ID) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/sensors/getDevByid/$ID?token=" + value;
    http.Response response = await http.get(myUrl,
        headers: {
          'Accept': 'application/json',
        });
    if (response.statusCode == 200) {
      await Future.delayed(Duration(milliseconds: 800));

      // If the server did return a 200 OK response,
      return Sensor.fromJson(json.decode(response.body));
    } else {
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<List> getDataOfDeviceByID(String ID) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/Devices/dataof/$ID";
    http.Response response = await http.get(myUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'token $value'
        });
    return json.decode(response.body);
  }

  /*
  Future<LocationsAndDataOfDevice> getYourDevices(String ID) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key ) ?? 0;

    String googleLocationsURL = "$serverUrl/Devices/$ID";
    final response = await http.get(googleLocationsURL ,
        headers: {
          'Accept':'application/json',
          'Authorization' : 'token $value'
        });
    if (response.statusCode == 200) {
      return LocationsAndDataOfDevice.fromJson(json.decode(response.body));
    } else {
      throw HttpException(
          'Unexpected status code ${response.statusCode}:'
              ' ${response.reasonPhrase}',
          uri: Uri.parse(googleLocationsURL));
    }
  }

   */

  Future<List> getDeviceByREF(String ref) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/Devices/GetByRef/$ref";
    http.Response response = await http.get(myUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'token $value'
        });
    return json.decode(response.body);
  }




  void AddDevice(String title, String ref, String category) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/Devices/AddDevice";
    await http.post(myUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'token $value'
        },
        body: {
          "title": "$title",
          "ref": "$ref",
          "category": "$category",
        }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

  void UpdateDevice(String title, String ref,String category,  String ID) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/Devices/UpdateDevice/$ID";
    await http.put(myUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'token $value'
        },
        body: {
          "title": "$title",
          "ref": "$ref",
          "category": "$category",
        }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }




  void RemoveDevice(String ID) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/Devices/RemoveDevice/$ID";
    await http.delete(myUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'token $value'
        }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

  Future<List> getFavorit() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl = "$serverUrl/Devices/GetFavorit";
    http.Response response = await http.post(myUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'token $value'
        });
    return json.decode(response.body);
  }

  void UpdateFavorit(String ID, bool favorit) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/Devices/UpdateFavoritDevice/$ID";
    await http.put(myUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'token $value'
        },
        body: {
          "favorit": "$favorit",
        }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

  void  Updatetraking(String ID, bool traking) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/Devices/traking/$ID";
    await http.put(myUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'token $value'
        },
        body: {
          "traking": "$traking",
        }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }
/*
  Future<User> Profile() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/users/Profile";
    http.Response response = await http.post(myUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'token $value'
        });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      return User.fromJson(json.decode(response.body));
    } else {
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

 */

  void UpdateUser( String username,String email,int numTel) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/users/UpdateUser";
    await http.put(myUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'token $value'
        },
        body: {
          "username": "$username",
          "email": "$email",
          "numTel": "$numTel",

        }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

  void UpdateUserPassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/users/UpdatePassword";
    await http.put(myUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'token $value'
        },
        body: {
          "password": "$password",
        }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

  Future<List> count_devices_By_User() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/device/Get_count_devices_By_User";
    http.Response response = await http.get(myUrl,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'token $value'
        });
    return json.decode(response.body);
  }



  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
  }


  read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    print('read : $value');
  }

}


