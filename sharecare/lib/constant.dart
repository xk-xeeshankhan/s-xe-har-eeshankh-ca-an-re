import 'dart:math';

import 'package:flutter/material.dart';
String ipv4 = "192.168.1.6";
String serverURL = "http://"+ipv4+"/shareandcare/android/";

RandomString(int length) {
  var rand = new Random();
  var codeUnits = new List.generate(length, (index) {
    return rand.nextInt(33) + 89;
  });
  return new String.fromCharCodes(codeUnits);
}

constantAppBar() {
  return AppBar(
    title: Text(
      "New Resource",
      style: TextStyle(color: Colors.white),
    ),
  );
}
