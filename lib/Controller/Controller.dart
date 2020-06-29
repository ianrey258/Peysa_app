import 'package:pyesa_app/Database/DbUtil.dart';
import 'package:pyesa_app/Models/User.dart';
import 'package:pyesa_app/Models/Store.dart';
import 'package:pyesa_app/Models/Bid.dart';
import 'package:pyesa_app/Models/image.dart';
import 'package:pyesa_app/Services/ApiRequest.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

class HpController{
  
  static Future<bool> reApprove(ImageData image) async {
    Map accountUser = await DataController.getUserAccount();
    Map approval = await ApiRequest.uploadApprovalImage(image.toMapWidUpload());
    print(approval);
    Map store = await ApiRequest.getStore({'accountId':accountUser['id']});
    if(approval.isNotEmpty){
      await DbAccess.dropTable(DbUtil.Tbl_Store);
      await DbAccess.dropTable(DbUtil.Tbl_ApprovalImg);
      await DbAccess.insertData(store[0], DbUtil.Tbl_Store);
      await DbAccess.insertData(approval[0], DbUtil.Tbl_ApprovalImg);
    }
    return approval.isNotEmpty;
  }

  static Future<Map> loginUser(List text) async {
    DbUtil _dbUtil = DbUtil();
    UserCredential user = UserCredential(username: text[0].text,password: text[1].text,userType: 'User');
    Map result = await ApiRequest.loginUser(user.toMapWOid());
    _dbUtil.dropAllTable();
    if(result[1].isNotEmpty){
      Map<String,dynamic> mapConverted = result[1][0];
      await DbAccess.insertData(mapConverted,DbUtil.Tbl_User);
      await DataController.loadUserData();
      SharedPref.setLogin(true);
    }
    return result;
  }

  static Future<void> logout() async {
    DbUtil util = DbUtil();
    await util.dropAllTable();
    SharedPref.setLogin(false);
  }

  static Future<bool> isLogin() async {
    return DbAccess.getData(DbUtil.Tbl_User).then((value) => value.isNotEmpty);
  }

  static Future<bool> hasStore() async {
    Map accountUser = await DataController.getUserAccount();
    Map newStoreData = await ApiRequest.getStore({'accountId': accountUser['id']});
    if(newStoreData.isNotEmpty){
      await DbAccess.dropTable(DbUtil.Tbl_Store);
      await DbAccess.insertData(newStoreData[0], DbUtil.Tbl_Store);
    }
    return DbAccess.getDataList(DbUtil.Tbl_Store).then((value) => value.isNotEmpty);
  }

  static Future<bool> hasConnection() async { 
    return await ApiRequest.testConnection();
  }

}

class DataController{
  static Future<bool> registerUser(List text) async {
    UserCredential user = UserCredential(username: text[0].text,password: text[1].text,userType: 'User');
    String result = await ApiRequest.registerUser(user.toMapWOid());
    if(result != 'null'){
      UserAccount userAccount = UserAccount(userId: result,firstname: text[2].text,lastname: text[3].text,gender: text[6].text,
                              email: text[4].text,contactNo: text[5].text,zipCode: '0',accountStatus: '1');
      await ApiRequest.registerAccount(userAccount.toMapWOid());
    }
    return result != 'null' ? true : false;
  }

  static Future<bool> registerStore(List text,ImageData image) async {
    Map accountUser = await DataController.getUserAccount();
    Store store = Store(accountId: accountUser['id'],storeName: text[0].text,storeInfo: text[1].text,storeAddress: text[2].text,storeFollowers: '0',storeRating: '0',storeStatus: '15',storeVisited: '0');
    Map result = await ApiRequest.registerStore(store.toMapWOid());
    Map result2 = await ApiRequest.getStoreAprovalImage({'parentId':result['id']});
    image.parentId = result['id'];image.id = result2[0]['id'];
    Map result3 = await ApiRequest.uploadApprovalImage(image.toMapWidUpload());
    print(result3);
    if(result3.isNotEmpty){
      await DbAccess.insertData(result, DbUtil.Tbl_Store);
      await DbAccess.insertData(result3[0], DbUtil.Tbl_ApprovalImg);
    }
    return result3.isNotEmpty;
  }

