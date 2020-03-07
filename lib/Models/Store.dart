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

  static toObject(Map<String,dynamic> map){
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

class StoreImage{
  int id;
  String images;
  StoreImage({this.id,this.images});

  static List<StoreImage> getImages(){
    return <StoreImage>[
      StoreImage(id: 1,images: 'assets/Store/StoreProfile.jpg'),
    ];
  }
}

class GioLocation{
  String id,storeId,longitude,latitude;

  GioLocation({this.id,this.latitude,this.longitude,this.storeId});

  static toOject(Map<String,dynamic> map){
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