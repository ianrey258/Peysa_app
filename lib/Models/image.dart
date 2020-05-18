class ImageData{
  String id,parentId,filename,binaryfile;

  ImageData({this.id,this.parentId,this.filename,this.binaryfile});

  static toObject(Map<String,dynamic> map){
    return ImageData(
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