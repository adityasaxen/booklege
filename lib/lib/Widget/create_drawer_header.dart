import 'package:flutter/material.dart';

Widget createDrawerHeader() {
  return const DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(color: Colors.blue),
      child: Stack(children: <Widget>[
        Positioned(
            bottom: 12.0,
            left: 16.0,
            child: Text("",
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.limeAccent,
                    fontWeight: FontWeight.w500))),
      ]));
}
