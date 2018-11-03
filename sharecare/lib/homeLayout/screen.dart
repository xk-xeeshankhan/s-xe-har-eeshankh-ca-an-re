import 'package:flutter/material.dart';
import 'package:sharecare/Model/resource.dart';

class Screen extends StatefulWidget {
  final int index;
  Screen(this.index);

  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  List<ResourceModel> resourceList;
  int _index;
  @override
  void initState() {
    _index = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _checkScreen();
  }

  _checkScreen() {
    if (_index == 0) {
      //Sell
      resourceList = List();
      resourceListAll.forEach((item) {
        if (item.status == "sell") resourceList.add(item);
      });
      return _displayRow();
    } else if (_index == 1) {
      //Bid
      resourceList = List();
      resourceListAll.forEach((item) {
        if (item.status == "bid") resourceList.add(item);
      });
      return _displayRow();
    } else if (_index == 2) {
      //rent
      resourceList = List();
      resourceListAll.forEach((item) {
        if (item.status == "rent") resourceList.add(item);
      });
      return _displayRow();
    } else if (_index == 3) {
      //Donate
      resourceList = List();
      resourceListAll.forEach((item) {
        if (item.status == "donate") resourceList.add(item);
      });
      return _displayRow();
    }
  }

  _displayRow() {
    return ListView.separated(
      itemCount: resourceList.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            ListTile(
              leading: Image(
                image: AssetImage("assets/images/bg.jpg"),
                fit: BoxFit.fill,
                height: 60.0,
                width: 80.0,
              ),
              title: Text(
                resourceList[index].title,
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
                        resourceList[index].status,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    _displayPrice(index),
                  ],
                ),
              ),
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

  _displayPrice(index) {
    String price = _index==3?"Free":resourceList[index].price.toString();
    return Expanded(
      child: Text(
        price,
        textAlign: TextAlign.right,
        style: TextStyle(
            fontSize: 16.0, color: Colors.green, fontWeight: FontWeight.bold),
      ),
    );
  }
}
