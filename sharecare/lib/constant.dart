import 'dart:math';

import 'package:flutter/material.dart';
String ipv4 = "192.168.1.2";
String serverURL = "http://"+ipv4+"/shareandcare/android/";

RandomString(int length) {
  var rand = new Random();
  var codeUnits = new List.generate(length, (index) {
    return rand.nextInt(33) + 89;
  });
  return new String.fromCharCodes(codeUnits);
}

constantAppBar(String text) {
  return AppBar(
    title: Text(
      text,
      style: TextStyle(color: Colors.white),
    ),
  );
}
