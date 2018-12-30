import 'package:sharecare/Model/bidingdetail.dart';
import 'package:sharecare/Model/rentdetail.dart';
import 'package:sharecare/Model/user.dart';

class ResourceModel {
  int id, like, dislike, userId, requestUserId;
  String name, description, status, addedDate, saleType, imageUrl;
  int price;
  bool cashOnDelivery, facebook, none, easypasa, tcs, cargo, banktransfer;

  User _user;
  List<RentDetail> _rentDetailList;
  List<BidingDetail> _bidingDetailList;

  ResourceModel(
      this.id,
      this.name,
      this.description,
      this.status,
      this.saleType,
      this.imageUrl,
      this.addedDate,
      this.price,
      this.cashOnDelivery,
      this.facebook,
      this.none,
      this.easypasa,
      this.tcs,
      this.cargo,
      this.banktransfer,
      this.like,
      this.dislike,
      this.userId,
      this.requestUserId);
/*User */
  User get user => _user;

  set user(User user) {
    _user = user;
  }
/*--User */

/*Rent Detail List */
  List<RentDetail> get rentDetailList => _rentDetailList;

  set rentDetailList(List<RentDetail> rentDetailList) {
    _rentDetailList = rentDetailList;
  }

/*--Rent Detail List */
/*Biding Detail List */
  List<BidingDetail> get bidingDetailList => _bidingDetailList;

  set bidingDetailList(List<BidingDetail> bidingDetailList) {
    _bidingDetailList = bidingDetailList;
  }
  /*--Biding Detail List */
}

List<ResourceModel> resourceListAll= List();
List<ResourceModel> myResourceList = List();