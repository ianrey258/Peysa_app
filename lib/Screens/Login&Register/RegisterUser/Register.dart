import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pyesa_app/Controller/Controller.dart';
import 'package:pyesa_app/Models/image.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:io';

class RegisterUser extends StatefulWidget{
  Register createState() => Register();
}

class Register extends State<RegisterUser>{
  ScrollController _sc = ScrollController();
  List<TextEditingController> text = []; 
  final _key = GlobalKey<FormState>();
  bool obscure = true;

  @override
  initState(){
    super.initState();
    setState(() {
      for(int i=0;i<10;i++){
        text.add(new TextEditingController());
      }
      text[6].text = "Male";
    });
  }
  
  validation() async {
    if(_key.currentState.validate()){
      _key.currentState.save();
      LoadingScreen.showLoading(context,'Loading   ');
      var result = await DataController.registerUser(text);
      Navigator.pop(context);
      Future.delayed(Duration(seconds: 1));
      if(result){
        await LoadingScreen.showResultDialog(context, "You are Now Registered!",20.0);
        Navigator.pop(context);
      } else {
        await LoadingScreen.showResultDialog(context, "Something Wrong!",20.0);
      }
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
          suffixIcon: showPassword,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
          ),
        validator: (val) => val.length > 0 ? null : "Invalid "+name,
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
  
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30)
            ),
            child: FlatButton(
              onPressed: validation, 
              child: Text("Ok",style: TextStyle(fontSize: 18),)
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _sc,
          child: Container(
            child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _textFormField("Username",0,TextInputType.text),
                  _textFormField("Password",1,TextInputType.text),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Register2 extends StatefulWidget {
  @override
  _Register2State createState() => _Register2State();
}

class _Register2State extends State<Register2> {
  File image;
  String _textbutton = "Skip";

  getPicture(source) async {
    Navigator.pop(context);
    var imageFile = await ImagePicker.pickImage(source: source);
    setState(() {
      image = imageFile != null ? imageFile : null;
      _textbutton = "Register";
    });
  }

  Future<bool> selectVia(){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          buttonPadding: EdgeInsets.all(0),
          title: Text("Choose "),
          elevation: 50,
          content: Container(
            height: MediaQuery.of(context).size.height * .2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: (){getPicture(ImageSource.gallery);},
                  child: Text("       Gallery      "),
                ),
                Row(children: <Widget>[
                  Expanded(child: Divider()),
                  Text("or"),
                  Expanded(child: Divider()),
                ]),
                RaisedButton(
                  onPressed: (){getPicture(ImageSource.gallery);},
                  child: Text("Take A Photo"),
                ),
              ]
            )
          ),
        );
      }
    );
  }

  Widget profilePicture(size){
    return image == null ? Icon(FontAwesome.user,size: size.width*.5,)
                  : Image.file(image,fit: BoxFit.fill,);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Set Profile"),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30)
            ),
            child: FlatButton(
              onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context);
              }, 
              child: Text(""+_textbutton,style: TextStyle(fontSize: 18),)
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              height: size.height*.30,
              width: size.width*.5,
              decoration: BoxDecoration(
                border: Border.all()
              ),
              child: FlatButton(
                padding: EdgeInsets.all(1),
                onPressed: (){selectVia();}, 
                child: profilePicture(size)
              ),
            ),
            RaisedButton(
              onPressed: (){selectVia();},
              child: Text("Profile Picture"),
            )
          ],
        )
      ),
    );
  }
}

class StoreRegister extends StatefulWidget {
  @override
  _StoreRegisterState createState() => _StoreRegisterState();
}

class _StoreRegisterState extends State<StoreRegister> {
  ScrollController sc;
  final _key = GlobalKey<FormState>();
  List<TextEditingController> text = [];
  ImageData tinFile = ImageData();

  @override
  initState(){
    super.initState();
    setState(() {
      for(int i=0;i<3;i++){
        text.add(TextEditingController());
      }
    });
  }
  
  validation() async {
    if(_key.currentState.validate() && tinFile.filename != null){
      _key.currentState.save();
      await showAgreement();
    }
  }

  getPicture(source) async {
    File image = await ImagePicker.pickImage(source: source);
    if(image != null){
      tinFile.filename = Random().nextInt(1000000).toString()+'_'+image.path.split('/').last;
      tinFile.binaryfile = base64Encode(image.readAsBytesSync());
    }
    Navigator.pop(context);
  }

  acceptance() async {
    Navigator.pop(context);
    LoadingScreen.showLoading(context, "Submitting Data...");
    var result = await DataController.registerStore(text, tinFile);
    Navigator.pop(context);
    if(result){
      await LoadingScreen.showResultDialog(context, "Form Submitted", 25);
      Navigator.pop(context);
    } else {
      await LoadingScreen.showResultDialog(context, "Data Sumbitting Fail", 20);
      Navigator.pop(context);
    }
  }