  static Future<String> registerItem(List text,List images) async {
    Map data = StoreItem(itemName: text[0].text,itemStack: text[1].text,itemPrice: text[2].text,itemDescription: text[3].text,categoryId: text[4].text,tagId: text[5].text,itemRating: '0',topupId: '1').toMapWOid();
    Map store = await DbAccess.getData(DbUtil.Tbl_Store);
    Map item = {};
    if(await HpController.hasConnection()){
      item = await ApiRequest.insertItem(data);
      if(item.isNotEmpty){
        await DbAccess.dropTable(DbUtil.Tbl_StoreItem);
        await ApiRequest.insertStoreItem({'storeId':store['id'],'itemId':item[0]['id']});
        Map storeitem = await ApiRequest.getStoreItem({'id':store['id']});
        if(storeitem.isNotEmpty){storeitem.forEach((key, value) async {await DbAccess.insertData(value, DbUtil.Tbl_StoreItem);});}
      }
    }
    return await ImageController.addStoreItemImages(images,item[0]['id']);
  }

  static Future<String> removeItem(Map item,List images) async {
    Map store = await DbAccess.getData(DbUtil.Tbl_Store);
    if(await HpController.hasConnection()){
      for(int i=0;i<images.length;i++){
        await ApiRequest.deleteItemImage({'table':DbUtil.Tbl_ItemImg,'id':images[i].id,'filename':images[i].filename});
      }
      await ApiRequest.deleteData({'table':DbUtil.Tbl_StoreItem,'id':item['id']});
      await DbAccess.dropTable(DbUtil.Tbl_StoreItem);
      await DbAccess.dropTable(DbUtil.Tbl_ItemImg);
      Map storeitem = await ApiRequest.getStoreItem({'id':store['id']});
      Map storeItemImage = await ApiRequest.getStoreItemImage({'id':store['id']});
      if(storeitem.isNotEmpty){storeitem.forEach((key, value) async {await DbAccess.insertData(value, DbUtil.Tbl_StoreItem);});}
      if(storeItemImage.isNotEmpty){storeItemImage.forEach((key, value) async {await DbAccess.insertData(value, DbUtil.Tbl_ItemImg);});}
      return 'Item Deleted';
    }
    return 'Cannot Delete Item Due to Connection';
  }

  static Future<void> loadUserData() async {
    Map user = await DbAccess.getData(DbUtil.Tbl_User);
    Map userAccount = await ApiRequest.getUserAccount({'userId':user['id']});
    Map imageData = await ApiRequest.getUserImage({'parentId':userAccount[0]['id']});
    Map notification = await ApiRequest.getNotification({'userId':userAccount[0]['id']});
    Map store = await ApiRequest.getStore({'accountId':userAccount[0]['id']});
    if(userAccount.isNotEmpty){await DbAccess.insertData(userAccount[0],DbUtil.Tbl_UserAccount);}
    if(imageData.isNotEmpty){await DbAccess.insertData(imageData[0],DbUtil.Tbl_UserImg);}
    if(notification.isNotEmpty){await DbAccess.insertData(notification[0], DbUtil.Tbl_Notification);}
    await loadOtherData();
    if(store.isNotEmpty){await loadStoreData(store);}
  }

