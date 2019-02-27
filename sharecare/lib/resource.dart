import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sharecare/Model/resource.dart';
import 'constant.dart';
import 'package:sharecare/detail.dart';
import 'package:sharecare/newresource.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Model/resource.dart';

class Resource extends StatefulWidget {
  _ResourceState createState() => _ResourceState();
}

class _ResourceState extends State<Resource> {
  String _userId;

  final GlobalKey<ScaffoldState> _resourceScaffold =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _serverData();
  }

  _serverData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString("userId");

    print("Resource: GetDataFromServer userID" + _userId);
    var response = await http.post(Uri.encodeFull(serverURL), headers: {
      "Accept": "application/json"
    }, body: {
      "worktodone": "MyResources",
      "userId": _userId,
    });
    setState(() {
      if (response.body.toLowerCase().compareTo("nodata") == 0) {
        print("Server LoadResource NoData");
      } else {
        print("ServerLoadResource Data Found");

        myResourceList.clear();
        List data = json.decode(response.body);
        data.forEach((res) => myResourceList.add(new ResourceModel(
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
    });
  }

  _body() {
    if (myResourceList.length > 0) {
      return Scaffold(
        key: _resourceScaffold,
        body: _displayRow(),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "No Data Found",
            style: TextStyle(
                color: Colors.red, fontSize: 26.0, fontWeight: FontWeight.bold),
          )
        ],
      );
    }
  }

  _displayRow() {
    return ListView.separated(
      itemCount: myResourceList.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            ListTile(
              leading: Image(
                image: NetworkImage(myResourceList[index]
                    .imageUrl
                    .replaceFirst("localhost", ipv4)),
                fit: BoxFit.fill,
                height: 60.0,
                width: 80.0,
              ),
              title: Text(
                myResourceList[index].name,
                style: TextStyle(
                  fontSize: 18.0,
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
                        myResourceList[index].status,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        myResourceList[index].price.toString(),
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
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.details),
                    onPressed: () {
                      _detailResource(myResourceList[index]);
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _editResource(myResourceList[index]);
                    },
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteResource(myResourceList[index]);
                    },
                    color: Colors.red,
                  ),
                ),
              ],
            )
          ],
        );
      },
      separatorBuilder: (context, index) => Divider(
            height: 1.0,
            color: Colors.grey,
          ),
    );
  }

  _detailResource(ResourceModel resource) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ResourceDetail("myresource", resource.id.toString())),
    );
  }

  _editResource(ResourceModel resource) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              NewResource("myresource", resource.id.toString())),
    );
  }

  _deleteResource(ResourceModel resource) {
    AlertDialog dialog = new AlertDialog(
      contentPadding: EdgeInsets.all(0.0),
      title: Title(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Icon(Icons.warning),
              flex: 1,
            ),
            Expanded(
              child: Text(
                "Delete Resource",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              flex: 4,
            )
          ],
        ),
        color: Colors.grey,
      ),
      content: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          "Delete " + resource.name,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("No", style: TextStyle(color: Colors.red)),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
            _serverDeleteResource(resource);
          },
          child: Text("Yes", style: TextStyle(color: Colors.red)),
        ),
      ],
    );

    showDialog(context: context, builder: (_) => dialog);
  }

  _serverDeleteResource(ResourceModel resource) async {
    print("_serverDeleteResource");
    var response = await http.post(
      Uri.encodeFull(serverURL),
      body: {"worktodone": "DeleteResource", "resourceId": resource.id.toString()},
    );
    print("_serverDeleteResource Response " + response.body);
    setState(() {
      if (response.body == "success") {
        _serverData();
        _resourceScaffold.currentState.showSnackBar(new SnackBar(
          duration: Duration(seconds: 2),
          content: new Text(
            "Recource Deleted",
            style: TextStyle(color: Colors.white),
          ),
        ));
      } else {
        print("_serverDeleteResource No Data Found ");
      }
    });
  }
}
