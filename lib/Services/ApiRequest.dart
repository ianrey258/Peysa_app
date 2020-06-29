import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RequestUrl{

  static String get baseUrl{
    return 'http://192.168.10.2/Hanapyesa/';
  }
}

class ApiRequest{
  static final _baseurl = RequestUrl.baseUrl;

  static Future<bool> testConnection() async {
    var client = http.Client();
    try{
       var response = await client.post(_baseurl,body: {});
       return response.statusCode == 200 ? true : false;
    } catch(e){
      return false;
    } finally {
      client.close();
    }
  }

  static Future<String> uploadImageProfile(Map<String,dynamic> data) async {
    var client = http.Client();
    try {
      var response = await client.post(_baseurl+'ImageController/insertUserImage',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap[0]['id'];
    } finally {
      client.close();
    }
    
  }

  static Future<String> registerUser(Map<String,dynamic> data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'AccountController/insertUser',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap[0]['id'];
    } catch(e) {
      return 'null';
    } finally {
      client.close();
    }
  }

  static Future<String> registerAccount(Map<String,dynamic> data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'AccountController/insertUserAccount',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap[0]['id'];
    } catch(e) {
      return 'null';
    } finally {
      client.close();
    }
  }

  static Future<Map> registerStore(Map<String,dynamic> data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'StoreController/insertStore',body: data);
      print(response.body);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap[0];
    } catch(e) {
      return {};
    } finally {
      client.close();
    }
  }

  static Future<Map> uploadApprovalImage(Map<String,dynamic> data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'ImageController/insertStoreApprovalImage',body: data);
      print(response.body);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      print(datamap);
      return datamap;
    } catch(e) {
      return {};
    } finally {
      client.close();
    }
  }

  static Future<Map> insertStoreLocation(Map<String,dynamic> data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'StoreController/insertGioLocation',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } catch(e) {
      return {};
    } finally {
      client.close();
    }
  }

  static Future<Map> insertStoreImage(Map<String,dynamic> data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'ImageController/insertStoreImage',body: data);
      print(response.body);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } catch(e) {
      return {};
    } finally {
      client.close();
    }
  }

  static Future<Map> deleteData(Map<String,dynamic> data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'DeleteController/deleteTable',body: data);
      print(response.body);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } catch(e) {
      return {};
    } finally {
      client.close();
    }
  }

  static Future<Map> deleteItemImage(Map<String,dynamic> data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'ImageController/removeItemImage',body: data);
      print('on Deleting Image '+response.body);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } catch(e) {
      return {};
    } finally {
      client.close();
    }
  }

  static Future<Map> deleteStoreImage(Map<String,dynamic> data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'ImageController/removeStoreImage',body: data);
      print(response.body);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } catch(e) {
      return {};
    } finally {
      client.close();
    }
  }

  static Future<Map> deleteBidImage(Map<String,dynamic> data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'ImageController/removeBidImage',body: data);
      print(response.body);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } catch(e) {
      return {};
    } finally {
      client.close();
    }
  }

  static Future<Map> loginUser(Map<String,dynamic> data) async {
    var client = http.Client();
    List result = [];
    try{
      var response = await client.post(_baseurl+'AccountController/fetchUser',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      result.add({'result':'Unmatched Username or Password'});
      result.add(datamap);
      return result.asMap();
    } catch(e){
      result.add({'result':'Connection Error'});
      result.add({});
      return result.asMap();
    } finally {
      client.close();
    }
  }
  
  static Future<Map> getUserAccount(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'AccountController/fetchUserAccount',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> getStore(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'StoreController/fetchStore',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> getStores(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'StoreController/getStores',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> getUserImage(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'ImageController/fetchUserImage',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> getStoreAprovalImage(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'ImageController/fetchStoreApprovalImage',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> getStoreImage(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'ImageController/fetchStoreImage',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> getStoreLocation(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'StoreController/fetchGioLocation',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> getStoreItem(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'StoreController/fetchStoreItem',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> insertItemImage(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'ImageController/insertItemImage',body: data);
      print(response.body);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> getItemImage(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'ImageController/fetchItemImage',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> getStoreItemImage(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'ImageController/fetchStoreItemImages',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> insertItem(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'StoreController/insertItem',body: data);
      print(response.body);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> insertStoreItem(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'StoreController/insertStoreItem',body: data);
      print(response.body);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> fetchNotificationType(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'AccountController/fetchNotificationType',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> fetchStatusType(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'AccountController/fetchStatusType',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> getCategory(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'StoreController/fetchCategory',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> getTags(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'StoreController/fetchTags',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> updateNotification(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'AccountController/insertNotification',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> getNotification(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'AccountController/fetchNotification',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> getAddress(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'AccountController/fetchAddress',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> fetchUsersbyLocation(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'BidController/fetchUsersbyLocation',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> insertBidImage(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'ImageController/insertBidImage',body: data);
      print(response.body);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> fetchBidImage(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'ImageController/fetchBidImage',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> removeBidImage(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'ImageController/removeBidImage',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } catch(e){
      return {};
    } finally {
      client.close();
    }
  }

  static Future<Map> insertBidItemDetail(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'BidController/insertBidItemDetail',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> fetchBidItemDetail(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'BidController/fetchBidItemDetail',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> getBidItemDetails(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'BidController/getBidItemDetails',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> getOthersBidItemDetails(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'BidController/getOthersBidItemDetails',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> getBiddersSuggestedItem(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'BidController/getBiddersSuggestedItem',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> getBidItemImages(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'ImageController/getBidItemImages',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> insertBidItem(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'BidController/insertBidItem',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> fetchBidItems(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'BidController/fetchBidItems',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> fetchBidItem(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'BidController/fetchBidItem',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> getOtherBidItems(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'BidController/getOtherBidItems',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> insertBidItemManager(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'BidController/insertBidItemManager',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> fetchBidItemManager(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'BidController/fetchBidItemManager',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> insertBidder(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'BidController/insertBidder',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> fetchBidder(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'BidController/fetchBidder',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> fetchBidders(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'BidController/fetchBidders',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> insertBidChat(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'BidController/insertBidChat',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

  static Future<Map> fetchBidChats(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'BidController/fetchBidChats',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } finally {
      client.close();
    }
  }

}