  static Future<void> loadStoreData(store) async {
    Map location = await ApiRequest.getStoreLocation({'storeId':store[0]['id']});
    Map storeImage = await ApiRequest.getStoreImage({'parentId':store[0]['id']});
    Map approvalImage = await ApiRequest.getStoreAprovalImage({'parentId':store[0]['id']});
    Map storeitem = await ApiRequest.getStoreItem({'id':store[0]['id']});
    Map storeItemImage = await ApiRequest.getStoreItemImage({'id':store[0]['id']});
    if(store.isNotEmpty){await DbAccess.insertData(store[0], DbUtil.Tbl_Store);}
    if(location.isNotEmpty){await DbAccess.insertData(location[0], DbUtil.Tbl_GioLocation);}
    if(approvalImage.isNotEmpty){await DbAccess.insertData(approvalImage[0], DbUtil.Tbl_ApprovalImg);}
    if(storeImage.isNotEmpty){storeImage.forEach((key, value) async {await DbAccess.insertData(value, DbUtil.Tbl_StoreImg);});}
    if(storeitem.isNotEmpty){storeitem.forEach((key, value) async {await DbAccess.insertData(value, DbUtil.Tbl_StoreItem);});}
    if(storeItemImage.isNotEmpty){storeItemImage.forEach((key, value) async {await DbAccess.insertData(value, DbUtil.Tbl_ItemImg);});}
  }

  static Future<void> loadOtherData() async {
    Map notificationType = await ApiRequest.fetchNotificationType({});
    Map statusType = await ApiRequest.fetchStatusType({});
    Map category = await ApiRequest.getCategory({});
    Map tags = await ApiRequest.getTags({});
    if(notificationType.isNotEmpty){notificationType.forEach((key, value) async {await DbAccess.insertData(value, DbUtil.Tbl_NotificationType);});}
    if(statusType.isNotEmpty){statusType.forEach((key, value) async {await DbAccess.insertData(value, DbUtil.Tbl_StatusType);});}
    if(category.isNotEmpty){category.forEach((key, value) async {await DbAccess.insertData(value, DbUtil.Tbl_ItemCategory);});}
    if(tags.isNotEmpty){tags.forEach((key, value) async {await DbAccess.insertData(value, DbUtil.Tbl_ItemTags);});}
  }

  static Future<Map> getItemById(id) async {
   List items = await DbAccess.getDataListWhere(DbUtil.Tbl_StoreItem, 'id='+id);
   return items[0];
  }

  static Future<List> getStoreItem() async {
    return await DbAccess.getDataList(DbUtil.Tbl_StoreItem);
  }

  static Future<Map<String,dynamic>> getUserCredential() async {
    return await DbAccess.getData(DbUtil.Tbl_User);
  }

  static Future<Map<String,dynamic>> getUserAccount() async {
    return await DbAccess.getData(DbUtil.Tbl_UserAccount);
  }

  static Future<Map<String,dynamic>> getStore() async {
    return await DbAccess.getData(DbUtil.Tbl_Store);
  }

  static Future<Map<String,dynamic>> getLocation() async {
    return await DbAccess.getData(DbUtil.Tbl_GioLocation);
  }

  static Future<List> getNotificationType() async {
    return await DbAccess.getDataList(DbUtil.Tbl_NotificationType);
  }

  static Future<List> getStatusType() async {
    return await DbAccess.getDataList(DbUtil.Tbl_StatusType);
  }

  static Future<List> getCategory() async {
    return await DbAccess.getDataListBy(DbUtil.Tbl_ItemCategory,'categoryName');
  }

  static Future<List> getTags() async {
    return await DbAccess.getDataListBy(DbUtil.Tbl_ItemTags,'tagName');
  }

  static Future<void> savingUserData(user,userAccount) async {
    await DbAccess.updateData(user,DbUtil.Tbl_User);
    await DbAccess.updateData(userAccount,DbUtil.Tbl_UserAccount);
    await ApiRequest.registerUser(user);
    await ApiRequest.registerAccount(userAccount);
  }

  static Future<void> savingStoreDetail(store,location) async {
    await DbAccess.updateData(store, DbUtil.Tbl_Store);
    await DbAccess.updateData(location, DbUtil.Tbl_GioLocation);
    await ApiRequest.insertStoreLocation(location);
    await ApiRequest.registerStore(store);
  }

