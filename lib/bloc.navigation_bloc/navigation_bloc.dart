import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sidebar_animation/pages/AccountSettings.dart';
import 'package:sidebar_animation/pages/Location/LocationDetails.dart';
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
  MyProfileClickedEvent
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  @override
  NavigationStates get initialState => MyHomePage();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageClickedEvent:
        yield MyHomePage();
        break;
      case NavigationEvents.MyAccountClickedEvent:
        yield Devices();
        break;
      case NavigationEvents.MyOrdersClickedEvent:
        yield Locations();
        break;
      case NavigationEvents.MyProfileClickedEvent:
        yield AccountSettings();
        break;

    }
  }
}
