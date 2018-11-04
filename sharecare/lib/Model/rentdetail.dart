
import 'package:sharecare/Model/user.dart';

class RentDetail {
  int id,rentPrice,resourceId;
  String rentedDate,returnDate;
  User userInfo;

  RentDetail(this.id,this.resourceId,this.rentPrice,this.rentedDate,this.returnDate,this.userInfo);

  
}