  static Future<String> savingItemDetail(item) async {
    if(await HpController.hasConnection()){
      await ApiRequest.insertItem(item);
      await DbAccess.updateData(item, DbUtil.Tbl_StoreItem);
      return 'Item Updated';
    }
    return 'Cannot Update Item due to Connection';
  }
 
  static Future<List> getNotification() async {
    Map userAccount = await DbAccess.getData(DbUtil.Tbl_UserAccount);
    if(await ApiRequest.testConnection()){
      await DbAccess.dropTable(DbUtil.Tbl_Notification);
      Map notification = await ApiRequest.getNotification({'userId':userAccount['id']});
      notification.forEach((key, value) async {await DbAccess.insertData(value, DbUtil.Tbl_Notification);});
    }
    return await DbAccess.getDataList(DbUtil.Tbl_Notification);
  }

  static Future<void> updateNotification(data) async {
    if(await ApiRequest.testConnection()){
      await ApiRequest.updateNotification(data);
    }
  }

  static Future<Map> getAddresses() async {
    if(await HpController.hasConnection()) return await ApiRequest.getAddress({});
    return {};
  }

  static Future<String> sendingRequest(images, data) async {
    String date = DateTime.now().year.toString()+"-"+DateTime.now().month.toString()+"-"+DateTime.now().day.toString();
    var id = await DbAccess.getData(DbUtil.Tbl_UserAccount);
    var pplDeduction = data[3].text == id['zipCode'] ? 1 : 0;
    
    if(!await HpController.hasConnection()) return 'No Connection';
    if((await ApiRequest.getUserAccount({'zipCode':data[3].text})).isEmpty || (await ApiRequest.getUserAccount({'zipCode':data[3].text})).length - pplDeduction <= 0) return 'Cant Send Due to No Users on That Location';
    
    var resultItemDetail = await ApiRequest.insertBidItemDetail(BidItemDetail(itemName: data[0].text,itemPriceorBudget: data[2].text,description: data[1].text).toMapWOid());
    var resultItem = await ApiRequest.insertBidItem(BidItem(bidItem: resultItemDetail[0]['id'],datetime: date,sendLocation: data[3].text).toMapWOid(),);
    await ApiRequest.insertBidItemManager(BidItemManager(ownerId: id['id'],bidItemId: resultItem[0]['id'],bidStatus: '5').toMap());
    var pplsended = await distributeRequest(resultItem[0]['id'], data,resultItemDetail[0]['id'],date);
    if(images.isNotEmpty)await ImageController.uploadBidImage(resultItem[0]['bidItem'], images);
    return pplsended;
  }

  static Future<String> distributeRequest(bidId,data,itemId,date) async {
    num ppl = 0;
    var user = await DbAccess.getData(DbUtil.Tbl_UserAccount);
    var people =  await ApiRequest.fetchUsersbyLocation({'zipCode':data[3].text});
    if(people.isNotEmpty){people.forEach((key, value) async {
      if(value['id'] != user['id']){
        await ApiRequest.updateNotification(UserNotification(userId: value['id'],message: 'Hey Somebody is looking for '+data[0].text+' on your Location with a Budget of P'+data[2].text,dateRecieved: date,notificationType: '4',status: '10').toMapWOid());
        await ApiRequest.insertBidder(Bidders(bidItemId: bidId,accountId: value['id'],suggestedItemId: itemId,requestStatus: '12').toMapWOid());
      }
    });}
    ppl = data[3].text == user['zipCode'] ? people.length - 1 : people.length;
    return ''+ppl.toString();
  }

  static Future<String> removeRequest(bidId) async {
    var hasConnection = await HpController.hasConnection();
    if(hasConnection){
      await ImageController.removeBidImages(bidId);
    }
    return hasConnection.toString();
  }

