import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _oldpasswordFocusNode = FocusNode();
  FocusNode _newpasswordFocusNode = FocusNode();
  FocusNode _conformpassFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return _body();
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      elevation: 0.7,
                      textColor: Colors.white,
                      onPressed: () {},
                      color: Colors.redAccent,
                      child: Text("Update Profile",
                          style: TextStyle(fontSize: 16.0)),
                    ),
                  ),
                ],
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
                        FocusScope.of(context).requestFocus(_newpasswordFocusNode);
                      },
                      focusNode: _oldpasswordFocusNode,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "New Password",
                      ),
                      style: TextStyle(color: Colors.grey),
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (val) {
                        FocusScope.of(context).requestFocus(_conformpassFocusNode);
                      },
                      focusNode: _newpasswordFocusNode,
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
                      onFieldSubmitted: (val) {
                        //same fun as on button pressed
                      },
                      focusNode: _conformpassFocusNode,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      elevation: 0.7,
                      textColor: Colors.white,
                      onPressed: () {},
                      color: Colors.redAccent,
                      child: Text("Update Password",
                          style: TextStyle(fontSize: 16.0)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
