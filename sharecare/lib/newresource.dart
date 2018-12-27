import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as basePathFile;
import 'package:sharecare/constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NewResource extends StatefulWidget {
  _NewResourceState createState() => _NewResourceState();
}

class _NewResourceState extends State<NewResource> {
  final GlobalKey<ScaffoldState> _newResouceScaffold =
      new GlobalKey<ScaffoldState>();

  TextEditingController _nameResourceController;
  TextEditingController _descriptionResourceController;
  TextEditingController _priceResourceController;

  FocusNode _nameFocusNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();
  FocusNode _priceFocusNode = FocusNode();

  List<String> _saleType = ["Sell", "Bid", "Rent", "Donate"];
  String _selectedSaleType = "Sell";
  String _imageUrlServer;
  File _image;

  final GlobalKey<FormState> _formNewResourceKey = GlobalKey<FormState>();
  bool _autoNewResourceValidate = false;

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

/* Validate */
  bool _deliveryValidate = true;
  bool _paymentValidate = true;
/* --Validate */

  @override
  void initState() {
    /*Controllers */
    _nameResourceController = TextEditingController();
    _descriptionResourceController = TextEditingController();
    _priceResourceController = TextEditingController();
    /*--Controllers */

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _newResouceScaffold,
      appBar: constantAppBar("New Resource"),
      body: _body(),
    );
  }

  _pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  _imageLayout() {
    if (_image == null) {
      return Image(
        image: AssetImage("assets/images/bg.jpg"),
        width: MediaQuery.of(context).size.width,
        height: 200.0,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        _image,
        width: MediaQuery.of(context).size.width,
        height: 200.0,
        fit: BoxFit.fill,
      );
    }
  }

  _body() {
    return SingleChildScrollView(
      child: Form(
        key: _formNewResourceKey,
        autovalidate: _autoNewResourceValidate,
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
              GestureDetector(
                  onTap: () {
                    _pickImage();
                  },
                  child: _imageLayout()),
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
                      child: DropdownButton<String>(
                        elevation: 0,
                        value: _selectedSaleType,
                        items: _saleType.map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(
                              value,
                              style:
                                  TextStyle(fontSize: 16.0, letterSpacing: 1.5),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          _changeSaleType(val);
                        },
                        isExpanded: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: "Name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0))),
                        style: TextStyle(color: Colors.grey),
                        keyboardType: TextInputType.text,
                        focusNode: _nameFocusNode,
                        onFieldSubmitted: (val) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        controller: _nameResourceController,
                        validator: _nameValidate,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: "Description",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0))),
                        style: TextStyle(color: Colors.grey),
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        onFieldSubmitted: (val) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        controller: _descriptionResourceController,
                        validator: _descriptionValidate,
                      ),
                    ),
                    _priceWidget(),
                    _deliveryMethod(),
                    _paymentMethod(),
                    MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      elevation: 0.7,
                      textColor: Colors.white,
                      onPressed: () {
                        validateData();
                      },
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

  String _nameValidate(String val) {
    if (val.length < 3) {
      return "Name Must be 3 Char long";
    }
    return null;
  }

  String _descriptionValidate(String val) {
    if (val.length < 5) {
      return "Please Type Some Description";
    }
    return null;
  }

  String _priceValidate(String val) {
    if (val.length <= 0) {
      return "Please Provide Price";
    }
    if (int.parse(val) <= 0) {
      return "Price to low";
    }
    return null;
  }

  validateData() {
    if (_formNewResourceKey.currentState.validate()) {
//    If all data are correct then save data to out variables

      if (_image == null) {
        _newResouceScaffold.currentState.showSnackBar(new SnackBar(
          duration: Duration(seconds: 3),
          content: new Text(
            "Please Select Image",
            style: TextStyle(color: Colors.white),
          ),
        ));
        return;
      }
      if (!_tcs && !_cargo && !_none) {
        setState(() {
          _deliveryValidate = false;
        });
        return;
      } else {
        setState(() {
          _deliveryValidate = true;
        });
      }
      if (_selectedSaleType != "Donate") {
        if (!_banktransfer && !_easypaisa && !_cod) {
          setState(() {
            _paymentValidate = false;
          });
          return;
        } else {
          setState(() {
            _paymentValidate = true;
          });
        }
      }

      _uploadDatatoServer();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoNewResourceValidate = true;
      });
    }
  }

  _uploadDatatoServer() async {
    //current date
    DateTime date = DateTime.now();
    //convet image to String
    List<int> imageBytes = _image.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    print("Image base64" + base64Image);

    //get image name and extension and modify for unique
    String fileName = basePathFile.basenameWithoutExtension(_image.path) +
        date.microsecond.toString();
    String fileExtension = basePathFile.extension(_image.path);
    String fullFileName = fileName + fileExtension;
    print("Filename " + fullFileName);

    _imageUrlServer = "http://localhost/shareandcare/images/" + fullFileName;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("userId");

    String formattedDate = date.year.toString() +
        "-" +
        date.month.toString() +
        "-" +
        date.day.toString();

    String query = "Insert INTO resource Values ( null,'" +
        _nameResourceController.text +
        "' , '" +
        _descriptionResourceController.text +
        "'," +
        " " +
        (_selectedSaleType == 'Donate' ? '0' : _priceResourceController.text) +
        ", '" +
        formattedDate +
        "', '" +
        _selectedSaleType +
        "', '" +
        _imageUrlServer +
        "', 'Avaliable'," +
        " " +
        _cod.toString() +
        " ,'0', '" +
        userId +
        "' , 0, " +
        _none.toString() +
        " , " +
        _easypaisa.toString() +
        ", " +
        _banktransfer.toString() +
        ", '0', '0' , " +
        _cargo.toString() +
        " , " +
        _tcs.toString() +
        " ) ";

    var response =
        await http.post(Uri.encodeFull(serverURL), headers: {}, body: {
      "worktodone": "AddNewResource",
      "imageFile": base64Image,
      "imageFileName": fullFileName,
      "query": query
    });
    print("Response New Resource" + response.body);
    if (response.body.toLowerCase().compareTo("success") == 0) {
      setState(() {
        _nameResourceController.text="";
        _descriptionResourceController.text = "";
        _priceResourceController.text="";
        _cod = false;
        _banktransfer = false;
        _easypaisa = false;
        _cargo = false;
        _tcs = false;
        _none = false;
        _image = null;
        ServerLoadResources();
        _newResouceScaffold.currentState.showSnackBar(new SnackBar(
          duration: Duration(seconds: 3),
          content: new Text(
            "New Resource Added Successfully",
            style: TextStyle(color: Colors.white),
          ),
        ));
      });
    } else if (response.body.compareTo("errorimage") == 0) {
      _newResouceScaffold.currentState.showSnackBar(new SnackBar(
          duration: Duration(seconds: 3000),
          action: SnackBarAction(label: "Try Again",onPressed: (){
            _uploadDatatoServer();
          },),
          content: new Text(
            "Error Uploading Image",
            style: TextStyle(color: Colors.white),
          ),
        ));
    } else {
       _newResouceScaffold.currentState.showSnackBar(new SnackBar(
          duration: Duration(seconds: 3),
          content: new Text(
            "Error Try Again later",
            style: TextStyle(color: Colors.white),
          ),
        ));
    }
  }

  _priceWidget() {
    if (_selectedSaleType != "Donate") {
      return Padding(
        padding: const EdgeInsets.only(
            left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
        child: TextFormField(
          decoration: InputDecoration(
              labelText: "Price",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0))),
          style: TextStyle(color: Colors.grey),
          keyboardType: TextInputType.number,
          focusNode: _priceFocusNode,
          onFieldSubmitted: (val) {},
          controller: _priceResourceController,
          validator: _priceValidate,
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
          _showDeliveryError(),
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

  _showDeliveryError() {
    if (!_deliveryValidate) {
      return Text(
        "Please Select Atleast One Method",
        style: TextStyle(fontSize: 14.0, color: Colors.red),
      );
    } else {
      return SizedBox(
        width: 0.0,
        height: 0.0,
      );
    }
  }

  _styleCheckbox() {
    return TextStyle(
      fontSize: 16.0,
    );
  }

  _cargoOnChange(value) {
    setState(() {
      if (value) {
        _none = false;
        _deliveryValidate = true;
      }
      _cargo = value;
    });
  }

  _tcsOnChange(value) {
    setState(() {
      if (value) {
        _none = false;
        _deliveryValidate = true;
      }
      _tcs = value;
    });
  }

  _noneOnChange(value) {
    setState(() {
      if (value) {
        _tcs = false;
        _cargo = false;
        _deliveryValidate = true;
      }
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
        _showPaymentError(),
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

  _showPaymentError() {
    if (!_paymentValidate) {
      return Text(
        "Please Select Atleast One Method",
        style: TextStyle(fontSize: 14.0, color: Colors.red),
      );
    } else {
      return SizedBox(
        width: 0.0,
        height: 0.0,
      );
    }
  }

  _codOnChange(value) {
    setState(() {
      if (value) {
        _paymentValidate = true;
      }
      _cod = value;
    });
  }

  _easypaisaOnChange(value) {
    setState(() {
      if (value) {
        _paymentValidate = true;
      }
      _easypaisa = value;
    });
  }

  _banktransferOnChange(value) {
    setState(() {
      if (value) {
        _paymentValidate = true;
      }
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
