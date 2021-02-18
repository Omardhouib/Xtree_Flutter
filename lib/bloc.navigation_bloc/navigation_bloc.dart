import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sidebar_animation/pages/Device/HomeDevice.dart';
import 'package:sidebar_animation/pages/Location/HomeLocation.dart';
import 'package:sidebar_animation/pages/loginPage.dart';
import 'package:sidebar_animation/sidebar/sidebar.dart';
import '../pages/Device/Devices.dart';
import '../pages/Location/AllLocations.dart';
import '../pages/loginPage.dart';


import '../pages/homepage.dart';

enum NavigationEvents {
  HomePageClickedEvent,
  MyAccountClickedEvent,
  MyOrdersClickedEvent,
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  @override
  NavigationStates get initialState => HomePage();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageClickedEvent:
        yield HomePage();
        break;
      case NavigationEvents.MyAccountClickedEvent:
        yield HomeDevice();
        break;
      case NavigationEvents.MyOrdersClickedEvent:
        yield HomeLocation();
        break;
    }
  }
}
