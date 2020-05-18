
class BidItem{
  String id,bidItem,budgetMoney,bidStatus,ownerLocId,datetime;

  BidItem({
    this.id,
    this.bidItem,
    this.budgetMoney,
    this.datetime,
    this.ownerLocId,
  });

  factory BidItem.toObject(Map<String,dynamic> map){
    return BidItem( 
      id: map['id'],
      bidItem: map['bidItem'],
      budgetMoney: map['budgetMoney'],
      datetime: map['datetime'],
      ownerLocId: map['ownerLocId'],
    );
  }

  Map<String,dynamic> toMapWid(){
    return {
      'id':this.id,
      'bidItem':this.bidItem,
      'budgetMoney':this.budgetMoney,
      'datetime':this.datetime,
      'ownerLocId':this.ownerLocId,
    };
  }

  Map<String,dynamic> toMapWOid(){
    return {
      'bidItem':this.bidItem,
      'budgetMoney':this.budgetMoney,
      'datetime':this.datetime,
      'ownerLocId':this.ownerLocId,
    };
  }

}

class Bidders{
  String id,bidItemId,accountId,suggestedItemId,isWinner,bidderLocId;

  Bidders({
    this.id,
    this.bidItemId,
    this.accountId,
    this.suggestedItemId,
    this.isWinner,
    this.bidderLocId,
  });

  factory Bidders.toObject(Map<String,dynamic> map){
    return Bidders(
      id: map['id'],
      bidItemId: map['bidItemId'],
      accountId: map['accountId'],
      suggestedItemId: map['suggestedItemId'],
      isWinner: map['isWinner'],
      bidderLocId: map['bidderLocId'],
    );
  }

  Map<String,dynamic> toMapWid(){
    return {
      'id':this.id,
      'bidItemId':this.bidItemId,
      'accountId':this.accountId,
      'suggestedItemId':this.suggestedItemId,
      'isWinner':this.isWinner,
      'bidderLocId':this.bidderLocId,
    };
  }

  Map<String,dynamic> toMapWOid(){
    return {
      'bidItemId':this.bidItemId,
      'accountId':this.accountId,
      'suggestedItemId':this.suggestedItemId,
      'isWinner':this.isWinner,
      'bidderLocId':this.bidderLocId,
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