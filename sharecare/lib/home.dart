import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sharecare/constant.dart';
import 'package:sharecare/order.dart';
import 'package:sharecare/resource.dart';
import 'package:sharecare/setting.dart';
import 'homeLayout/screen.dart';
import 'package:sharecare/Model/resource.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _bottomCurrentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(vsync: this, initialIndex: 0, length: 4);
    _serverData();
  }

  _serverData() async {
    var response = await http.post(Uri.encodeFull(serverURL), headers: {
      "Accept": "application/json"
    }, body: {
      "worktodone": "Resources",
    });
    if (response.body.toLowerCase().compareTo("nodata") == 0) {
    } else {
      setState(() {
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
            res["cashOnDelivery"]=="0",
            res["facebook"]=="0",
            res["none"]=="0",
            res["easypaisa"]=="0",
            res["tcs"]=="0",
            res["cargo"]=="0",
            res["banktransfer"]=="0",
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
      appBar: _appBar(),
      bottomNavigationBar: _bottomNavigationBar(),
      body: _bodySelection(),
      floatingActionButton: _floatButtonNewResource(),
    );
  }

  _floatButtonNewResource() {
    if (_bottomCurrentIndex == 0) {
      return FloatingActionButton(
        onPressed: () {
          _floatingButtonPressed();
        },
        child: Icon(Icons.add),
      );
    }
    return null;
  }

  _floatingButtonPressed() {
    Navigator.of(context).pushNamed('/newresource');
  }

  _bodySelection() {
    print(_bottomCurrentIndex);
    if (_bottomCurrentIndex == 0) {
      return _homeLayout();
    } else if (_bottomCurrentIndex == 1) {
      return Resource();
    } else if (_bottomCurrentIndex == 2) {
      return Order();
    } else if (_bottomCurrentIndex == 3) {
      return Setting();
    }
  }

  Future<void> _conformLogout() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Conform Logout?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are You Sure to Logout?.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                _removeSharedPref();
                Navigator.of(context).pushReplacementNamed('/account');
              },
            ),
          ],
        );
      },
    );
  }

  _removeSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  _homeLayout() {
    //thing to remember the _tabController.index didnt get change we need to perform setState so we have
    //done the task directly by passing the index value else can create method change _tabController.index and then call Screen
    return TabBarView(
      controller: _tabController,
      children: <Widget>[
        Screen(0),
        Screen(1),
        Screen(2),
        Screen(3),
      ],
    );
  }

  _appBar() {
    return AppBar(
      title: Text(
        "Share & Care",
        style: TextStyle(color: Colors.white),
      ),
      elevation: 0.7,
      bottom: _bottomTabs(),
      actions: _appBarActions(),
    );
  }

  _appBarActions() {
    if (_bottomCurrentIndex == 0) {
      return <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
      ];
    }
    return null;
  }

  _bottomTabs() {
    //home screen then display tabbar
    if (_bottomCurrentIndex == 0) {
      return TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        tabs: <Widget>[
          Tab(
            text: "SELL",
          ),
          Tab(
            text: "BID",
          ),
          Tab(
            text: "RENT",
          ),
          Tab(
            text: "DONATE",
          ),
        ],
      );
    }
    //else return null
    return null;
  }

  _bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _bottomCurrentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: _bottomNavigationBarTab,
      fixedColor: Colors.red,
      items: [
        BottomNavigationBarItem(title: Text("Home"), icon: Icon(Icons.home)),
        BottomNavigationBarItem(
            title: Text("Resources"), icon: Icon(Icons.apps)),
        BottomNavigationBarItem(
            title: Text("Order"), icon: Icon(Icons.view_list)),
        BottomNavigationBarItem(
            title: Text("Setting"), icon: Icon(Icons.settings)),
        BottomNavigationBarItem(
            title: Text("Logout"), icon: Icon(Icons.power_settings_new)),
      ],
    );
  }

  _bottomNavigationBarTab(int index) {
    setState(() {
      if (index != 4) {
        _bottomCurrentIndex = index;
      } else if (index == 4) {
        _conformLogout();
      }
    });
  }
}
