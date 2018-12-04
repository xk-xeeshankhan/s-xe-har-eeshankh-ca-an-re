import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sharecare/Model/resource.dart';
import 'package:http/http.dart' as http;
import 'package:sharecare/constant.dart';

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
  /*Biding  */
  int _bidSliderValue;
  double _bidMinValue;
  double _bidMaxValue;
  String _bidText;
  /*--Biding  */

  ResourceModel resourceDetail;
  @override
  void initState() {
    // TODO: implement initState
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
          resourceDetail = ResourceModel(
              int.parse(res["id"]),
              res["name"],
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
        });
        /*Bid */
        if(resourceDetail.saleType.toLowerCase().compareTo("bid")==0){
         
          _bidSliderValue = int.parse(resourceDetail.price.toString()); 
          _bidMinValue = double.parse((resourceDetail.price/2).toString()); 
          _bidMaxValue = double.parse((resourceDetail.price*2).toString()); 
           _bidText = "Price: "+_bidSliderValue.toString();
        }
        if (_calledBy == "resource") {
        } else {}
      });
    } else {
      //no data from server
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          _bidPriceBar(),
          _detailActionButton(),
          _bidDetail(),
          _rentDetail(),
        ],
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
          Text(_bidText,style: TextStyle(fontSize: 14.0),),
          Slider(
            onChanged: (val) {
              setState(() {
                _bidSliderValue = val.round();
                _bidText = "Price: "+_bidSliderValue.toString();
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
    return MaterialButton(
      minWidth: MediaQuery.of(context).size.width,
      elevation: 0.7,
      textColor: Colors.white,
      onPressed: () {},
      color: Colors.redAccent,
      child: Text("Check In".toUpperCase(),
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
    );
  }

  _paymentMethod() {
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
          _bidContent(),
        ],
      );
    } else {
      return SizedBox(
        width: 0.0,
        height: 0.0,
      );
    }
  }

  _bidContent() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 3.0, left: 5.0),
            child: Text(
              "Xeeshan Khan",
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 2.0, bottom: 3.0, left: 5.0, right: 5.0),
            child: Text(
              "PKR 200000",
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 2.0, bottom: 3.0, left: 5.0, right: 5.0),
            child: Text(
              "+92334059921",
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          _bidApproveButton(),
        ],
      ),
    );
  }

  _bidApproveButton() {
    if (_calledBy.toLowerCase().compareTo("myresource") == 0) {
      return Padding(
        padding:
            const EdgeInsets.only(top: 1.0, bottom: 1.0, left: 5.0, right: 5.0),
        child: FlatButton(
          onPressed: () {},
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
          _rentContent(),
        ],
      );
    } else {
      return SizedBox(
        width: 0.0,
        height: 0.0,
      );
    }
  }

  _rentContent() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
            child: Text(
              "Xeeshan Khan",
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
            child: Text(
              "Rented Date",
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
            child: Text(
              "Return Date",
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
            child: Text(
              "PKR 200000",
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
            child: Text(
              "+92334059921",
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
