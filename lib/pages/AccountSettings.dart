import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sidebar_animation/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:sidebar_animation/constants.dart';

class AccountSettings extends StatefulWidget with NavigationStates {


  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(),
    );
  }
}
