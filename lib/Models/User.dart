class UserCredential{
  String id,username,password,userType;

  UserCredential({
    this.id,
    this.username,
    this.password,
    this.userType
  });

  static UserCredential loadCredential(){
    return UserCredential(id: '1',username: 'ianreyqaz',password: '123456',userType: 'User');
  }

  UserCredential.toObject(Map<String,dynamic> map){
      id = map['id'];
      username =  map['username'];
      password = map['password'];
      userType = map['userType'];
  }

  Map<String,dynamic> toMapWid(){
    return{
      'id' : id,
      'username' : username,
      'password' : password,
      'userType' : userType,
    };
  }

  Map<String,dynamic> toMapWOid(){
    return{
      'username' : username,
      'password' : password,
      'userType' : userType,
    };
  }

}

class UserAccount{
  String id,userId,firstname,lastname,contactNo,gender,email,accountStatus;

  UserAccount({
    this.id,
    this.accountStatus,
    this.contactNo,
    this.email,
    this.firstname,
    this.gender,
    this.lastname,
    this.userId
  });

  static loadSampleAccount(){
    return UserAccount(id: '1',firstname: 'ianrey',lastname: 'Acampado',gender: 'Male',contactNo: '09359002344',email: 'Ianrey@gmail.com',userId: '1',accountStatus: '1');
  }

  static toObject(Map<String,dynamic> map){
    return UserAccount(
      id: map['id'],
      firstname: map['firstname'],
      lastname: map['lastname'],
      gender: map['gender'],
      contactNo: map['contactNo'],
      email: map['email'],
      userId: map['userId'],
      accountStatus: map['accountStatus']
    );
  }

  Map<String,dynamic> toMapWid(){
    return {
      'id':id,
      'accountStatus':accountStatus,
      'contactNo':contactNo,
      'email':email,
      'firstname':firstname,
      'gender':gender,
      'lastname':lastname,
      'userId':userId,
    };
  }

  Map<String,dynamic> toMapWOid(){
    return {
      'accountStatus':accountStatus,
      'contactNo':contactNo,
      'email':email,
      'firstname':firstname,
      'gender':gender,
      'lastname':lastname,
      'userId':userId,
    };
  }
}

class UserImage{
  String id,parentId,filename,binaryfile;

  UserImage({this.id,this.parentId,this.filename,this.binaryfile});

  static toObject(Map<String,dynamic> map){
    return UserImage(
      id: map['id'],
      parentId: map['parentId'],
      filename: map['filename'],
      binaryfile: null
    );
  }

  Map<String,dynamic> toMapWid(){
    return{
      'id':id,
      'parentId':parentId,
      'filename':filename,
    };
  }

  Map<String,dynamic> toMapWOid(){
    return{
      'parentId':parentId,
      'filename':filename,
    };
  }

  Map<String,dynamic> toMapWidUpload(){
    return{
      'id':id,
      'parentId':parentId,
      'filename':filename,
      'binaryfile':binaryfile
    };
  }

  Map<String,dynamic> toMapWOidUpload(){
    return{
      'parentId':parentId,
      'filename':filename,
      'binaryfile':binaryfile
    };
  }

}