  static Future<List> getRequestItems() async {
    Map user = await DbAccess.getData(DbUtil.Tbl_UserAccount);
    Map bidItem = {};
    List itemManager = [],itemImage = [];
    bool hasConnection = await HpController.hasConnection();
    if(hasConnection){
      bidItem = await ApiRequest.fetchBidItems({'ownerId':user['id']});
      try{
        if(bidItem.isNotEmpty){
          for(int i=0;i<bidItem.length;i++){
            itemManager.add((await ApiRequest.fetchBidItemManager({'bidItemId':bidItem[i]['id']}))[0]);
            itemImage.add((await ApiRequest.fetchBidImage({'parentId':bidItem[i]['bidItem']}))[0] ?? {});
          }
        }
      }catch(e){
        await getRequestItems();
      }
    }
    return [bidItem,itemManager,itemImage,hasConnection];
  }

  static Future<List> getRequestedItems() async {
    Map user = await DbAccess.getData(DbUtil.Tbl_UserAccount);
    Map otherBidItem = {};
    List itemDetail = [],itemImage = [],bidItem = [],bidManager = [],userDetail = [];
    bool hasConnection = await HpController.hasConnection();
     if(hasConnection){
      otherBidItem = await ApiRequest.getOtherBidItems({'ownerId':user['id']});
      try{
        if(otherBidItem.isNotEmpty){
          for(int i=0;i<otherBidItem.length;i++){
            Map bidItemResult = (await ApiRequest.fetchBidItem({'id':otherBidItem[i]['bidItemId']}))[0];
            bidItem.add(bidItemResult);
            itemDetail.add((await ApiRequest.fetchBidItemDetail({'id':bidItemResult['bidItem']}))[0]);
            itemImage.add((await ApiRequest.fetchBidImage({'parentId':bidItemResult['bidItem']}))[0] ?? {});
            Map bidManagerResult = (await ApiRequest.fetchBidItemManager({'bidItemId':otherBidItem[i]['bidItemId']}))[0];
            bidManager.add(bidManagerResult);
            userDetail.add((await ApiRequest.getUserAccount({'id':bidManagerResult['ownerId']}))[0]);
          }
        }
      } catch(e){
        await getRequestedItems();
      }
      
    }
    return [otherBidItem,bidItem,itemDetail,itemImage,bidManager,userDetail,hasConnection];
  }

  static Future<Map> getItemDetails(itemId) async {
    return await ApiRequest.fetchBidItemDetail({'id':itemId});
  }

  static Future<Map> getBidders(itemId) async {
    if(await HpController.hasConnection()) return await ApiRequest.fetchBidder({'bidItemId':itemId,'requestStatus': '16'});
    return {};
  }

  static Future<String> requestAcceptUpdate(bidderId,BidItemDetail feedbackItem,List images,[method = 'insert']) async{
    if(!await HpController.hasConnection()) return null;
    if(method == 'insert'){
      Map item = (await ApiRequest.insertBidItemDetail(feedbackItem.toMapWOid()))[0];
      if(images.isNotEmpty) await ImageController.uploadBidImage(item['id'], images);
      await ApiRequest.insertBidder({'id':bidderId,'suggestedItemId':item['id'],'requestStatus':'16'});
      return 'Feedback Sent';
    } else {
      Map item = (await ApiRequest.insertBidItemDetail(feedbackItem.toMapWid()))[0];
      if(images.isNotEmpty) await ImageController.uploadBidImage(item['id'], images);
      return 'Feedback Detail Update';
    }
  }

  static Future<List> getBidderDetails(userId,itemId) async {
    if(!await HpController.hasConnection()) return [];
    Map user = (await ApiRequest.getUserAccount({'id':userId}))[0];
    Map item = (await ApiRequest.fetchBidItemDetail({'id':itemId}))[0];
    Map userImage = await ApiRequest.getUserImage({'parentId':userId});
    Map itemImage = await ApiRequest.fetchBidImage({'parentId':itemId});
    return [user,item,userImage,itemImage];
  }

  static Future<String> requestDecline(bidderId) async {
    if(!await HpController.hasConnection()) return null;
    await ApiRequest.insertBidder({'id':bidderId,'requestStatus':'17'});
    return 'Request Decline';
  }

