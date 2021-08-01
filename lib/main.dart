import 'package:api_consumer_location_tracker/screens/google_map_screen.dart';
import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      "/": (context) => HomeScreen(),
      "/google_map_screen": (context) => GoogleMapScreen(),
    },
  ));
}
