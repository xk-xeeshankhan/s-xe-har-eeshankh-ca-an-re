
/*Validators */
String validateName(String value) {
    if (value.length < 3)
      return 'Name must be more than 2 charater';
    else
      return null;
}

String validateDescription(String value) {
    if (value.length < 11)
      return 'Description must be more than 10 charater';
    else
      return null;
}

String validatePhoneNumber(String value) {
    Pattern pattern =
        r'^((\+92)|(0092))-{0,1}\d{3}-{0,1}\d{7}$|^\d{11}$|^\d{4}-\d{7}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Invalid Phone Number';
    else
      return null;
  }

String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Invalid Email Address';
    else
      return null;
  }

String validatePassword(String value) {
     if (value.length < 6)
      return 'Too Short Atleast 6 Digit';
    else
      return null;
  }
String validateConformPassword(String password,String conform) {
     if (password.compareTo(conform)!=0)
      return 'Not Matched to Password';
    else
      return null;
  }
/*--Validators */
