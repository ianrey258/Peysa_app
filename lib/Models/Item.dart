class Item{
  int id,itemStack;
  String itemName,itemDescription,itemTag,itemCategory;
  double topUp,itemPrice,itemRating;
  List<Itemimg> images;

  Item({this.id,
        this.itemName,
        this.itemPrice,
        this.itemDescription,
        this.itemStack,
        this.itemTag,
        this.itemCategory,
        this.topUp,
        this.images,
        this.itemRating
        });
  
  static List<Item> getItemList(){
    return <Item>[
    Item(id: 1,itemName: "Item1",itemPrice: 50.00,itemDescription: "asdasdasd",itemStack: 20,itemTag: "asdasd",itemCategory: "asdasd",images: Itemimg.getImage(),itemRating: 4.5),
    Item(id: 2,itemName: "Item2",itemPrice: 123.00,itemDescription: "asdasdasd",itemStack: 21,itemTag: "asdasd",itemCategory: "asdasd",images: Itemimg.getImage(),itemRating: 4.1),
    Item(id: 3,itemName: "Item3",itemPrice: 410.00,itemDescription: "asdasdasd",itemStack: 14,itemTag: "asdasd",itemCategory: "asdasd",images: Itemimg.getImage(),itemRating: 5.0),
    Item(id: 4,itemName: "Item4",itemPrice: 520.00,itemDescription: "asdasdasd",itemStack: 11,itemTag: "asdasd",itemCategory: "asdasd",images: Itemimg.getImage(),itemRating: 4.3),
    Item(id: 5,itemName: "Item5",itemPrice: 550.00,itemDescription: "asdasdasd",itemStack: 4,itemTag: "asdasd",itemCategory: "asdasd",images: Itemimg.getImage(),itemRating: 3.9),
    Item(id: 6,itemName: "Item6",itemPrice: 5690.00,itemDescription: "asdasdasd",itemStack: 2,itemTag: "asdasd",itemCategory: "asdasd",images: Itemimg.getImage(),itemRating: 4.8),
    ];
  }

}

class Itemimg{
  int id;
  String itemImg;
  Itemimg({this.id,this.itemImg});

  static List<Itemimg> getImage(){
    return <Itemimg>[
      Itemimg(id: 1,itemImg: "assets/Inventory/Ram.jpg"),
      Itemimg(id: 2,itemImg: "assets/Inventory/HDD_Hp.jpg"),
      Itemimg(id: 3,itemImg: "assets/Inventory/Athlon_200GE.jpg"),
      Itemimg(id: 4,itemImg: "assets/Purchased/DC_Motor.jpg"),
      Itemimg(id: 5,itemImg: "assets/Purchased/GearStick.jpg"),
      Itemimg(id: 6,itemImg: "assets/Purchased/MotorController.jpg"),
      Itemimg(id: 7,itemImg: "assets/Purchased/WindShield.jpg"),
      Itemimg(id: 8,itemImg: "assets/Purchased/Wiper.jpg"),
    ];
  }
}

