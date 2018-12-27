import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sharecare/Model/resource.dart';

String ipv4 = "192.168.1.2";
String serverURL = "http://" + ipv4 + "/shareandcare/android/";

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

ServerLoadResources() async {
  var response = await http.post(Uri.encodeFull(serverURL), headers: {
    "Accept": "application/json"
  }, body: {
    "worktodone": "Resources",
  });
  if (response.body.toLowerCase().compareTo("nodata") == 0) {
  } else {
    resourceListAll.clear();
    List data = json.decode(response.body);
    data.forEach((res) => resourceListAll.add(new ResourceModel(
        int.parse(res["id"]),
        res["name"],
        res["description"],
        res["status"],
        res["saleType"],
        res["imageUrl"],
        res["addedDate"],
        int.parse(res["price"]),
        res["cashOnDelivery"] == "0",
        res["facebook"] == "0",
        res["none"] == "0",
        res["easypaisa"] == "0",
        res["tcs"] == "0",
        res["cargo"] == "0",
        res["banktransfer"] == "0",
        int.parse(res["feedLike"]),
        int.parse(res["feedDislike"]),
        int.parse(res["userId"]),
        int.parse(res["requestUserId"]))));
  }
}
