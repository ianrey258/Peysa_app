import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:image_cropper/image_cropper.dart';
import 'package:pyesa_app/Controller/Controller.dart';
import 'package:pyesa_app/Models/User.dart';
import 'package:pyesa_app/Models/Store.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'dart:async';

class Account extends StatefulWidget{
  Accountstate createState() => Accountstate();
}
class Accountstate extends State<Account>{
  ScrollController _sc;
  UserImage _userImage;
  File _image;
  bool hasStore = false,refresh = true;
  Store store = Store();
  String storeBtnTxt = 'Edit';

  @override
  initState(){
    super.initState();
    setState(() {
    });
  }

  refreshState(){
    setState(() {
      refresh = !refresh;
    });
  }

  Widget userinfo(String key,var value){
    return Row(
      children: <Widget>[
        Text(key+' : '+value,style: TextStyle(fontSize: 15))
      ],
    );
  }

  Widget personalInfo(){
    return FutureBuilder(
      future: DataController.getUserAccount(),
      builder: (context,snapshot){
        if(snapshot.connectionState ==  ConnectionState.done){
          return snapshot.hasData ? Card(
            margin: EdgeInsets.all(0),
            child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('My Profile',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        ),
                      ),
                      FlatButton(
                        onPressed: (){
                          Navigator.pushNamed(context, 'EditProfile');
                        }, 
                        child: Row(
                          children: <Widget>[
                            Text('Edit '),
                            Icon(Icons.edit)
                          ],
                        )
                      )
                    ],
                  ),
                  Divider(),
                  userinfo('Name', snapshot.data['firstname']+' '+snapshot.data['lastname']),
                  userinfo('Gender', snapshot.data['gender']),
                  userinfo('Contact No.', snapshot.data['contactNo']),
                  userinfo('Email Address', snapshot.data['email'])
                ],
              ),
            ),
          ): Center(child: CircularProgressIndicator(),);
        } else {
          return Center(child: CircularProgressIndicator(),);
        }
      }
    );
  }

  Widget giolocation(){
    return FutureBuilder(
      future: DataController.getLocation(),
      builder: (_,result){
        if(result.connectionState == ConnectionState.done && result.hasData){
          if(result.data.isNotEmpty){
            return userinfo('GioLocation', '('+result.data['longitude'] +','+result.data['latitude'] +')');
          }
          return userinfo('GioLocation', '(0,-0)');
        }
        return userinfo('GioLocation', '(0,-0)');
      },
    );
  }

  storeDetail(){
    return FutureBuilder(
      future: HpController.hasStore(),
      builder: (context,data){
        if(data.connectionState == ConnectionState.done && data.hasData){
          if(data.data){
            hasStore = data.data;
            return Container(
              child: FutureBuilder(
                future: DataController.getStore(),
                builder: (context,data2){
                  if(data2.connectionState == ConnectionState.done && data2.hasData){
                    store = Store.toObject(data2.data);
                    if(store.storeStatus == '15'){
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Your Store has been Process.',style: TextStyle(fontSize: 20))
                        ],
                      );
                    } else if (store.storeStatus == '14') {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Your Store has been Pending \nDue to the Form that you Submitted.',style: TextStyle(fontSize: 20),textAlign: TextAlign.center,)
                        ],
                      );
                    } else {
                      return Column(
                        children: <Widget>[
                          userinfo('Store Name', store.storeName),
                          userinfo('Description', store.storeInfo),
                          userinfo('Address', store.storeAddress),
                          userinfo('Rating', store.storeRating),
                          userinfo('Followers', store.storeFollowers),
                          giolocation(),
                        ],
                      );
                    }
                  }
                  return Container();
                }
              ),
            );
          } 
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Dont Have Store yet!',style: TextStyle(fontSize: 20))
            ],
          );
        }
        return Container();
      }
    );
  }

  Widget storeInfo(){
    return Card(
      margin: EdgeInsets.all(0),
      child: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('My Store',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  ),
                ),
              ],
            ),
            Divider(),
            Container(
              child: storeDetail(),
            ),
          ],
        ),
      ),
    );
  }

  getPicture(source) async {
    var image = await ImagePicker.pickImage(source: source);
    setState(() {
      _image = image;
    });
    if(_image != null){
      Navigator.pop(context);
      //_image = await ImageController.imageCompression(_image);
      LoadingScreen.showLoading(context, 'Updating Profile');
      _userImage.filename = Random().nextInt(1000000).toString()+'_'+_image.path.split('/').last.toString();
      _userImage.binaryfile = base64Encode(_image.readAsBytesSync());
      await ImageController.savingProfileImage(_userImage.toMapWid(),_userImage.toMapWidUpload());
    }
    Navigator.pop(context);
    refreshState();
  }

  Future<bool> chooseImage(){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('Change Profile'),
          content: Container(
            height: MediaQuery.of(context).size.height*.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: (){getPicture(ImageSource.gallery);},
                  child: Text('Gallery'),
                ),
                Divider(),
                RaisedButton(
                  onPressed: (){getPicture(ImageSource.camera);},
                  child: Text('Camera'),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget profileImage(){
    return FutureBuilder(
      future: ImageController.getUserImage(),
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          _userImage = UserImage.toObject(snapshot.data);
          return snapshot.hasData && snapshot.data['filename'] != 'null' ? Image.network(ImageController.getUserNetImage(snapshot.data['filename']),filterQuality: FilterQuality.medium,fit: BoxFit.cover,width: 62,height: 62,):
           Icon(FontAwesome.user_circle_o,size: 65,);
        } else {
          return Icon(FontAwesome.user_circle_o,size: 65,);
        }
      }
    );
  } 

  Widget profileBackground(){
    return FutureBuilder(
      future: ImageController.getStoreImages(),
      builder: (_,result){
        if(result.connectionState == ConnectionState.done && result.hasData){
          if(result.data.isNotEmpty){
            return Container(
              child: Image.network(ImageController.getStoreNetImage(result.data[0]['filename']),fit: BoxFit.cover),
            );
          }
          return Container(color: Colors.blue,);
        }
        return Container();
      }
    );
  }

  Widget build(BuildContext context){
    return Scaffold(
      body: CustomScrollView(
        controller: _sc,
        scrollDirection: Axis.vertical,
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.transparent,
            forceElevated: false,
            expandedHeight: MediaQuery.of(context).size.height*.2,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.all(10),
              centerTitle: true,
              title: FlatButton(
                onPressed: (){chooseImage();}, 
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: profileImage(),
                  ),
                ),
              ),
              background: profileBackground(),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Divider(),
              personalInfo(),
              Divider(),
              storeInfo()
            ]),
          ),
        ],
      ),
    );
  }
}

