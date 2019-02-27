import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sharecare/Model/bidingdetail.dart';
import 'package:sharecare/Model/rentdetail.dart';
import 'package:sharecare/Model/resource.dart';
import 'package:http/http.dart' as http;
import 'package:sharecare/Model/user.dart';
import 'constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResourceDetail extends StatefulWidget {
  //calledby => resource or myresource
  final String calledBy;
  final String id;
  ResourceDetail(this.calledBy, this.id);
  _ResourceDetailState createState() => _ResourceDetailState();
}

class _ResourceDetailState extends State<ResourceDetail> {
  String _calledBy;
  String _id;

  final GlobalKey<ScaffoldState> _deatilScaffold =
      new GlobalKey<ScaffoldState>();
  /*Biding  */
  int _bidSliderValue;
  double _bidMinValue;
  double _bidMaxValue;
  String _bidText;
  bool _beFirst = true;
  /*--Biding  */

  ResourceModel resourceDetail;
  @override
  void initState() {
    _calledBy = widget.calledBy;
    _id = widget.id;
    _getResourceData();
    super.initState();
  }

  _getResourceData() async {
    var response = await http.post(Uri.encodeFull(serverURL),
        headers: {"Accept": "application/json"},
        body: {"worktodone": "ResourcesDetail", "id": _id});
    print(response.body);
    if (response.body != "nodata") {
      List data = json.decode(response.body);
      setState(() {
        data.forEach((res) {
          print(res);
          resourceDetail = ResourceModel(
              int.parse(res["0"]),
              res["1"],
              res["description"],
              res["status"],
              res["saleType"],
              res["imageUrl"],
              res["addedDate"],
              int.parse(res["price"]),
              res["cashOnDelivery"] == "1",
              res["facebook"] == "1",
              res["none"] == "1",
              res["easypaisa"] == "1",
              res["tcs"] == "1",
              res["cargo"] == "1",
              res["banktransfer"] == "1",
              int.parse(res["feedLike"]),
              int.parse(res["feedDislike"]),
              int.parse(res["userId"]),
              int.parse(res["requestUserId"]));

          if (_calledBy == "resource") {
            resourceDetail.user = User(int.parse(res["userId"]), res["name"],
                res["email"], res["phonenumber"]);
          } else if (_calledBy == "myresource" &&
              resourceDetail.requestUserId != 0) {
            _getRequestedUserData();
          }
        });
        /*Bid */
        if (resourceDetail.saleType.toLowerCase().compareTo("bid") == 0) {
          _bidSliderValue = int.parse(resourceDetail.price.toString());
          _bidMinValue = double.parse((resourceDetail.price / 2).toString());
          _bidMaxValue = double.parse((resourceDetail.price * 2).toString());
          _bidText = "Price: " + _bidSliderValue.toString();
          _getBidingDetail();
        }

        if (_calledBy == "myresource" && resourceDetail.saleType == "Rent") {
          _getRentDetail();
        }
      });
    } else {
      //no data from server
    }
  }

  _getRequestedUserData() async {
    print("_getRequestedUserData Id" + resourceDetail.requestUserId.toString());
    var response = await http.post(Uri.encodeFull(serverURL), headers: {
      "Accept": "application/json"
    }, body: {
      "worktodone": "userData",
      "id": resourceDetail.requestUserId.toString()
    });
    print("_getRequestedUserData Response " + response.body);
    setState(() {
      if (response.body == "nodata") {
      } else {
        List data = json.decode(response.body);
        data.forEach((item) {
          resourceDetail.user = new User(resourceDetail.requestUserId,
              item["name"], item["email"], item["phonenumber"]);
        });
      }
    });
  }

