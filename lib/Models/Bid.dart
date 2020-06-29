
class BidItem{
  String id,bidItem,sendLocation,datetime;

  BidItem({
    this.id,
    this.bidItem,
    this.datetime,
    this.sendLocation,
  });

  factory BidItem.toObject(Map<String,dynamic> map){
    return BidItem( 
      id: map['id'],
      bidItem: map['bidItem'],
      datetime: map['datetime'],
      sendLocation: map['sendLocation'],
    );
  }

  Map<String,dynamic> toMapWid(){
    return {
      'id':this.id,
      'bidItem':this.bidItem,
      'datetime':this.datetime,
      'sendLocation':this.sendLocation,
    };
  }

  Map<String,dynamic> toMapWOid(){
    return {
      'bidItem':this.bidItem,
      'datetime':this.datetime,
      'sendLocation':this.sendLocation,
    };
  }

}

class Bidders{
  String id,bidItemId,accountId,suggestedItemId,requestStatus;

  Bidders({
    this.id,
    this.bidItemId,
    this.accountId,
    this.suggestedItemId,
    this.requestStatus,
  });

  factory Bidders.toObject(Map<String,dynamic> map){
    return Bidders(
      id: map['id'],
      bidItemId: map['bidItemId'],
      accountId: map['accountId'],
      suggestedItemId: map['suggestedItemId'],
      requestStatus: map['requestStatus'],
    );
  }

  Map<String,dynamic> toMapWid(){
    return {
      'id':this.id,
      'bidItemId':this.bidItemId,
      'accountId':this.accountId,
      'suggestedItemId':this.suggestedItemId,
      'requestStatus':this.requestStatus,
    };
  }

  Map<String,dynamic> toMapWOid(){
    return {
      'bidItemId':this.bidItemId,
      'accountId':this.accountId,
      'suggestedItemId':this.suggestedItemId,
      'requestStatus':this.requestStatus,
    };
  }

}

class BidChat{
  String id,bidItemId,recieverId,senderId,message,datetime,messageType,status;

  BidChat({
    this.id,
    this.bidItemId,
    this.recieverId,
    this.senderId,
    this.message,
    this.datetime,
    this.messageType,
    this.status,
  });

  factory BidChat.toObject(Map<String,dynamic> map){
    return BidChat(
      id: map['id'],
      bidItemId: map['bidItemId'],
      recieverId: map['recieverId'],
      senderId: map['senderId'],
      message: map['message'],
      datetime: map['datetime'],
      messageType: map['messageType'],
      status: map['status'],
    );
  }

  Map<String,dynamic> toMapWid(){
    return {
      'id':this.id,
      'bidItemId':this.bidItemId,
      'recieverId':this.recieverId,
      'senderId':this.senderId,
      'message':this.message,
      'datetime':this.datetime,
      'messageType':this.messageType,
      'status':this.status,
    };
  }

  Map<String,dynamic> toMapWOid(){
    return {
      'bidItemId':this.bidItemId,
      'recieverId':this.recieverId,
      'senderId':this.senderId,
      'message':this.message,
      'datetime':this.datetime,
      'messageType':this.messageType,
      'status':this.status,
    };
  }

}

class BidItemDetail{
  String id,itemName,itemPriceorBudget,description;

  BidItemDetail({
    this.id,
    this.itemName,
    this.description,
    this.itemPriceorBudget
  });

  factory BidItemDetail.toObject(Map<String,dynamic> map){
    return BidItemDetail(
      id: map['id'],
      itemName: map['itemName'],
      description: map['description'],
      itemPriceorBudget: map['itemPriceorBudget'],
    );
  }

  Map<String,dynamic> toMapWid(){
    return {
      'id':this.id,
      'itemName':this.itemName,
      'description':this.description,
      'itemPriceorBudget':this.itemPriceorBudget,
    };
  }

  Map<String,dynamic> toMapWOid(){
    return {
      'itemName':this.itemName,
      'description':this.description,
      'itemPriceorBudget':this.itemPriceorBudget,
    };
  }
}

class BidItemManager{
  String ownerId,bidItemId,bidStatus;

  BidItemManager({
    this.ownerId,
    this.bidItemId,
    this.bidStatus,
  });

  factory BidItemManager.toObject(Map<String,dynamic> map){
    return BidItemManager(
      ownerId: map['ownerId'],
      bidItemId: map['bidItemId'],
      bidStatus: map['bidStatus'],
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'ownerId':this.ownerId,
      'bidItemId':this.bidItemId,
      'bidStatus':this.bidStatus,
    };
  }

}

class SenderType{
  bool senderType;

  SenderType({this.senderType});

  factory SenderType.toObject(Map<String,dynamic> data) => SenderType(senderType: data['senderType']);
}