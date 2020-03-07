import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RequestUrl{

  static String get baseUrl{
    return 'http://192.168.1.2/Hanapyesa/';
  }
}

class PostRequest{
  static final _baseurl = RequestUrl.baseUrl;

  static Future<bool> testConnection() async {
    var client = http.Client();
    try{
       var response = await client.post(_baseurl,body: {});
       if(response.statusCode == 200){
         return true;
       } else {
         return false;
       }
    } catch(e){
      return false;
    } finally {
      client.close();
    }
  }

  static Future<String> uploadImageProfile(Map<String,dynamic> data) async {
    var client = http.Client();
    try {
      var response = await client.post(_baseurl+'AccountController/insertUserImage',body: data);
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
      var response = await client.post(_baseurl+'StoreController/insertStoreApprovalImage',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
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
      var response = await client.post(_baseurl+'StoreController/insertStoreImage',body: data);
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
      var response = await client.post(_baseurl+'StoreController/removeStoreImage',body: data);
      List jsonParse = json.decode(response.body);
      Map datamap = jsonParse.asMap();
      return datamap;
    } catch(e) {
      return {};
    } finally {
      client.close();
    }
  }

}

class GetRequest{
  static final _baseurl = RequestUrl.baseUrl;

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

  static Future<Map> getUserImage(data) async {
    var client = http.Client();
    try{
      var response = await client.post(_baseurl+'AccountController/fetchUserImage',body: data);
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
      var response = await client.post(_baseurl+'StoreController/fetchStoreApprovalImage',body: data);
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
      var response = await client.post(_baseurl+'StoreController/fetchStoreImage',body: data);
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
}