  Future _getBidingDetail() async {
    print("GetBidingDetail");
    var response = await http.post(Uri.encodeFull(serverURL),
        headers: {"Accept": "application/json"},
        body: {"worktodone": "BidingDetail", "id": _id});
    print("GetBidingDetail Response: " + response.body);
    setState(() {
      if (response.body != "nodata") {
        _beFirst = false;
        List data = json.decode(response.body);
        resourceDetail.bidingDetailList = List();
        data.forEach((biding) {
          resourceDetail.bidingDetailList.add(BidingDetail(
              int.parse(biding["id"]),
              int.parse(biding["resourceId"]),
              int.parse(biding["bidPrice"]),
              new User(int.parse(biding["userId"]), biding["name"],
                  biding["email"], biding["phonenumber"])));
        });
      } else {
        _beFirst = true;
      }
    });
  }

  Future _getRentDetail() async {
    print("GetRentDetail");
    var response = await http.post(Uri.encodeFull(serverURL),
        headers: {"Accept": "application/json"},
        body: {"worktodone": "RentDetail", "id": _id});
    print("GetRentDetail Response " + response.body);
    setState(() {
      if (response.body != "nodata") {
        _beFirst = false;
        print("GetRentDetail Data Found ");
        List data = json.decode(response.body);
        resourceDetail.rentDetailList = new List();
        data.forEach((rent) {
          resourceDetail.rentDetailList.add(new RentDetail(
              int.parse(rent["id"]),
              int.parse(rent["resourceId"]),
              int.parse(rent["rentPrice"]),
              rent["rentedDate"],
              rent["returnDate"],
              new User(int.parse(rent["userId"]), rent["name"], rent["email"],
                  rent["phonenumber"])));
        });
      } else {
        print("GetRentDetail No Data Found ");
        _beFirst = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _deatilScaffold,
      appBar: constantAppBar("Resource Detail"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: _body(),
        ),
      ),
    );
  }

  _body() {
    if (resourceDetail != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              resourceDetail.name,
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Image(
            image: NetworkImage(
                resourceDetail.imageUrl.replaceFirst("localhost", ipv4)),
            width: MediaQuery.of(context).size.width,
            height: 200.0,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: Text(
              resourceDetail.saleType.toUpperCase(),
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Status",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    resourceDetail.status.replaceFirst(
                        resourceDetail.status.substring(0),
                        resourceDetail.status.substring(0).toUpperCase()),
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Description",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    resourceDetail.description,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Price",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    "PKR " + resourceDetail.price.toString().toUpperCase(),
                    style: TextStyle(fontSize: 16.0, color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 2.0,
          ),
          Divider(
            height: 2.0,
          ),
          _paymentMethod(),
          _deliveryMethod(),
          _userInfo(),
          _requestedUserInfo(),
          _bidPriceBar(),
          _detailActionButton(),
          _bidDetail(),
          _rentDetail(),
        ],
      );
    }
  }

