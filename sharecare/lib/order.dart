import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sharecare/Model/resource.dart';
import 'package:http/http.dart' as http;
import 'constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Order extends StatefulWidget {
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  List<ResourceModel> resourceList;
  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    resourceList.clear();
    super.dispose();
  }

  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("userId");
    var response = await http.post(
      serverURL,
      headers: {},
      body: {"worktodone": "Orders", "userId": userId},
    );
    print("_getData Response: " + response.body);
    if (response.body == "nodata") {
    } else {
      setState(() {
        resourceList = List();
        List data = json.decode(response.body);
        
        data.forEach((res) => 

        resourceList.add(new ResourceModel(
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

        
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  _body() {
    if (resourceList != null) {
      return ListView.separated(
        itemCount: resourceList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Image(
                  image: NetworkImage(resourceList[index].imageUrl.replaceFirst("localhost", ipv4)),
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width,
                  height: 200.0,
                ),
                ListTile(
                  title: Text(
                    resourceList[index].name,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          height: 5.0,
                        ),
                        Expanded(
                          child: Text(
                            resourceList[index].status,
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            resourceList[index].price.toString(),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(
              height: 1.0,
              color: Colors.grey,
            ),
      );
    } else {
      return Text("Getting Data");
    }
  }
}
