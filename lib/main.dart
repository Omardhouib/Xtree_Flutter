import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebar_animation/pages/loginPage.dart';

import 'sidebar/sidebar_layout.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  print(token);

  runApp(MaterialApp(home: token == null ? LoginPage() : SideBarLayout()));
}

