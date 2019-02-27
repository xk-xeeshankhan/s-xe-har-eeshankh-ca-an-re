import 'package:flutter/material.dart';
import 'validator.dart';
import 'constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  /*Login Objects */

  final GlobalKey<ScaffoldState> _loginScaffold =
      new GlobalKey<ScaffoldState>();

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
    _home();
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

  _home() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("userId") != null) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      print("Main: SharedPreferences Else ");
    }
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

  _registerServer() async {
    //send data to server
    if (_formSignUpKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      String code = RandomString(10);
      var response =
          await http.post(Uri.encodeFull(serverURL), headers: {}, body: {
        "worktodone": "SignUp",
        "name": _nameSignUpController.text,
        "phonenumber": _phoneSignUpController.text,
        "email": _emailSignUpController.text,
        "password": _passwordSignUpController.text,
        "code": code
      });
      print(response.body);
      if (response.body.toLowerCase().compareTo("success") == 0) {
        Navigator.pop(context);
        _snackbar(
            displaytext: "Check Email to Verify",
            label: "Got It!",
            mycontext: _loginScaffold);
      } else if (response.body.toLowerCase().compareTo("emailused") == 0) {
        _snackbar(
            displaytext: "Email Address Already Exists",
            label: null,
            mycontext: _signupScaffold);
      }else if (response.body.toLowerCase().compareTo("emailerror") == 0) {
        _snackbar(
            displaytext: "Registration Error! Try Again Later",
            label: null,
            mycontext: _signupScaffold);
      } else {
        _snackbar(
            displaytext: "Something Went Wrong",
            label: null,
            mycontext: _signupScaffold);
      }
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autovalidateSignUp = true;
      });
    }
  }

  _forgetPasswordServer() async {
    //send data to server
    if (_formkeyforgetpassword.currentState.validate()) {
//    If all data are correct then save data to out variables
      Navigator.pop(context);
      var response =
          await http.post(Uri.encodeFull(serverURL), headers: {}, body: {
        "worktodone": "ForgetPassword",
        "email": _emailForgetController.text,
      });
      if (response.body.toLowerCase().compareTo("success") == 0) {
        _snackbar(
            displaytext: "Check Your Email Address",
            label: "Got It!",
            mycontext: _loginScaffold);
      } else if (response.body.toLowerCase().compareTo("emailnotexists") == 0) {
        _snackbar(
            displaytext: "Email Not Found!",
            label: null,
            mycontext: _loginScaffold);
      } else if (response.body.toLowerCase().compareTo("emailsendingerror") ==
          0) {
        _snackbar(
            displaytext: "Reset Error, Try Again Later!",
            label: null,
            mycontext: _loginScaffold);
      } else {
        _snackbar(
            displaytext: "Something Went Wrong",
            label: null,
            mycontext: _loginScaffold);
      }
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autovalidationForgetPassword = true;
      });
    }
  }

  _loginServer() async {
    var response =
        await http.post(Uri.encodeFull(serverURL), headers: {}, body: {
      "worktodone": "SignIn",
      "email": _emailLoginController.text,
      "password": _passwordLoginController.text
    });
    print(response.body);
    if (int.parse(response.body.toLowerCase()) > 0) {
      
      _sharepref(response.body);
      Navigator.of(context).pushReplacementNamed('/home');
    } else if (response.body.toLowerCase().compareTo("notverified") == 0) {
      _snackbar(
          displaytext: "Please Verify Your Email",
          label: "Got IT!",
          mycontext: _loginScaffold);
    } else {
      _snackbar(
          displaytext: "Invalid Email or Password",
          label: "Dismiss",
          mycontext: _loginScaffold);
    }
  }

  _sharepref(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userId", userId);
  }

  _loginFunction() {
    if (_formSignKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _loginServer();
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
    return Scaffold(
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
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0))
                            ),
                            style: TextStyle(color: Colors.grey),
                            keyboardType: TextInputType.text,
                            onFieldSubmitted: (val) {
                              FocusScope.of(_signupScaffold.currentContext)
                                  .requestFocus(_phoneRegisterFocusNode);
                            },
                            
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
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0))
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
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0))
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
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0))
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
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0))
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
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0))
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

  _snackbar({label, @required String displaytext, @required mycontext}) {
    mycontext.currentState.showSnackBar(new SnackBar(
      duration: Duration(seconds: label == null ? 2 : 3600),
      action: SnackBarAction(
        label: label == null ? "" : label,
        onPressed: () {
          mycontext.currentState
              .hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
        },
      ),
      content: new Text(
        displaytext,
        style: TextStyle(color: Colors.white),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _loginScaffold,
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0))
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0))
              ),
              style: TextStyle(color: Colors.white),
              keyboardType: TextInputType.text,
              obscureText: true,
              controller: _passwordLoginController,
              focusNode: _passwordLoginFocusNode,
              onFieldSubmitted: (val) {
                //same as clicking login button
                _loginFunction();
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
                    _loginFunction();
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