  static Future<Map> insertBidderMessage(BidChat data,{senderType = true}) async {
    if(!await HpController.hasConnection())return {'Connection':'false'};
    Map yourId = await DbAccess.getData(DbUtil.Tbl_UserAccount);
    senderType ? data.senderId = yourId['id'] : data.recieverId = yourId['id'];
    return await ApiRequest.insertBidChat(data.toMapWOid());
  }

  static Future<Map> getBidderMessage(bidId,otherId,{senderType = true}) async {
    if(!await HpController.hasConnection())return {'Connection':'false'};
    Map yourId = await DbAccess.getData(DbUtil.Tbl_UserAccount);
    if(senderType)return await ApiRequest.fetchBidChats({'bidItemId': bidId,'recieverId':yourId['id'],'senderId':otherId});
    return await ApiRequest.fetchBidChats({'bidItemId': bidId,'recieverId':otherId,'senderId':yourId['id']});
  }

  static Future<Map> getStores() async {
    Map myStore = await DbAccess.getData(DbUtil.Tbl_Store);
    if(await HpController.hasConnection()){
      if(myStore.isNotEmpty)return await ApiRequest.getStores({'id':myStore['id']});
      return await ApiRequest.getStores({'id':'0'});
    }
    return {'id':'0'};
  }

  static Future<List> getStoreDetails(id) async {
    Map storeInfo = (await ApiRequest.getStore({'id':id}))[0];
    Map storeImage = (await ApiRequest.getStoreImage({'parentId':id}))[0];
    List<Map> storeItems = [];
    List<Map> storeItemsImage = [];
    Map items = await ApiRequest.getStoreItem({'storeId':id});
    for(int i=0;i<items.length;i++){
        if(i == 5) break;
        storeItems.add(items[i]);
        storeItemsImage.add((await ApiRequest.getItemImage({'parentId':items[i]['id']}))[0]);
    }
    return [storeInfo,storeImage,storeItems,storeItemsImage];
  }

  static Future<List> getFullStoreDetails(id) async {
    Map storeInfo = (await ApiRequest.getStore({'id':id}))[0];
    Map storeImage = (await ApiRequest.getStoreImage({'parentId':id}))[0];
    List<Map> storeItems = [];
    List<Map> storeItemsImage = [];
    Map items = await ApiRequest.getStoreItem({'storeId':id});
    for(int i=0;i<items.length;i++){
        storeItems.add(items[i]);
        storeItemsImage.add((await ApiRequest.getItemImage({'parentId':items[i]['id']}))[0]);
    }
    return [storeInfo,storeImage,storeItems,storeItemsImage];
  }

}

class ImageController{
  static String userImageNetLocation = RequestUrl.baseUrl+'assets/UserImage/';
  static String storeImageNetLocation = RequestUrl.baseUrl+'assets/StoreImage/';
  static String itemImageNetLocation = RequestUrl.baseUrl+'assets/ItemImage/';

  static Future<void> savingProfileImage(imageData4db,imageData4Api) async {
    await ApiRequest.uploadImageProfile(imageData4Api);
    await DbAccess.updateData(imageData4db,DbUtil.Tbl_UserImg);
  }

  static Future<List> getItemImg(id) async {
    return await DbAccess.getDataListWhere(DbUtil.Tbl_ItemImg,'parentId = '+id);
  }

  static Future<List> getItemImgs() async {
    return await DbAccess.getDataList(DbUtil.Tbl_ItemImg);
  }

  static Future<Map> getItemImages(id) async {
    return await ApiRequest.getItemImage({'parentId':id});
  }

  static Future<Map<String,dynamic>> getUserImage() async {
    return await DbAccess.getData(DbUtil.Tbl_UserImg);
  }

  static Future<Map<String,dynamic>> getApprovalImage() async {
    return await DbAccess.getData(DbUtil.Tbl_ApprovalImg);
  }