class ChangeProfilePic extends StatefulWidget {
  @override
  _ChangeProfilePicState createState() => _ChangeProfilePicState();
}

class _ChangeProfilePicState extends State<ChangeProfilePic> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}

class EditProfile extends StatefulWidget {

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  List<TextEditingController> text = []; 
  UserCredential _user = UserCredential();
  UserAccount _userAccount = UserAccount();
  GlobalKey<FormState> _key = new GlobalKey<FormState>();
  ScrollController sc;
  bool obscure = true,loadData = false;


  @override
  initState(){
    super.initState();
    _key = new GlobalKey<FormState>();
    setState(() {
      for(int i=0;i<10;i++){
        text.add(new TextEditingController());
      }
    });
  }

  initData() {
    text[0].text = _user.username;
    text[1].text = _user.password;
    text[2].text = _userAccount.firstname;
    text[3].text = _userAccount.lastname;
    text[4].text = _userAccount.email;
    text[5].text = _userAccount.contactNo;
    text[6].text = _userAccount.gender;
    loadData = true;
  }

  saveData(){
    _user.username = text[0].text;
    _user.password = text[1].text;
    _userAccount.firstname = text[2].text;
    _userAccount.lastname = text[3].text;
    _userAccount.email = text[4].text;
    _userAccount.contactNo = text[5].text;
    _userAccount.gender = text[6].text;    
  }

  validate() async {
    if(_key.currentState.validate()){
      _key.currentState.save();
      saveData();
      LoadingScreen.showLoading(context, "Updating Data");
      await DataController.savingUserData(_user.toMapWid(), _userAccount.toMapWid());
      Navigator.pop(context);
      await LoadingScreen.showResultDialog(context, 'Data Saved!', 25);
      Navigator.pop(context);
      Navigator.popAndPushNamed(context, 'Account');
    }
  }

  Widget _textFormField(String name,int controller,TextInputType type){
    var obscures = name != 'Password' ? false : obscure;
    Widget showPassword = name != 'Password' ? null : IconButton(
      icon: Icon(FontAwesome.eye_slash), 
      onPressed: (){
        setState(() {obscure = obscure ? false : true;});
      },
    );
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        obscureText: obscures,
        keyboardType: type,
        controller: text[controller],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(5),
          fillColor: Color.fromRGBO(255, 255, 255, 0.5),
          filled: true,
          labelText: name,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          suffixIcon: showPassword,
          ),
        validator: (val)=> val.length > 0 ? null : "Invalid "+name,
      ),
    );
  }
  Widget _radioGender(String value){
    return Radio(
      value: value,
      groupValue: text[6].text,
      onChanged: (val){setState(() {
        text[6].text = val;
      });},
    );
  }

  Widget initFutureData(){
    return FutureBuilder(
      future: DataController.getUserCredential(),
      builder: (context,snapshot){
          if(snapshot.hasData){
          return FutureBuilder(
            future: DataController.getUserAccount(),
            builder: (context,snapshot2){
              if(!loadData && snapshot2.hasData){
                _user = !loadData ? UserCredential.toObject(snapshot.data):null;
                _userAccount = !loadData ? UserAccount.toObject(snapshot2.data):null;
                loadData = true;
                initData();
              }
              return snapshot2.hasData ? editForm():CircularProgressIndicator();
            }
          );
        }
        return Container(width: 0.0, height: 0.0);
      }
    );
  }

  Widget editForm(){
    return Container(
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Divider(),
                ),
                Text("Personal Info's"),
                Expanded(
                  child: Divider(),
                ),
              ],
            ),
            _textFormField("Firstname",2,TextInputType.text),
            _textFormField("Lastname",3,TextInputType.text),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  _radioGender("Male"),
                  Text("Male "),
                  _radioGender("Female"),
                  Text("Female "),
                ],
              ),
            ),
            _textFormField("Email Address",4,TextInputType.emailAddress),
            _textFormField("Contact No.",5,TextInputType.phone),
            _textFormField("Username",0,TextInputType.text),
            _textFormField("Password",1,TextInputType.text),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30)
            ),
            child: FlatButton(
              onPressed: validate, 
              child: Text("Save",style: TextStyle(fontSize: 18),)
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        controller: sc,
        child: initFutureData(),
      ),
    );
  }
}

class EditStore extends StatefulWidget {
  @override
  _EditStoreState createState() => _EditStoreState();
}

class _EditStoreState extends State<EditStore> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}