import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final GlobalKey<ScaffoldState> _signupScaffold =
      new GlobalKey<ScaffoldState>();

  _registerDialogResult(@required String action) {
    Navigator.pop(context);
  }

  void _registerAlertDialog() {
    AlertDialog dialog = new AlertDialog(
      contentPadding: EdgeInsets.all(0.0),
      content: new Scaffold(
        backgroundColor: Colors.white,
        key: _signupScaffold,
        body: _registerLayout(),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            _registerDialogResult("Cancel");
          },
          child: Text("Cancel", style: TextStyle(color: Colors.red)),
        ),
        FlatButton(
          onPressed: () {
            _registerDialogResult("Register");
          },
          child: Text("Register", style: TextStyle(color: Colors.red)),
        ),
      ],
    );

    showDialog(context: context, child: dialog);
  }

  _registerLayout() {
    return Column(
      children: <Widget>[
        SizedBox(height: 20.0),
        Text(
          "Register Your Account",
          style: TextStyle(fontSize: 30.0),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.0),
        Expanded(
          child: SingleChildScrollView(
            child: Form(
              child: Theme(
                data: ThemeData(
                  primaryColor: Colors.red,
                  inputDecorationTheme: InputDecorationTheme(
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.0)),
                      labelStyle:
                          TextStyle(color: Colors.grey, fontSize: 16.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Name",
                          ),
                          style: TextStyle(color: Colors.grey),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Phone Number",
                          ),
                          style: TextStyle(color: Colors.grey),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Email Address",
                          ),
                          style: TextStyle(color: Colors.grey),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Password",
                          ),
                          style: TextStyle(color: Colors.grey),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Conform Password",
                          ),
                          style: TextStyle(color: Colors.grey),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // _snackbar(@required String displaytext) {
  //   _signupScaffold.currentState.showSnackBar(new SnackBar(
  //     duration: Duration(hours: 1),
  //     action: SnackBarAction(
  //       label: "Okay",
  //       onPressed: () {
  //         Scaffold.of(context)
  //             .hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
  //       },
  //     ),
  //     content: new Text(
  //       displaytext,
  //       style: TextStyle(color: Colors.white),
  //     ),
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new Image(
          image: AssetImage("assets/images/bg.jpg"),
          fit: BoxFit.cover,
        ),
        new Column(
          children: <Widget>[
            // FlutterLogo(
            //   size: _titleAnimation.value * 100,
            // ),
            SizedBox(
              height: 100.0,
            ),
            Text("Share And Care",
                style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text("Login",
                  style: TextStyle(fontSize: 40.0, color: Colors.white)),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  child: Theme(
                    data: ThemeData(
                      primaryColor: Colors.white,
                      inputDecorationTheme: InputDecorationTheme(
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(30.0)),
                          labelStyle:
                              TextStyle(color: Colors.white54, fontSize: 16.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                icon: Icon(Icons.email),
                                labelText: "Email Address",
                              ),
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                icon: Icon(Icons.lock),
                                labelText: "Password",
                              ),
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.emailAddress,
                              obscureText: true,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: MaterialButton(
                                  textColor: Colors.white,
                                  onPressed: () {},
                                  child: Text(
                                    "Forget Password?",
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: MaterialButton(
                                  textColor: Colors.white,
                                  onPressed: () {},
                                  color: Colors.redAccent,
                                  child: Text("LOGIN",
                                      style: TextStyle(fontSize: 16.0)),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                          MaterialButton(
                            textColor: Colors.white,
                            onPressed: () {
                              _registerAlertDialog();
                            },
                            child: Text("Create New Account",
                                style: TextStyle(fontSize: 16.0)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