  _userInfo() {
    if (_calledBy == "resource") {
      return Column(
        children: <Widget>[
          Divider(
            height: 2.0,
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "User Info".toUpperCase(),
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Icon(
                    Icons.person,
                    color: Colors.red,
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Text(
                    resourceDetail.user.name,
                  ),
                  flex: 6,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Icon(
                    Icons.email,
                    color: Colors.red,
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Text(
                    resourceDetail.user.emailaddress,
                  ),
                  flex: 6,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Icon(
                    Icons.phone,
                    color: Colors.red,
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Text(
                    resourceDetail.user.phonenumber,
                  ),
                  flex: 6,
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return SizedBox(
        width: 0.0,
        height: 0.0,
      );
    }
  }

  _requestedUserInfo() {
    if (resourceDetail.requestUserId != 0 &&
        _calledBy == "myresource" &&
        resourceDetail.user != null) {
      return Column(
        children: <Widget>[
          Divider(
            height: 2.0,
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Buyer Info".toUpperCase(),
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Icon(
                    Icons.person,
                    color: Colors.red,
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Text(
                    resourceDetail.user.name,
                  ),
                  flex: 6,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Icon(
                    Icons.email,
                    color: Colors.red,
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Text(
                    resourceDetail.user.emailaddress,
                  ),
                  flex: 6,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Icon(
                    Icons.phone,
                    color: Colors.red,
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Text(
                    resourceDetail.user.phonenumber,
                  ),
                  flex: 6,
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return SizedBox(
        width: 0.0,
        height: 0.0,
      );
    }
  }

  /*
   * resourceDetail
   * _paymentMethod(),
   * _deliveryMethod(),
 _bidDetail(),
              _rentDetail(),
   */
  _bidPriceBar() {
    if (_calledBy.toLowerCase().compareTo("resource") == 0 &&
        resourceDetail.saleType.toLowerCase().compareTo("bid") == 0) {
      return Column(
        children: <Widget>[
          Text(
            _bidText,
            style: TextStyle(fontSize: 14.0),
          ),
          Slider(
            onChanged: (val) {
              setState(() {
                _bidSliderValue = val.round();
                _bidText = "Price: " + _bidSliderValue.toString();
              });
            },
            value: double.parse(_bidSliderValue.toString()),
            min: _bidMinValue,
            max: _bidMaxValue,
            activeColor: Colors.red,
            inactiveColor: Colors.grey,
            label: "Bid Price",
          ),
        ],
      );
    } else {
      return SizedBox(
        width: 0.0,
        height: 0.0,
      );
    }
  }

  _detailActionButton() {
    if (_calledBy == "myresource" &&
        (resourceDetail.status.toLowerCase() == "rented" ||
            resourceDetail.status.toLowerCase() == "sold")) {
      return MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        elevation: 0.7,
        textColor: Colors.white,
        onPressed: _buttomSubmitted,
        color: Colors.redAccent,
        child: Text("Check In",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
      );
    } else if (_calledBy == "resource" &&
        resourceDetail.status.toLowerCase() == "avaliable") {
      return MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        elevation: 0.7,
        textColor: Colors.white,
        onPressed: _buttomSubmitted,
        color: Colors.redAccent,
        child: Text(
            resourceDetail.saleType == "Bid"
                ? "Place Bid"
                : resourceDetail.saleType == "Rent"
                    ? "Rent Resource"
                    : "Checkout",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
      );
    } else if (resourceDetail.status.toLowerCase() != "avaliable") {
      return Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text(
          resourceDetail.status.toLowerCase() == "rented"
              ? "This Item is Rented"
              : "This Item is Sold",
          style: TextStyle(fontSize: 18.0, color: Colors.red),
        ),
      );
    } else {
      return SizedBox(
        height: 0.0,
        width: 0.0,
      );
    }
  }

  _buttomSubmitted() {
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
                "Are You Sure?",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              flex: 4,
            )
          ],
        ),
        color: Colors.grey,
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            _dialogResult("Cancel");
          },
          child: Text("Cancel", style: TextStyle(color: Colors.red)),
        ),
        FlatButton(
          onPressed: () {
            _dialogResult("Sure");
          },
          child: Text("Sure", style: TextStyle(color: Colors.red)),
        ),
      ],
    );

    showDialog(context: context, builder: (_) => dialog);
  }

  _dialogResult(String action) {
    if (action == "Cancel") {
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      if (_calledBy == "myresource") {
        _myResourceSubmit();
      } else {
        _homeResourceSubmit();
      }
    }
  }

  _myResourceSubmit() async {
    print("_myResourceSubmit ResourceId: " +
        resourceDetail.id.toString() +
        ", SaleType: " +
        resourceDetail.saleType +
        " , requestedUserId:" +
        resourceDetail.requestUserId.toString() +
        " ");
    var response =
        await http.post(Uri.encodeFull(serverURL), headers: {}, body: {
      "worktodone": "OwnerSubmitResourceDetail",
      "id": resourceDetail.id.toString(),
      "saleType": resourceDetail.saleType,
      "requesteduserId": resourceDetail.requestUserId.toString()
    });
    print("_myResourceSubmit Response" + response.body);
    if (response.body == "success") {
      _getResourceData();
      _deatilScaffold.currentState.showSnackBar(new SnackBar(
        duration: Duration(seconds: 2),
        content: new Text(
          "Update Successfully",
          style: TextStyle(color: Colors.white),
        ),
      ));
    } else {}
  }

  _homeResourceSubmit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("userId");

    print("_myResourceSubmit ResourceId: " +
        resourceDetail.id.toString() +
        ", SaleType: " +
        resourceDetail.saleType +
        " , current userId:" +
        userId +
        " owner user id " +
        resourceDetail.userId.toString());

    if (resourceDetail.userId.toString() == userId) {
      _deatilScaffold.currentState.showSnackBar(new SnackBar(
        duration: Duration(seconds: 2),
        content: new Text(
          "Resource Belog to You",
          style: TextStyle(color: Colors.white),
        ),
      ));
      return;
    }
    var response =
        await http.post(Uri.encodeFull(serverURL), headers: {}, body: {
      "worktodone": "UserSubmitResourceDetail",
      "resourceId": resourceDetail.id.toString(),
      "saleType": resourceDetail.saleType,
      "resourcePrice": resourceDetail.price.toString(),
      "bidprice": resourceDetail.saleType == "Bid"
          ? _bidSliderValue.toString()
          : "nill",
      "userId": userId
    });
    print("_homeResourceSubmit Response" + response.body);
    if (response.body == "success") {
      _getResourceData();
      _deatilScaffold.currentState.showSnackBar(new SnackBar(
        duration: Duration(seconds: 2),
        content: new Text(
          "Request Submitted",
          style: TextStyle(color: Colors.white),
        ),
      ));
    } else {
      _deatilScaffold.currentState.showSnackBar(new SnackBar(
        duration: Duration(seconds: 2),
        content: new Text(
          "Try Again Later",
          style: TextStyle(color: Colors.red),
        ),
      ));
    }
  }

  _paymentMethod() {
    if (resourceDetail.saleType == "Donate") {
      return SizedBox(
        width: 0.0,
        height: 0.0,
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Payment Methods".toUpperCase(),
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                _bankTransfer(),
                _cashOnDelivery(),
                _easypaisa(),
              ],
            ),
          ],
        ),
      );
    }
  }

  _easypaisa() {
    if (resourceDetail.easypasa) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: Row(
            children: <Widget>[
              Text(
                "Easy Paisa",
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(
        width: 0.0,
        height: 0.0,
      );
    }
  }

  _bankTransfer() {
    if (resourceDetail.banktransfer) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: Row(
            children: <Widget>[
              Text(
                "Bank Transfer",
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(
        width: 0.0,
        height: 0.0,
      );
    }
  }

  _cashOnDelivery() {
    if (resourceDetail.cashOnDelivery) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: Row(
            children: <Widget>[
              Text(
                "COD",
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(
        width: 0.0,
        height: 0.0,
      );
    }
  }

  _deliveryMethod() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Delivery Methods".toUpperCase(),
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              _tcs(),
              _cargo(),
              _none(),
            ],
          ),
        ],
      ),
    );
  }

  _tcs() {
    if (resourceDetail.tcs) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: Row(
            children: <Widget>[
              Text(
                "TCS",
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(
        width: 0.0,
        height: 0.0,
      );
    }
  }

  _cargo() {
    if (resourceDetail.cargo) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: Row(
            children: <Widget>[
              Text(
                "Cargo",
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(
        width: 0.0,
        height: 0.0,
      );
    }
  }

  _none() {
    if (resourceDetail.none) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: Row(
            children: <Widget>[
              Text(
                "None",
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(
        width: 0.0,
        height: 0.0,
      );
    }
  }

  _bidDetail() {
    if (resourceDetail.saleType.toLowerCase().compareTo("bid") == 0) {
      return Column(
        children: <Widget>[
          Divider(
            height: 2.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "Biding Detail".toUpperCase(),
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          _bidList(),
        ],
      );
    } else {
      return SizedBox(
        width: 0.0,
        height: 0.0,
      );
    }
  }

  _bidList() {
    if (_beFirst) {
      return Text(
        "Be First To Bid",
        style: TextStyle(fontSize: 16.0, color: Colors.green),
      );
    } else if(resourceDetail.bidingDetailList !=null) {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: resourceDetail.bidingDetailList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              _bidContent(index),
            ],
          );
        },
      );
    }else{
      return SizedBox(width: 0.0,height: 0.0,);
    }
  }

  _bidContent(int index) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 3.0, left: 5.0),
            child: Text(
              resourceDetail.bidingDetailList[index].userInfo.name,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 2.0, bottom: 3.0, left: 5.0, right: 5.0),
            child: Text(
              "PKR " +
                  resourceDetail.bidingDetailList[index].bidPrice.toString(),
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 2.0, bottom: 3.0, left: 5.0, right: 5.0),
            child: Text(
              resourceDetail.bidingDetailList[index].userInfo.phonenumber,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          _bidApproveButton(index),
        ],
      ),
    );
  }

  _bidApproveButton(int index) {
    if (_calledBy.toLowerCase().compareTo("myresource") == 0 && resourceDetail.status!="Allocated") {
      return Padding(
        padding:
            const EdgeInsets.only(top: 1.0, bottom: 1.0, left: 5.0, right: 5.0),
        child: FlatButton(
          onPressed: () {
            _alertDialogBid(index);
          },
          color: Colors.grey[200],
          child: Text(
            "Approve",
            style: TextStyle(fontSize: 16.0, color: Colors.blue),
          ),
        ),
      );
    } else {
      return SizedBox(
        width: 0.0,
        height: 0.0,
      );
    }
  }

  _alertDialogBid(index){
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
                "Are You Sure?",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              flex: 4,
            )
          ],
        ),
        color: Colors.grey,
      ),
      content: 
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text("Allocate Bid to \""+resourceDetail.bidingDetailList[index].userInfo.name.toUpperCase()+"\" ",style: TextStyle(fontSize: 18.0),),
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
            _serverBidApprove(index);
          },
          child: Text("Yes", style: TextStyle(color: Colors.red)),
        ),
      ],
    );

    showDialog(context: context, builder: (_) => dialog);
  }

  _serverBidApprove(int index) async{
    print("_serverBidApprove");
    var response = await http.post(Uri.encodeFull(serverURL),
        body: {
          "worktodone": "BidApprove", 
          "userId": resourceDetail.bidingDetailList[index].userInfo.id.toString(),
          "resourceId":_id},
        );
    print("GetRentDetail Response " + response.body);
    setState(() {
      if (response.body == "success") {
        _getResourceData();
        _deatilScaffold.currentState.showSnackBar(new SnackBar(
        duration: Duration(seconds: 2),
        content: new Text(
          "Recource Allocated",
          style: TextStyle(color: Colors.white),
        ),
      ));
      } else {
        print("GetRentDetail No Data Found ");
      }
    });
  }

  _rentDetail() {
    if (_calledBy.compareTo("myresource") == 0 &&
        resourceDetail.saleType.toLowerCase().compareTo("rent") == 0) {
      return Column(
        children: <Widget>[
          Divider(
            height: 2.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "Rent Detail".toUpperCase(),
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          _rentList(),
        ],
      );
    } else {
      return SizedBox(
        width: 0.0,
        height: 0.0,
      );
    }
  }

  _rentList() {
    if (!_beFirst) {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: resourceDetail.rentDetailList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              _rentContent(index),
            ],
          );
        },
      );
    } else {
      return Text(
        "No Data Yet",
        style: TextStyle(fontSize: 16.0, color: Colors.green),
      );
    }
  }

  _rentContent(int index) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
            child: Text(
              resourceDetail.rentDetailList[index].userInfo.name,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
            child: Text(
              resourceDetail.rentDetailList[index].rentedDate,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
            child: Text(
              resourceDetail.rentDetailList[index].returnDate,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
            child: Text(
              "PKR " +
                  resourceDetail.rentDetailList[index].rentPrice.toString(),
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
            child: Text(
              resourceDetail.rentDetailList[index].userInfo.phonenumber,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
