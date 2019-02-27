import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sharecare/Model/user.dart';
import 'constant.dart';
import 'package:sharecare/validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  var homeScaffold;
  Setting(this.homeScaffold);
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _oldpasswordFocusNode = FocusNode();
  FocusNode _newpasswordFocusNode = FocusNode();
  FocusNode _conformpassFocusNode = FocusNode();

  TextEditingController _nameController;
  TextEditingController _phoneController;

  TextEditingController _oldController;
  TextEditingController _newController;
  TextEditingController _confController,_ipController;

  GlobalKey<ScaffoldState> _mainScaffold;

  final GlobalKey<FormState> _formUpdatePassword = GlobalKey<FormState>();
  bool _autovalidationUpdatePassword = false;

  final GlobalKey<FormState> _formUpdateProfile = GlobalKey<FormState>();
  bool _autovalidationUpdateProfile = false;
  

  User _user;

  @override
  Widget build(BuildContext context) {
    return 
      _body();
    
  }

  void initState() {
    _mainScaffold = widget.homeScaffold;
    _nameController = TextEditingController();
    _phoneController = TextEditingController();

    _oldController = TextEditingController();
    _newController = TextEditingController();
    _confController = TextEditingController();

    _ipController = TextEditingController();

    _getData();
    super.initState();
  }

  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("userId");

    var response = await http.post(Uri.encodeFull(serverURL),
        headers: {"Accept": "application/json"},
        body: {"worktodone": "userData", "id": userId});
    print(response.body);
    if (response.body == "nodata") {
    } else {
      List data = json.decode(response.body);
      setState(() {
        data.forEach((us) {
          _user =
              User(int.parse(us["id"]), us["name"], us["email"], us["phonenumber"]);
          _user.password = us["password"];
        });

        _nameController.text = _user.name;
        _phoneController.text = _user.phonenumber;
      });
    }
  }

  _body() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                "Profile Settings",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
            ),
            Theme(
              data: ThemeData(
                primaryColor: Colors.red,
                inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.0)),
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 16.0)),
              ),
              child: Form(
                key: _formUpdateProfile,
                autovalidate: _autovalidationUpdateProfile,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Name",
                        ),
                        style: TextStyle(color: Colors.grey),
                        keyboardType: TextInputType.text,
                        onFieldSubmitted: (val) {
                          FocusScope.of(context).requestFocus(_phoneFocusNode);
                        },
                        focusNode: _nameFocusNode,
                        controller: _nameController,
                        validator: validateName,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                        ),
                        style: TextStyle(color: Colors.grey),
                        keyboardType: TextInputType.text,
                        onFieldSubmitted: (val) {
                          //call funtion same as button submit
                        },
                        focusNode: _phoneFocusNode,
                        controller: _phoneController,
                        validator: validatePhoneNumber,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        elevation: 0.7,
                        textColor: Colors.white,
                        onPressed: () {
                          _updateProfileServer();
                        },
                        color: Colors.redAccent,
                        child: Text("Update Profile",
                            style: TextStyle(fontSize: 16.0)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                "Password Settings",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
            ),
            Theme(
              data: ThemeData(
                primaryColor: Colors.red,
                inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.0)),
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 16.0)),
              ),
              child: Form(
                key: _formUpdatePassword,
                autovalidate: _autovalidationUpdatePassword,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Old Password",
                        ),
                        style: TextStyle(color: Colors.grey),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        onFieldSubmitted: (val) {
                          FocusScope.of(context)
                              .requestFocus(_newpasswordFocusNode);
                        },
                        focusNode: _oldpasswordFocusNode,
                        validator: (val) {
                          if (_newController.text ==
                              _confController.text) if (val != _user.password) {
                            return "Invalid Old Password";
                          }
                        },
                        controller: _oldController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "New Password",
                        ),
                        style: TextStyle(color: Colors.grey),
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        onFieldSubmitted: (val) {
                          FocusScope.of(context)
                              .requestFocus(_conformpassFocusNode);
                        },
                        focusNode: _newpasswordFocusNode,
                        controller: _newController,
                        validator: validatePassword,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Conform Password",
                        ),
                        style: TextStyle(color: Colors.grey),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        onFieldSubmitted: (val) {
                          //same fun as on button pressed
                        },
                        focusNode: _conformpassFocusNode,
                        controller: _confController,
                        validator: (val) {
                          if (val != _newController.text) {
                            return "New and Conform Password Mismatch";
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        elevation: 0.7,
                        textColor: Colors.white,
                        onPressed: () {
                          _updatePasswordServer();
                        },
                        color: Colors.redAccent,
                        child: Text("Update Password",
                            style: TextStyle(fontSize: 16.0)),
                      ),
                    ),
                  ],
                ),
              ),
            ),



            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                "IP Address",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
            ),
            Theme(
              data: ThemeData(
                primaryColor: Colors.red,
                inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.0)),
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 16.0)),
              ),
              child: Form(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "IP Address",
                        ),
                        style: TextStyle(color: Colors.grey),
                        keyboardType: TextInputType.text,                      
                        controller: _ipController,
                      ),
                    ),
                    
                    
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        elevation: 0.7,
                        textColor: Colors.white,
                        onPressed: () {
                          _updateip();
                        },
                        color: Colors.redAccent,
                        child: Text("Update IP",
                            style: TextStyle(fontSize: 16.0)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _updateip(){
    setIpAddress(_ipController.text);
    // initState();
    print(ipv4);

  }

  _updateProfileServer() async {
    if(_formUpdateProfile.currentState.validate()){
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("userId");

    var response =
        await http.post(Uri.encodeFull(serverURL), headers: {}, body: {
      "worktodone": "UpdateProfile",
      "name": _nameController.text,
      "phone": _phoneController.text,
      "userId": userId
    });
    print(response.body);
    if (response.body == "success") {
      _getData();
      _mainScaffold.currentState.showSnackBar(new SnackBar(
      duration: Duration(seconds: 2),
      content: new Text(
        "Profile Updated Successfully",
        style: TextStyle(color: Colors.white),
      ),
    ));
    } else {
      _mainScaffold.currentState.showSnackBar(new SnackBar(
      duration: Duration(seconds: 2),
      content: new Text(
        "Please Try Again Later",
        style: TextStyle(color: Colors.white),
      ),
    ));
    }}else{
      setState(() {
              _autovalidationUpdateProfile = true;
            });
    }
  }

  _updatePasswordServer() async {
    if(_formUpdatePassword.currentState.validate()){
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("userId");

    var response =
        await http.post(Uri.encodeFull(serverURL), headers: {}, body: {
      "worktodone": "UpdatePassword",
      "newpassword": _newController.text,
      "userId": userId
    });
    print(response.body);
    if (response.body == "success") {
      _getData();
      _mainScaffold.currentState.showSnackBar(new SnackBar(
      duration: Duration(seconds: 2),
      content: new Text(
        "Password Updated Successfully",
        style: TextStyle(color: Colors.white),
      ),
      
    ));
    setState(() {
          _newController.text="";
          _oldController.text="";
          _confController.text="";
        });
    } else {
      _mainScaffold.currentState.showSnackBar(new SnackBar(
      duration: Duration(seconds: 2),
      content: new Text(
        "Try Again Later",
        style: TextStyle(color: Colors.white),
      ),
    ));
    }
    }else{
      setState(() {
              _autovalidationUpdatePassword = true;
            });
    }
  }

}
