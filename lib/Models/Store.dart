class Store{
  String id,storeName,accountId,storeInfo,storeAddress,storeRating,storeFollowers,storeVisited,storeStatus;
  
  Store({this.id,
         this.accountId,
         this.storeName,
         this.storeAddress,
         this.storeFollowers,
         this.storeInfo,
         this.storeRating,
         this.storeVisited,
         this.storeStatus
        });
  
  factory Store.toObject(Map<String,dynamic> map){
    return Store(
      id: map['id'],
      accountId: map['accountId'],
      storeName: map['storeName'],
      storeInfo: map['storeInfo'],
      storeAddress: map['storeAddress'],
      storeFollowers: map['storeFollowers'],
      storeRating: map['storeRating'],
      storeVisited: map['storeVisited'],
      storeStatus: map['storeStatus'],
    );
  }

  Map<String,dynamic> toMapWid(){
    return {
      'id':id,
      'accountId':accountId,
      'storeName':storeName,
      'storeInfo':storeInfo,
      'storeAddress':storeAddress,
      'storeFollowers':storeFollowers,
      'storeVisited':storeVisited,
      'storeStatus':storeStatus,
    };
  }

  Map<String,dynamic> toMapWOid(){
    return {
      'accountId':accountId,
      'storeName':storeName,
      'storeInfo':storeInfo,
      'storeAddress':storeAddress,
      'storeFollowers':storeFollowers,
      'storeVisited':storeVisited,
      'storeStatus':storeStatus,
    };
  }
}

class GioLocation{
  String id,storeId,longitude,latitude;

  GioLocation({this.id,this.latitude,this.longitude,this.storeId});

  factory GioLocation.toOject(Map<String,dynamic> map){
    return GioLocation(
      id: map['id'],
      longitude: map['longitude'],
      latitude: map['latitude'],
      storeId: map['storeId']
    );
  }

  Map<String,dynamic> toMapWid(){
    return {
      'id':id,
      'longitude':longitude,
      'latitude':latitude,
      'storeId':storeId,
    };
  }

  Map<String,dynamic> toMapWOid(){
    return {
      'longitude':longitude,
      'latitude':latitude,
      'storeId':storeId,
    };
  }
}

class StoreItem{
  String  id,itemName,itemPrice,itemDescription,itemStack,tagId,categoryId;
  String itemRating = '0.0',topupId = '1';

  StoreItem({
    this.id,
    this.categoryId,
    this.itemDescription,
    this.itemName,
    this.itemPrice,
    this.itemRating,
    this.itemStack,
    this.tagId,
    this.topupId,
  });

  factory StoreItem.toObject(Map<String,dynamic> map){
    return StoreItem(
      id: map['id'],
      categoryId: map['categoryId'],
      itemDescription: map['itemDescription'],
      itemName: map['itemName'],
      itemPrice: map['itemPrice'],
      itemRating: map['itemRating'],
      itemStack: map['itemStack'],
      tagId: map['tagId'],
      topupId: map['topupId'],
    );
  }

  Map<String,dynamic> toMapWid(){
    return {
      'id':id,
      'categoryId':categoryId,
      'itemDescription':itemDescription,
      'itemName':itemName,
      'itemPrice':itemPrice,
      'itemRating':itemRating,
      'itemStack':itemStack,
      'tagId':tagId,
      'topupId':topupId,
    };
  }

  Map<String,dynamic> toMapWOid(){
    return {
      'categoryId':categoryId,
      'itemDescription':itemDescription,
      'itemName':itemName,
      'itemPrice':itemPrice,
      'itemRating':itemRating,
      'itemStack':itemStack,
      'tagId':tagId,
      'topupId':topupId,
    };
  }

}

class ItemRating{
  String itemId,star_5,star_4,star_3,star_2,star_1;

  ItemRating({
    this.itemId,
    this.star_1,
    this.star_2,
    this.star_3,
    this.star_4,
    this.star_5,
  });

  factory ItemRating.toObject(Map<String,dynamic> map){
    return ItemRating(
      itemId: map['itemId'],
      star_1: map['star_1'],
      star_2: map['star_2'],
      star_3: map['star_3'],
      star_4: map['star_4'],
      star_5: map['star_4'],
    );
  }

  Map<String,dynamic> toMapWid(){
    return {
      'itemId':itemId,
      'star_1':star_1,
      'star_2':star_2,
      'star_3':star_3,
      'star_4':star_4,
      'star_5':star_5,
    };
  }

  Map<String,dynamic> toMapWOid(){
    return {
      'star_1':star_1,
      'star_2':star_2,
      'star_3':star_3,
      'star_4':star_4,
      'star_5':star_5,
    };
  }
}