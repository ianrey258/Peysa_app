import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DbUtil{
  static Database _db;
  static const Tbl_User = 'user';
  static const Tbl_UserAccount = 'user_account';
  static const Tbl_UserImg = 'user_img';
  static const Tbl_StoreImg = 'store_img';
  static const Tbl_ItemImg = 'item_img';
  static const Tbl_BidItemImg = 'bidItem_img';
  static const Tbl_ApprovalImg = 'store_veriification_img';
  static const Tbl_Store = 'store';
  static const Tbl_StoreItem = 'storeitems';
  static const Tbl_Notification = 'notification';
  static const Tbl_NotificationType = 'notificationtype';
  static const Tbl_StatusType = 'statustype';
  static const Tbl_ItemCategory = 'item_category';
  static const Tbl_ItemTags = 'item_tags';
  static const Tbl_GioLocation = 'gio_address';
  static const Tbl_ItemRating = 'item_rating';


  Future<Database> get database async{

    if(_db !=  null){
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    Directory databaseDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(databaseDirectory.path,'TempData.db');
    return await openDatabase(dbPath,version: 1,onCreate: (_db,version)async{
      await _db.execute('create table $Tbl_User (id TEXT,username Text,password TEXT ,userType Text)');
      await _db.execute('create table $Tbl_UserAccount (id TEXT,userId TEXT,firstname TEXT,lastname TEXT,contactNo TEXT,gender TEXT,email TEXT,accountStatus TEXT)');
      await _db.execute('create table $Tbl_UserImg (id TEXT,parentId TEXT,filename TEXT)');
      await _db.execute('create table $Tbl_StoreImg (id TEXT,parentId TEXT,filename TEXT)');
      await _db.execute('create table $Tbl_ItemImg (id TEXT,parentId TEXT,filename TEXT)');
      await _db.execute('create table $Tbl_BidItemImg (id TEXT,parentId TEXT,filename TEXT)');
      await _db.execute('create table $Tbl_ApprovalImg (id TEXT,parentId TEXT,filename TEXT)');
      await _db.execute('create table $Tbl_Store (id TEXT,accountId TEXT,storeName TEXT,storeInfo TEXT,storeAddress TEXT,storeRating TEXT,storeFollowers TEXT,storeVisited TEXT,storeStatus TEXT)');
      await _db.execute('create table $Tbl_StoreItem (id TEXT,itemName TEXT,itemPrice TEXT,itemDescription TEXT,itemStack TEXT,itemRating TEXT,tagId TEXT,categoryId TEXT,topupId TEXT)');
      await _db.execute('create table $Tbl_Notification (id TEXT,userId TEXT,message TEXT,dateRecieved DATE,notificationType TEXT,status TEXT)');
      await _db.execute('create table $Tbl_NotificationType (id TEXT,notificationType TEXT)');
      await _db.execute('create table $Tbl_StatusType (id TEXT,statusName TEXT)');
      await _db.execute('create table $Tbl_ItemCategory (id TEXT,categoryName TEXT)');
      await _db.execute('create table $Tbl_ItemTags (id TEXT,tagName TEXT)');
      await _db.execute('create table $Tbl_GioLocation (id TEXT,storeId TEXT,longitude TEXT,latitude TEXT)');
    });
  }

  Future<void> deleteDb() async {
    if(_db.path.isNotEmpty){
      await deleteDatabase(_db.path);
    }
  }

  Future<void> dropAllTable() async {
    final db = await database;
    if(db.path.isNotEmpty){
      db.delete('$Tbl_User');
      db.delete('$Tbl_UserAccount');
      db.delete('$Tbl_UserImg');
      db.delete('$Tbl_StoreImg');
      db.delete('$Tbl_ItemImg');
      db.delete('$Tbl_Store');
      db.delete('$Tbl_StoreItem');
      db.delete('$Tbl_Notification');
      db.delete('$Tbl_ItemCategory');
      db.delete('$Tbl_ItemTags');
      db.delete('$Tbl_GioLocation');
      db.delete('$Tbl_ApprovalImg');
      db.delete('$Tbl_NotificationType');
      db.delete('$Tbl_StatusType');
      db.delete('$Tbl_BidItemImg');
      //db.delete('$Tbl_ItemRating');
    }
  }

  Future<bool> isOpen() async {
    return database.then((value) => value.isOpen);
  }

  Future<void> openDb() async {
    await initDb();
  }

  Future<void> closeDb() async {
    try{
      await database.then((value) => value.close());
    } finally {
      
    }
  }

}

class DbAccess{
  static DbUtil _dbUtil = DbUtil();

  static Future<int> insertData(Map<String,dynamic> data,table) async {
    final db = await _dbUtil.database;
    return db.insert(table, data,conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<Map<String,dynamic>> getData(table) async {
    final db = await _dbUtil.database;
    List listResult = await db.query(table);  
    return listResult.isNotEmpty ? listResult[0] : {} ;
  }

  static Future<List> getDataList(table) async {
    final db = await _dbUtil.database;
    List listResult = await db.query(table);           
    return listResult;
  }

  static Future<List> getDataListWhere(table,where) async {
    final db = await _dbUtil.database;
    List listResult = await db.query(table,where: where);           
    return listResult;
  }

  static Future<List> getDataListBy(table,by) async {
    final db = await _dbUtil.database;
    List listResult = await db.query(table,orderBy: by);           
    return listResult;
  }

  static Future<int> updateData(Map<String,dynamic> data,table) async {
    final db = await _dbUtil.database;
    return db.update(table, data,where: data['id'],conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> dropTable(table) async {
    final db = await _dbUtil.database;
    return db.delete(table);
  }

}