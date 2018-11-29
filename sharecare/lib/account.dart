import 'package:flutter/material.dart';
import 'validator.dart';

class Account extends StatefulWidget {
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  /*Login Objects */
  FocusNode _passwordLoginFocusNode = FocusNode();
  FocusNode _emialLoginFocusNode = FocusNode();
  TextEditingController _passwordLoginController;
  TextEditingController _emailLoginController;
  final GlobalKey<FormState> _formSignKey = GlobalKey<FormState>();
  bool _autoSignValidate = false;
  /*--Login Objects */

  /*Register Objects */
  final GlobalKey<ScaffoldState> _signupScaffold =
      new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formSignUpKey = GlobalKey<FormState>();
  bool _autovalidateSignUp = false;

  FocusNode _nameRegisterFocusNode = FocusNode();
  FocusNode _phoneRegisterFocusNode = FocusNode();
  FocusNode _passwordRegisterFocusNode = FocusNode();
  FocusNode _emialRegisterFocusNode = FocusNode();
  FocusNode _conformpassRegisterFocusNode = FocusNode();

  TextEditingController _nameSignUpController;
  TextEditingController _phoneSignUpController;
  TextEditingController _passwordSignUpController;
  TextEditingController _emailSignUpController;
  TextEditingController _conformSignUpController;

  /*--Register Objects */

  /*Forget Password Objects */
  final GlobalKey<FormState> _formkeyforgetpassword = GlobalKey<FormState>();
  bool _autovalidationForgetPassword = false;
  TextEditingController _emailForgetController;
  /*--Forget Password Objects */

  void initState() {
    /*Login */
    _passwordLoginController = TextEditingController();
    _emailLoginController = TextEditingController();
    /*--Login */

    /*Forget Password */
    _emailForgetController = TextEditingController();
    /*--Forget Password */
    
    /*Register */
    _nameSignUpController = TextEditingController();
    _phoneSignUpController = TextEditingController();
    _passwordSignUpController = TextEditingController();
    _emailSignUpController = TextEditingController();
    _conformSignUpController = TextEditingController();
    /*--Register */
    
    super.initState();
  }

  _dialogResult(String action) {
    if (action == "Cancel") {
      Navigator.pop(context);
    } else if (action == "Register") {
      _registerServer();
    } else if (action == "ForgetPassword") {
      _forgetPasswordServer();
    }
  }

  _registerServer() {
    //send data to server
    if (_formSignUpKey.currentState.validate()) {
//    If all data are correct then save data to out variables

    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autovalidateSignUp = true;
      });
    }
  }

  _forgetPasswordServer() {
    //send data to server
    if (_formkeyforgetpassword.currentState.validate()) {
//    If all data are correct then save data to out variables

    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autovalidationForgetPassword = true;
      });
    }
  }

  _loginServer() {
    if (_formSignKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoSignValidate = true;
      });
    }
  }

  _loadLayout(String action) {
    if (action.compareTo("Register") == 0) {
      return _registerLayout();
    } else if (action.compareTo("ForgetPassword") == 0) {
      return _forgetPasswordLayout();
    }
  }

  _myAlertDialog(String action) {
    AlertDialog dialog = new AlertDialog(
      contentPadding: EdgeInsets.all(0.0),
      content: _loadLayout(action),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            _dialogResult("Cancel");
          },
          child: Text("Cancel", style: TextStyle(color: Colors.red)),
        ),
        FlatButton(
          onPressed: () {
            _dialogResult(
                action == "ForgetPassword" ? "ForgetPassword" : "Register");
          },
          child: Text(action == "ForgetPassword" ? "Reset Password" : action,
              style: TextStyle(color: Colors.red)),
        ),
      ],
    );

    showDialog(context: context, builder: (_) => dialog);
  }

  _registerLayout() {
    return new Scaffold(
      backgroundColor: Colors.white,
      key: _signupScaffold,
      body: Column(
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
                key: _formSignUpKey,
                autovalidate: _autovalidateSignUp,
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
                            onFieldSubmitted: (val) {
                              FocusScope.of(_signupScaffold.currentContext)
                                  .requestFocus(_phoneRegisterFocusNode);
                            },
                            focusNode: _nameRegisterFocusNode,
                            autofocus: true,
                            controller: _nameSignUpController,
                            validator: validateName,
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
                            focusNode: _phoneRegisterFocusNode,
                            onFieldSubmitted: (val) {
                              FocusScope.of(_signupScaffold.currentContext)
                                  .requestFocus(_emialRegisterFocusNode);
                            },
                            controller: _phoneSignUpController,
                            validator: validatePhoneNumber,
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
                            onFieldSubmitted: (val) {
                              FocusScope.of(_signupScaffold.currentContext)
                                  .requestFocus(_passwordRegisterFocusNode);
                            },
                            focusNode: _emialRegisterFocusNode,
                            controller: _emailSignUpController,
                            validator: validateEmail,
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
                            onFieldSubmitted: (val) {
                              FocusScope.of(_signupScaffold.currentContext)
                                  .requestFocus(_conformpassRegisterFocusNode);
                            },
                            focusNode: _passwordRegisterFocusNode,
                            controller: _passwordSignUpController,
                            validator: validatePassword,
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
                            onFieldSubmitted: (val) {
                              _registerServer();
                            },
                            focusNode: _conformpassRegisterFocusNode,
                            controller: _conformSignUpController,
                            validator: (val) {
                              return validateConformPassword(
                                  _passwordSignUpController.text, val);
                            },
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
      ),
    );
  }

  _forgetPasswordLayout() {
    return Form(
      key: _formkeyforgetpassword,
      autovalidate: _autovalidationForgetPassword,
      child: Theme(
          data: ThemeData(
            primaryColor: Colors.red,
            inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.0)),
                labelStyle: TextStyle(color: Colors.grey, fontSize: 16.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Email Address",
                ),
                style: TextStyle(color: Colors.grey),
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
                controller: _emailForgetController,
                validator: validateEmail,
                onFieldSubmitted: (val) {
                  _forgetPasswordServer();
                },
              ),
            ),
          )),
    );
  }
  /*--Register */

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
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image(
            image: AssetImage("assets/images/bg.jpg"),
            fit: BoxFit.cover,
          ),
          Column(
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
                    key: _formSignKey,
                    autovalidate: _autoSignValidate,
                    child: Theme(
                      data: ThemeData(
                        primaryColor: Colors.white,
                        inputDecorationTheme: InputDecorationTheme(
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(30.0)),
                            labelStyle: TextStyle(
                                color: Colors.white54, fontSize: 16.0)),
                      ),
                      child: _bodySignIn(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _bodySignIn() {
    return Padding(
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
              focusNode: _emialLoginFocusNode,
              controller: _emailLoginController,
              validator: validateEmail,
              onFieldSubmitted: (val) {
                FocusScope.of(context).requestFocus(_passwordLoginFocusNode);
              },
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
              keyboardType: TextInputType.text,
              obscureText: true,
              controller: _passwordLoginController,
              focusNode: _passwordLoginFocusNode,
              onFieldSubmitted: (val) {
                //same as clicking login button
                _loginServer();
              },
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
                  onPressed: () {
                    _myAlertDialog("ForgetPassword");
                  },
                  child: Text(
                    "Forget Password?",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  textColor: Colors.white,
                  onPressed: () {
                    _loginServer();
                  },
                  color: Colors.redAccent,
                  child: Text("LOGIN", style: TextStyle(fontSize: 16.0)),
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
              _myAlertDialog("Register");
            },
            child: Text("Create New Account", style: TextStyle(fontSize: 16.0)),
          ),
        ],
      ),
    );
  }

}