  Future<bool> chooseImage(){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('Choose'),
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

  Future<bool> showAgreement(){
    return showDialog(
      context: context,
      builder: (_){
        return AlertDialog(
          title: Text('Store Agreement'),
          content: SingleChildScrollView(
            controller: sc,
            child: Column(
              children: <Widget>[
                Container(
                  //height: MediaQuery.of(context).size.,
                  child: Text('These terms and conditions ("Terms", "Agreement") are an agreement between Mobile Application Developer ("Mobile Application Developer", "us", "we" or "our") and you ("User", "you" or "your"). This Agreement sets forth the general terms and conditions of your use of the Hanapyesa mobile application and any of its products or services (collectively, "Mobile Application" or "Services").'
                  '\n\nAccounts and membership'
                  '\n\nIf you create an account in the Mobile Application, you are responsible for maintaining the security of your account and you are fully responsible for all activities that occur under the account and any other actions taken in connection with it. We may monitor and review new accounts before you may sign in and use our Services. Providing false contact information of any kind may result in the termination of your account. You must immediately notify us of any unauthorized uses of your account or any other breaches of security. We will not be liable for any acts or omissions by you, including any damages of any kind incurred as a result of such acts or omissions. We may suspend, disable, or delete your account (or any part thereof) if we determine that you have violated any provision of this Agreement or that your conduct or content would tend to damage our reputation and goodwill. If we delete your account for the foregoing reasons, you may not re-register for our Services. We may block your email address and Internet protocol address to prevent further registration.'
                  '\n\nUser content'
                  '\n\nWe do not own any data, information or material ("Content") that you submit in the Mobile Application in the course of using the Service. You shall have sole responsibility for the accuracy, quality, integrity, legality, reliability, appropriateness, and intellectual property ownership or right to use of all submitted Content. We may monitor and review Content in the Mobile Application submitted or created using our Services by you. Unless specifically permitted by you, your use of the Mobile Application does not grant us the license to use, reproduce, adapt, modify, publish or distribute the Content created by you or stored in your user account for commercial, marketing or any similar purpose. But you grant us permission to access, copy, distribute, store, transmit, reformat, display and perform the Content of your user account solely as required for the purpose of providing the Services to you. Without limiting any of those representations or warranties, we have the right, though not the obligation, to, in our own sole discretion, refuse or remove any Content that, in our reasonable opinion, violates any of our policies or is in any way harmful or objectionable.'
                  '\n\nBackups'
                  '\n\nWe perform regular backups of the Content and will do our best to ensure completeness and accuracy of these backups. In the event of the hardware failure or data loss we will restore backups automatically to minimize the impact and downtime.'
                  '\n\nLinks to other mobile applications'
                  '\n\nAlthough this Mobile Application may link to other mobile applications, we are not, directly or indirectly, implying any approval, association, sponsorship, endorsement, or affiliation with any linked mobile application, unless specifically stated herein. We are not responsible for examining or evaluating, and we do not warrant the offerings of, any businesses or individuals or the content of their mobile applications. We do not assume any responsibility or liability for the actions, products, services, and content of any other third-parties. You should carefully review the legal statements and other conditions of use of any mobile application which you access through a link from this Mobile Application. Your linking to any other off-site mobile applications is at your own risk.'
                  '\n\n ---- Acceptance of these terms ----\n'
                  '\n\nYou acknowledge that you have read this Agreement and agree to all its terms and conditions. By using the Mobile Application or its Services you agree to be bound by this Agreement. If you do not agree to abide by the terms of this Agreement, you are not authorized to use or access the Mobile Application and its Services.'
                  '\n\nContacting us'
                  '\n\nIf you would like to contact us to understand more about this Agreement or wish to contact us concerning any matter relating to it, you may write a letter to C.M Recto Lapasan CDO'
                  '\n\nThis document was last updated on March 5, 2020'
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
               child: Text('Decline'),
               onPressed: (){Navigator.pop(context);}
             ),
             Expanded(child: Container()),
             RaisedButton(
               child: Text('Accept'),
               onPressed: acceptance
            ),
          ],
        );
      }
    );
  }

  Widget buttonUpload(){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(5),
      child: RaisedButton(
        onPressed: chooseImage,
        child: Text("Upload Bussiness Permit/Tin Picture"),
      ),
    );
  }

  Widget textField(index,name){
    int lines = name == 'Store Description'? 6 :1; 
    return Container(
      margin: EdgeInsets.all(5),
      child: TextFormField(
        controller: text[index],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(5),
          fillColor: Color.fromRGBO(255, 255, 255, 0.5),
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
          ),
        maxLines: lines,
        validator: (val) => val.length > 0 ? null : "Invalid "+name, 
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Store"),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30)
            ),
            child: FlatButton(
              onPressed: validation, 
              child: Text("Submit",style: TextStyle(fontSize: 18),)
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        controller: sc,
        child: Container(
          padding: EdgeInsets.only(top:5),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Store Name:',style: TextStyle(fontSize: 18)),
                textField(0,'Store Name'),
                Text('Store Description:',style: TextStyle(fontSize: 18)),
                textField(1,'Store Description'),
                Text('Store Address:',style: TextStyle(fontSize: 18)),
                textField(2,'Store Address'),
                buttonUpload()
              ],
            ) 
          ),
        ),
      ),
    );
  }
}