  static Future<List> getStoreImages() async {
    return await DbAccess.getDataList(DbUtil.Tbl_StoreImg);
  }

  static Future<String> addStoreImage(data) async {
    Map store = await DbAccess.getData(DbUtil.Tbl_Store);
    if(await HpController.hasConnection()){
      await ApiRequest.insertStoreImage(data);
      Map images = await ApiRequest.getStoreImage({'parentId':store['id']});
      await DbAccess.dropTable(DbUtil.Tbl_StoreImg);
      if(images.isNotEmpty){
        for(int i=0;i<images.length;i++){
        await DbAccess.insertData(images[i], DbUtil.Tbl_StoreImg);
        }
      }
      return 'Image Uploaded';
    }
    return 'Cannot Upload Image due to Connection';
  }

  static Future<String> removeStoreImage(ImageData image) async {
    Map store = await DbAccess.getData(DbUtil.Tbl_Store);
    if(await HpController.hasConnection()){
      await ApiRequest.deleteStoreImage({'table':'store_img','id':image.id,'filename':image.filename});
      Map storeImage = await ApiRequest.getStoreImage({'parentId':store['id']});
      await DbAccess.dropTable(DbUtil.Tbl_StoreImg);
      if(storeImage.isNotEmpty){
        for(int i=0;i<storeImage.length;i++){
        await DbAccess.insertData(storeImage[i], DbUtil.Tbl_StoreImg);
        }
      }
      return 'Image Deleted';
    }
    return 'Cannot delete Image due to Connection';
  }

  static Future<String> addStoreItemImages(List<ImageData> data,id) async {
    Map store = await DbAccess.getData(DbUtil.Tbl_Store);
    if(await HpController.hasConnection()){
      for(int i =0;i<data.length;i++){
        data[i].parentId = id;
        await ApiRequest.insertItemImage(data[i].toMapWOidUpload());
      }
      Future.delayed(Duration(seconds: 3));
      Map storeItemImage = await ApiRequest.getStoreItemImage({'id':store['id']});
      if(storeItemImage.isNotEmpty){
        await DbAccess.dropTable(DbUtil.Tbl_ItemImg);
        if(storeItemImage.isNotEmpty){storeItemImage.forEach((key, value) async {await DbAccess.insertData(value, DbUtil.Tbl_ItemImg);});}
      }
      return 'Item Registered';
    }
    return 'Cannot Registered Item due to Connection';
  }

  static Future<String> addStoreItemImage(ImageData image) async {
    Map store = await DbAccess.getData(DbUtil.Tbl_Store);
    if(await HpController.hasConnection()){
      var result = await ApiRequest.insertItemImage(image.toMapWOidUpload());
      if(result.isNotEmpty){
        var images = await ApiRequest.getStoreItemImage({'id':store['id']});
        if(images.isNotEmpty){
          DbAccess.dropTable(DbUtil.Tbl_ItemImg);
          images.forEach((key, value) async {await DbAccess.insertData(value, DbUtil.Tbl_ItemImg);});
          return 'Image Added';
        }
      }
    }
    return 'Cannot update Item Image due to Connection';
  }

  static Future<String> removeStoreItemImage(ImageData image) async {
    Map store = await DbAccess.getData(DbUtil.Tbl_Store);
    if(await HpController.hasConnection()){
      await ApiRequest.deleteItemImage({'table':'item_img','id':image.id,'filename':image.filename});
      Map storeItemImage = await ApiRequest.getStoreItemImage({'id':store['id']});
      if(storeItemImage.isNotEmpty){
        await DbAccess.dropTable(DbUtil.Tbl_ItemImg);
        storeItemImage.forEach((key, value) async {await DbAccess.insertData(value, DbUtil.Tbl_ItemImg);});
        return 'Image Deleted';
      }
    }
    return 'Cannot delete Image due to Connection';
  }

