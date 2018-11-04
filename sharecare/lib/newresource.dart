import 'package:flutter/material.dart';
import 'package:sharecare/constantWidget.dart';

class NewResource extends StatefulWidget {
  _NewResourceState createState() => _NewResourceState();
}

class _NewResourceState extends State<NewResource> {
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();
  FocusNode _priceFocusNode = FocusNode();

  List<String> _saleType = ["Sell", "Bid", "Rent", "Donate"];
  String _selectedSaleType = "Sell";

/*Delivery Methods */
  bool _cargo = false;
  bool _tcs = false;
  bool _none = false;
/*--Delivery Methods */

/*Payment Methods */
  bool _cod = false;
  bool _easypaisa = false;
  bool _banktransfer = false;
/*--Payment Methods */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: constantAppBar(),
      body: _body(),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Form(
        child: Theme(
          data: ThemeData(
            primaryColor: Colors.grey,
            inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.0)),
                labelStyle: TextStyle(color: Colors.grey, fontSize: 16.0)),
          ),
          child: Column(
            children: <Widget>[
              Image(
                image: AssetImage("assets/images/bg.jpg"),
                width: MediaQuery.of(context).size.width,
                height: 200.0,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 8.0, left: 15.0, right: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: DropdownButton<String>(
                        value: _selectedSaleType,
                        items: _saleType.map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(
                              value,
                              style: TextStyle(fontSize: 16.0),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          _changeSaleType(val);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Name",
                        ),
                        style: TextStyle(color: Colors.grey),
                        keyboardType: TextInputType.text,
                        focusNode: _nameFocusNode,
                        onFieldSubmitted: (val) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Description",
                        ),
                        style: TextStyle(color: Colors.grey),
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        onFieldSubmitted: (val) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                      ),
                    ),
                    _priceWidget(),
                    _deliveryMethod(),
                    _paymentMethod(),
                    MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      elevation: 0.7,
                      textColor: Colors.white,
                      onPressed: () {},
                      color: Colors.redAccent,
                      child: Text("Add Resource",
                          style: TextStyle(fontSize: 16.0)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _priceWidget() {
    if (_selectedSaleType != "Donate") {
      return Padding(
        padding: const EdgeInsets.only(
            left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: "Price",
          ),
          style: TextStyle(color: Colors.grey),
          keyboardType: TextInputType.numberWithOptions(signed: true),
          focusNode: _priceFocusNode,
          onFieldSubmitted: (val) {},
        ),
      );
    }
    return SizedBox(
      height: 0.0,
    );
  }

/*Delivery Method */
  _deliveryMethod() {
    if (_selectedSaleType != "Donate") {
      return Column(
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Text(
            "Delivery Methods",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey),
          ),
          CheckboxListTile(
            title: Text(
              "Cargo",
              style: _styleCheckbox(),
            ),
            value: _cargo,
            onChanged: _cargoOnChange,
          ),
          CheckboxListTile(
            title: Text(
              "TCS",
              style: _styleCheckbox(),
            ),
            value: _tcs,
            onChanged: _tcsOnChange,
          ),
          CheckboxListTile(
            title: Text(
              "None",
              style: _styleCheckbox(),
            ),
            value: _none,
            onChanged: _noneOnChange,
          )
        ],
      );
    }
    return SizedBox(
      height: 0.0,
    );
  }

  _styleCheckbox() {
    return TextStyle(
      fontSize: 16.0,
    );
  }

  _cargoOnChange(value) {
    setState(() {
      _cargo = value;
    });
  }

  _tcsOnChange(value) {
    setState(() {
      _tcs = value;
    });
  }

  _noneOnChange(value) {
    setState(() {
      _none = value;
    });
  }
/*--Delivery Method */

/*Payment Method */
  _paymentMethod() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Text(
          "Payment Methods",
          style: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        CheckboxListTile(
          title: Text(
            "Cash on Delivery",
            style: _styleCheckbox(),
          ),
          value: _cod,
          onChanged: _codOnChange,
        ),
        CheckboxListTile(
          title: Text(
            "Easy Paisa",
            style: _styleCheckbox(),
          ),
          value: _easypaisa,
          onChanged: _easypaisaOnChange,
        ),
        CheckboxListTile(
          title: Text(
            "Bank Transfer",
            style: _styleCheckbox(),
          ),
          value: _banktransfer,
          onChanged: _banktransferOnChange,
        )
      ],
    );
  }

  _codOnChange(value) {
    setState(() {
      _cod = value;
    });
  }

  _easypaisaOnChange(value) {
    setState(() {
      _easypaisa = value;
    });
  }

  _banktransferOnChange(value) {
    setState(() {
      _banktransfer = value;
    });
  }

/*--Payment Method */
  _changeSaleType(value) {
    setState(() {
      _selectedSaleType = value;
    });
  }
}
