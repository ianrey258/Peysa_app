import 'package:pyesa_app/Database/DbUtil.dart';
import 'package:pyesa_app/Models/User.dart';
import 'package:pyesa_app/Models/Store.dart';
import 'package:pyesa_app/Requesthttp/ApiRequest.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';

class HpController{
  
  static Future<bool> registerUser(List text) async {
    UserCredential user = UserCredential(username: text[0].text,password: text[1].text,userType: 'User');
    String result = await PostRequest.registerUser(user.toMapWOid());
    if(result != 'null'){
      UserAccount userAccount = UserAccount(userId: result,firstname: text[2].text,lastname: text[3].text,gender: text[6].text,
                              email: text[4].text,contactNo: text[5].text,accountStatus: '1');
      await PostRequest.registerAccount(userAccount.toMapWOid());
    }
    return result != 'null' ? true : false;
  }

  static Future<bool> registerStore(List text,UserImage image) async {
    Map accountUser = await DataController.getUserAccount();
    Store store = Store(accountId: accountUser['id'],storeName: text[0].text,storeInfo: text[1].text,storeAddress: text[2].text,storeFollowers: '0',storeRating: '0',storeStatus: '15',storeVisited: '0');
    Map result = await PostRequest.registerStore(store.toMapWOid());
    Map result2 = await GetRequest.getStoreAprovalImage({'parentId':result['id']});
    image.parentId = result['id'];image.id = result2[0]['id'];
    print(image.toMapWidUpload());
    Map result3 = await PostRequest.uploadApprovalImage(image.toMapWidUpload());
    print(result3);
    if(result3.isNotEmpty){await DbAccess.insertData(result, DbUtil.Tbl_Store);}
    return result3.isNotEmpty;
  }

  static Future<Map> loginUser(List text) async {
    DbUtil _dbUtil = DbUtil();
    UserCredential user = UserCredential(username: text[0].text,password: text[1].text,userType: 'User');
    Map result = await GetRequest.loginUser(user.toMapWOid());
    _dbUtil.dropAllTable();
    print(result);
    print(result[1]);
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
    Map newStoreData = await GetRequest.getStore({'accountId': accountUser['id']});
    print(newStoreData);
    if(newStoreData.isNotEmpty){
      await DbAccess.dropTable(DbUtil.Tbl_Store);
      await DbAccess.insertData(newStoreData[0], DbUtil.Tbl_Store);
    }
    print(await DataController.getStore());
    return DbAccess.getDataList(DbUtil.Tbl_Store).then((value) => value.isNotEmpty);
  }

  static Future<bool> hasConnection() async { 
    return await PostRequest.testConnection();
  }

}

class DataController{

  static Future<void> loadUserData() async {
    Map user = await DbAccess.getData(DbUtil.Tbl_User);
    Map userAccount = await GetRequest.getUserAccount({'userId':user['id']});
    Map userImage = await GetRequest.getUserImage({'parentId':userAccount[0]['id']});
    Map store = await GetRequest.getStore({'accountId':userAccount[0]['id']});
    Map location = await GetRequest.getStoreLocation({'storeId':store[0]['id']});
    Map storeImage = await GetRequest.getStoreImage({'parentId':store[0]['id']});
    if(userAccount.isNotEmpty){await DbAccess.insertData(userAccount[0],DbUtil.Tbl_UserAccount);}
    if(userImage.isNotEmpty){await DbAccess.insertData(userImage[0],DbUtil.Tbl_UserImg);}
    if(store.isNotEmpty){await DbAccess.insertData(store[0], DbUtil.Tbl_Store);}
    if(location.isNotEmpty){await DbAccess.insertData(location[0], DbUtil.Tbl_GioLocation);}
    if(storeImage.isNotEmpty){
      for(int i=0;i<storeImage.length;i++){
        await DbAccess.insertData(store[i], DbUtil.Tbl_StoreImg);
      }
    }
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

  static Future<void> savingUserData(user,userAccount) async {
    await DbAccess.updateData(user,DbUtil.Tbl_User);
    await DbAccess.updateData(userAccount,DbUtil.Tbl_UserAccount);
    await PostRequest.registerUser(user);
    await PostRequest.registerAccount(userAccount);
  }

  static Future<void> savingStoreDetail(store,location) async {
    await DbAccess.updateData(store, DbUtil.Tbl_Store);
    await DbAccess.updateData(store, DbUtil.Tbl_GioLocation);
    await PostRequest.deleteStoreImage(location);
    await PostRequest.registerStore(store);
  }

}

class ImageController{
  static String userImageNetLocation = RequestUrl.baseUrl+'assets/UserImage/';

  static Future<void> savingProfileImage(userImage4db,userImage4Api) async {
    await PostRequest.uploadImageProfile(userImage4Api);
    await DbAccess.updateData(userImage4db,DbUtil.Tbl_UserImg);
  }

  static Future<Map<String,dynamic>> getUserImage() async {
    return await DbAccess.getData(DbUtil.Tbl_UserImg);
  }

  static Future<List> getStoreImages() async {
    return await DbAccess.getDataList(DbUtil.Tbl_StoreImg);
  }

  static Future<String> addStoreImage(data) async {
    if(await HpController.hasConnection()){
      Map images= await PostRequest.insertStoreImage(data);
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

  static Future<String> removeStoreImage(UserImage image) async {
    Map store = await DbAccess.getData(DbUtil.Tbl_Store);
    if(await HpController.hasConnection()){
      await PostRequest.deleteStoreImage({'table':'$DbUtil.Tbl_StoreImg','id':image.id,'filename':image.filename});
      Map storeImage = await GetRequest.getStoreImage({'parentId':store['id']});
      await DbAccess.dropTable(DbUtil.Tbl_StoreImg);
      if(storeImage.isNotEmpty){
        await DbAccess.insertData(storeImage, DbUtil.Tbl_StoreImg);
      }
      return 'Image Deleted';
    }
    return 'Cannot delete Image due to Connection';
  }

  static Future<void> uploadImageProfile(data) async {

  }

  static String  getUserNetImage(filename){
    return userImageNetLocation+filename;
  }

  static Future<File> imageCompression(File file) async {
    String  tempfileDir = await TempDirectory.baseDirectory;
    print(tempfileDir);
    return file;
    //return await FlutterImageCompress.compressAndGetFile(baseDir.path, file.path,minWidth: 120,minHeight: 120,quality: 50);
  }

}

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
            height: MediaQuery.of(context).size.height*.04,
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