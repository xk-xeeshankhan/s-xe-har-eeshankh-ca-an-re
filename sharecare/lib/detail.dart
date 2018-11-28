import 'package:flutter/material.dart';

class ResourceDetail extends StatefulWidget {
  final String calledBy;
  final String id;
  ResourceDetail(this.calledBy, this.id);
  _ResourceDetailState createState() => _ResourceDetailState();
}

class _ResourceDetailState extends State<ResourceDetail> {
  String _calledBy;
  String _id;
  @override
  void initState() {
    // TODO: implement initState
    _calledBy = widget.calledBy;
    _id = widget.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 8.0),
                child: Text(
                  "Resource Name",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Image(
                image: AssetImage("assets/images/bg.jpg"),
                width: MediaQuery.of(context).size.width,
                height: 200.0,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Text(
                  "Sale Type",
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
                        style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Avaliable",
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
                        style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "This is to test that each description is provided in exact format so its only the test",
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
                        style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "PKR 200",
                        style: TextStyle(fontSize: 16.0, color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 2.0,
              ),
              _paymentMethod(),
              Divider(
                height: 2.0,
              ),
              _deliveryMethod(),
              _bidDetail(),
              _rentDetail(),
              _detailActionButton(),
            ],
          ),
        ),
      ),
    );
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
              _bankTransger(),
              _cashOnDelivery(),
            ],
          ),
        ],
      ),
    );
  }

  _bankTransger() {
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
  }

  _cashOnDelivery() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: Row(
          children: <Widget>[
            Text(
              "Cash On Delivery",
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
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
  }

  _cargo() {
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
  }

  _none() {
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
  }

  _bidDetail() {
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
        _bidContent(),
      ],
    );
  }

  _bidContent() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                top: 1.0, bottom: 1.0, left: 5.0, right: 5.0),
            child: Text(
              "Xeeshan Khan",
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 1.0, bottom: 1.0, left: 5.0, right: 5.0),
            child: Text(
              "PKR 200000",
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 1.0, bottom: 1.0, left: 5.0, right: 5.0),
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
  }

  _rentDetail() {
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
        _rentContent(),
      ],
    );
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
