class Store{
  int id;
  String storeName,storeInfo,storeAddress,storeRating,storeFollowers,storeVisited;
  List<StoreImage> images;
  
  Store({this.id,
         this.storeName,
         this.storeAddress,
         this.storeFollowers,
         this.storeInfo,
         this.storeRating,
         this.storeVisited,
         this.images
        });
  
  static List<Store> getListStore(){
    return <Store>[
      Store(id:1,storeName: "Store 1",storeInfo: "asdasdasdasd",storeAddress: "asdasdasd",storeFollowers: "25",storeRating: "4.5",storeVisited: "25",images: StoreImage.getImages()),
      Store(id:2,storeName: "Store 2",storeInfo: "asdasdasdasd",storeAddress: "asdasdasd",storeFollowers: "132",storeRating: "4.0",storeVisited: "15",images: StoreImage.getImages()),
      Store(id:3,storeName: "Store 3",storeInfo: "asdasdasdasd",storeAddress: "asdasdasd",storeFollowers: "112",storeRating: "4.1",storeVisited: "26",images: StoreImage.getImages()),
      Store(id:4,storeName: "Store 4",storeInfo: "asdasdasdasd",storeAddress: "asdasdasd",storeFollowers: "23",storeRating: "3.0",storeVisited: "3",images: StoreImage.getImages()),
      Store(id:5,storeName: "Store 5",storeInfo: "asdasdasdasd",storeAddress: "asdasdasd",storeFollowers: "117",storeRating: "4.6",storeVisited: "28",images: StoreImage.getImages()),
      Store(id:6,storeName: "Store 6",storeInfo: "asdasdasdasd",storeAddress: "asdasdasd",storeFollowers: "56",storeRating: "3.9",storeVisited: "6",images: StoreImage.getImages()),
    ];
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