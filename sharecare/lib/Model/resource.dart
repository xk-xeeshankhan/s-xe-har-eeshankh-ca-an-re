import 'package:sharecare/Model/bidingdetail.dart';
import 'package:sharecare/Model/rentdetail.dart';
import 'package:sharecare/Model/user.dart';

class ResourceModel {
  int id, like, dislike, userId, requestUserId;
  String name, description, status, addedDate, saleType, imageUrl;
  int price;
  bool cashOnDelivery, stamp, none, easypasa, tcs, cargo, banktransfer;

  User _requestedUser;
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
      this.stamp,
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
  User get requestedUser => _requestedUser;

  set requestedUser(User requestedUser) {
    _requestedUser = requestedUser;
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

List<ResourceModel> resourceListAll = [
  ResourceModel(1, "name", "description", "status", "sell", "imageUrl",
      "addedDate", 0, true, true, true, true, true, true, true, 0, 0, 1, 2),
  ResourceModel(1, "name", "description", "status", "sell", "imageUrl",
      "addedDate", 0, true, true, true, true, true, true, true, 0, 0, 1, 2),
  ResourceModel(1, "name", "description", "status", "sell", "imageUrl",
      "addedDate", 0, true, true, true, true, true, true, true, 0, 0, 1, 2),
  ResourceModel(1, "name", "description", "status", "sell", "imageUrl",
      "addedDate", 0, true, true, true, true, true, true, true, 0, 0, 1, 2),
  ResourceModel(1, "name", "description", "status", "sell", "imageUrl",
      "addedDate", 0, true, true, true, true, true, true, true, 0, 0, 1, 2),
  ResourceModel(1, "name", "description", "status", "sell", "imageUrl",
      "addedDate", 0, true, true, true, true, true, true, true, 0, 0, 1, 2),
  ResourceModel(1, "name", "description", "status", "bid", "imageUrl",
      "addedDate", 0, true, true, true, true, true, true, true, 0, 0, 1, 2),
  ResourceModel(1, "name", "description", "status", "bid", "imageUrl",
      "addedDate", 0, true, true, true, true, true, true, true, 0, 0, 1, 2),
  ResourceModel(1, "name", "description", "status", "rent", "imageUrl",
      "addedDate", 0, true, true, true, true, true, true, true, 0, 0, 1, 2),
  ResourceModel(1, "name", "description", "status", "donate", "imageUrl",
      "addedDate", 0, true, true, true, true, true, true, true, 0, 0, 1, 2),
  ResourceModel(1, "name", "description", "status", "donate", "imageUrl",
      "addedDate", 0, true, true, true, true, true, true, true, 0, 0, 1, 2),
  ResourceModel(1, "name", "description", "status", "donate", "imageUrl",
      "addedDate", 0, true, true, true, true, true, true, true, 0, 0, 1, 2),
  ResourceModel(1, "name", "description", "status", "donate", "imageUrl",
      "addedDate", 0, true, true, true, true, true, true, true, 0, 0, 1, 2),
];