  static Future<String> uploadBidImage(id,List<File> images) async {
    images.forEach((element) async { 
      await ApiRequest.insertBidImage(ImageData(parentId: id,filename: Random().nextInt(1000000).toString()+'_'+element.path.split('/').last,binaryfile: base64Encode(element.readAsBytesSync())).toMapWOidUpload());
    });
    return null;
  }

  static Future<String> removeBidImage(data) async {
    if(!await HpController.hasConnection()) return null;
    await ApiRequest.removeBidImage({'table' : 'bid_item_img','id': data['id'],'filename': data['filename']});
    return 'Image Remove';
  }

  static Future<String> removeBidImages(String id) async {
    // var bidders = await ApiRequest.fetchBidder({'bidItemId':id});
    // bidders.forEach((key, value) async {
    //   var bidderitems = await ApiRequest.fetchBidImage({'parentId':value['suggestedItemId']});
    //   bidderitems.forEach((key, value) {ApiRequest.deleteBidImage({'id':value['id'],'table':DbUtil.Tbl_BidItemImg});});
    // });
    // var bidItem = await ApiRequest.fetchBidItem({'id':id});
    // var bidderOwnerImg = await ApiRequest.fetchBidImage({'pare':bidItem[0]['bidItem']});
    // bidderOwnerImg.forEach((key, value) { 
    //   ApiRequest.deleteBidImage({'id':value['id'],'table':DbUtil.Tbl_BidItemImg});
    // });
    return null;
  }

  static Future<Map> getBidImages(itemId) async {
    return await ApiRequest.fetchBidImage({'parentId':itemId});
  }

  static Future<String> uploadRequestImage(){
    return null;
  }

  static Future<void> uploadImageProfile(data) async {

  }

  static String  getUserNetImage(filename){
    return userImageNetLocation+filename;
  }

  static String  getStoreNetImage(filename){
    return storeImageNetLocation+filename;
  }

  static String  getItemNetImage(filename){
    return itemImageNetLocation+filename;
  }

  static Future<File> imageCompression(File file) async {
    String  tempfileDir = await TempDirectory.baseDirectory;
    print(tempfileDir);
    return file;
    //return await FlutterImageCompress.compressAndGetFile(baseDir.path, file.path,minWidth: 120,minHeight: 120,quality: 50);
  }

}
//unused
class TempDirectory{

  static Future<String> get baseDirectory async {
    Directory baseDir = await getApplicationDocumentsDirectory();
    return baseDir.path;
  }

  static Future<String> get tempDirCompression async {
    Directory tempDir = Directory('$baseDirectory/tempCompression');
    if(await tempDir.exists()){
      return tempDir.path;
    } else {
      return await Directory('$baseDirectory/tempCompression').create(recursive: true).then((value) => value.path);
    }
  }

  static Future<void> deleteCompressionDir() async {
    Directory dir = Directory(await tempDirCompression);
    if(await dir.exists()){
      dir.delete(recursive: true);
    }
  }

}

class SharedPref{
   
  static Future<bool> isLogin() async {
    SharedPreferences sf = await  SharedPreferences.getInstance();
    if(!sf.containsKey('isLogin')){
      setLogin(false);
      return false;
    }
    return sf.getBool('isLogin');
  }
  static setLogin(isLog) async {
    SharedPreferences sf = await  SharedPreferences.getInstance();
    sf.setBool('isLogin', isLog);
  }
  
}

class LoadingScreen {

  static Future<Widget> showLoading(BuildContext context,msg) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      child: AlertDialog(
        elevation: 5,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(15),
              child: Text(msg),
            ),
            Container(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      )
    );
  }

  static Future<bool> showResultDialog(BuildContext context,String msg,double fsize){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          elevation: 5.0,
          content: Container(
            height: MediaQuery.of(context).size.height*.05,
            child: Center(child: Text(msg,style: TextStyle(fontSize: fsize),))
            ),
          actions: <Widget>[
            FlatButton(
              child: Container(child: Text('Ok'),),
              onPressed: (){Navigator.pop(context);},
            ),
          ],
        );
      }
    );
  }
}