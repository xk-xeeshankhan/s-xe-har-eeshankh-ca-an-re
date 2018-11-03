
class ResourceModel {
  int id;
  String title,description,status;
  double price;

  ResourceModel(this.id,this.title,this.description,this.price,this.status);
}

  List<ResourceModel> resourceListAll = [
    ResourceModel(1,"title", "description", 0.0, "sell"),
    ResourceModel(1,"title1", "description1", 0.0, "sell"),
    ResourceModel(1,"title2", "description2", 0.0, "sell"),
    ResourceModel(1,"title3", "description3", 0.0, "sell"),
    ResourceModel(1,"title4", "description4", 0.0, "bid"),
    ResourceModel(1,"title4", "description4", 0.0, "bid"),
    ResourceModel(1,"title5", "description5", 0.0, "rent"),
    ResourceModel(1,"title6", "description6", 0.0, "donate"),
    ResourceModel(1,"title6", "description6", 0.0, "donate"),
    ResourceModel(1,"title6", "description6", 0.0, "donate"),
  ];
