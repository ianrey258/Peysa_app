import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pyesa_app/Controller/Controller.dart';
import 'package:pyesa_app/Models/User.dart';
import 'package:pyesa_app/Models/image.dart';
import 'package:pyesa_app/Models/Bid.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import 'dart:io';

//Request Screen
class RequestItem extends StatefulWidget {
  RequestItemstate createState() => RequestItemstate();
}

class RequestItemstate extends State<RequestItem> {
  Future<File> file;
  ScrollController _sc;
  Map addresses = {};
  List statusType = [];
  bool refresh = false;

  @override
  initState() {
    super.initState();
    loadAddresses();
    loadStatusType();
  }

  Future<Null> refreshRequest() async {
    refreshState();
    await Future.delayed(Duration(seconds: 1));
  }

  refreshState() {
    setState(() {
      refresh = !refresh ? true : false;
    });
  }

  loadStatusType() async {
    statusType = await DataController.getStatusType();
  }

  loadAddresses() async {
    addresses = await DataController.getAddresses();
    refreshState();
  }

  getLocation(zipCode) {
    var address = '';
    addresses.forEach((key, value) {
      if (value['id'] == zipCode) address = value['location'];
    });
    return address;
  }

  getStatus(statusId) {
    var status = '';
    statusType.forEach((element) {
      if (element['id'] == statusId) status = element['statusName'];
    });
    return status;
  }

  Widget getImage(image) {
    return Container(
      width: 75,
      child: image.isNotEmpty
          ? Image.network(ImageController.getItemNetImage(image['filename']),
              filterQuality: FilterQuality.medium, fit: BoxFit.cover)
          : Icon(
              Icons.image,
              size: 75,
            ),
    );
  }

  Widget requestItem(item, status, image) {
    return ListTile(
      contentPadding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
      leading: Container(
        height: 100,
        child: getImage(image),
      ),
      title: Text("Location: " + getLocation(item['sendLocation'])),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Align(
              alignment: Alignment.bottomLeft,
              child: Text("Date: " + item['datetime'])),
          Align(
              alignment: Alignment.bottomRight,
              child: Text("Status: " + getStatus(status['bidStatus'])))
        ],
      ),
      onTap: () {
        Navigator.pushNamed(context, 'Bidding',
            arguments: BidItem(id: item['id'], bidItem: item['bidItem']));
      },
    );
  }

  Widget requestedItem(
      otherBidItem, bidItem, itemDetail, itemImage, bidManager, userDetail) {
    var status = bidManager['bidStatus'] == '5' ? 'Open' : 'Closed';
    return ListTile(
      contentPadding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
      leading: getImage(itemImage),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                  userDetail['firstname'] + ' ' + userDetail['lastname'],
                  style: TextStyle(
                      fontWeight: otherBidItem['requestStatus'] == '12'
                          ? FontWeight.bold
                          : FontWeight.normal))),
          Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "Date: " + bidItem['datetime'],
                style: TextStyle(fontSize: 13),
              ))
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Budget P" + itemDetail['itemPriceorBudget'],
                style: TextStyle(
                    fontWeight: otherBidItem['requestStatus'] == '12'
                        ? FontWeight.bold
                        : FontWeight.normal),
              )),
          Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "Status: " + status,
                style: TextStyle(fontSize: 13),
              ))
        ],
      ),
      trailing: IconButton(
          icon: otherBidItem['requestStatus'] == '12' ||
                  bidManager['bidStatus'] != '5'
              ? Icon(
                  Icons.message,
                  size: 45,
                  color: Colors.green[200],
                )
              : Icon(
                  Icons.message,
                  size: 45,
                  color: Colors.green,
                ),
          onPressed: otherBidItem['requestStatus'] == '12' ||
                  bidManager['bidStatus'] != '5'
              ? null
              : () {
                  Navigator.of(context).pushNamed('BidChat',
                      arguments: BidChatDataHolder(
                          user: UserAccount.toObject(userDetail),
                          bidItem: BidItem.toObject(bidItem)));
                }),
      onTap: () {
        requestFeedbackDialog(otherBidItem, itemDetail, userDetail);
      },
    );
  }

  Future<bool> requestDialog() {
    return showDialog(context: context, builder: (_) => RequestForm());
  }

  Future<bool> requestFeedbackDialog(otherBidItem, itemDetail, userDetail) {
    return showDialog(
      context: context,
      builder: (_) => RequestFeedback(
          otherBidItem: otherBidItem,
          itemDetail: itemDetail,
          userDetail: userDetail),
    );
  }

  Widget listofRequestItem() {
    return RefreshIndicator(
        child: FutureBuilder(
            future: DataController.getRequestItems(),
            builder: (_, data) {
              if (data.connectionState == ConnectionState.done) {
                if (data.hasData) {
                  if (!data.data[3])
                    return Container(
                      child: Center(
                        child: Text('Check Internet Connection'),
                      ),
                    );
                  if (data.data[0].isNotEmpty) {
                    int length = data.data[0].length - 1;
                    return Container(
                      child: ListView.builder(
                          itemCount: data.data[0].length,
                          itemBuilder: (_, index) {
                            return Container(
                              child: requestItem(
                                  data.data[0][length - index],
                                  data.data[1][length - index],
                                  data.data[2][length - index]),
                            );
                          }),
                    );
                  }
                  return Container(
                    child: Center(
                      child: Text('You Have no Request Item'),
                    ),
                  );
                }
              }
              return Container(
                child: Center(
                  child: Text('Loading .....'),
                ),
              );
            }),
        onRefresh: refreshRequest);
  }

  Widget listofRequestedItem() {
    return RefreshIndicator(
        child: FutureBuilder(
            future: DataController.getRequestedItems(),
            builder: (_, data) {
              if (data.connectionState == ConnectionState.done) {
                if (data.hasData) {
                  if (!data.data[6])
                    return Container(
                      child: Center(
                        child: Text('Check Internet Connection'),
                      ),
                    );
                  if (data.data[0].isNotEmpty) {
                    int length = data.data[0].length - 1;
                    return Container(
                      child: ListView.builder(
                          itemCount: data.data[0].length,
                          itemBuilder: (_, index) {
                            return Container(
                              child: requestedItem(
                                  data.data[0][length - index],
                                  data.data[1][length - index],
                                  data.data[2][length - index],
                                  data.data[3][length - index],
                                  data.data[4][length - index],
                                  data.data[5][length - index]),
                            );
                          }),
                    );
                  }
                  return Container(
                    child: Center(
                      child: Text('You Have no Others Request Yet'),
                    ),
                  );
                }
              }
              return Container(
                child: Center(
                  child: Text('Loading .....'),
                ),
              );
            }),
        onRefresh: refreshRequest);
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Request Item"),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        icon: Icon(FontAwesome.eye), onPressed: requestDialog),
                  ),
                ),
              ],
            ),
            bottom: TabBar(
              labelColor: Colors.blueAccent,
              unselectedLabelColor: Colors.grey,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: Colors.white,
              ),
              tabs: <Widget>[
                Tab(
                  text: "My Request",
                ),
                Tab(
                  text: "Other Request",
                ),
              ],
            ),
          ),
          body: TabBarView(children: [
            listofRequestItem(),
            listofRequestedItem(),
          ])),
    );
  }
}

class RequestForm extends StatefulWidget {
  @override
  _RequestFormState createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  List<TextEditingController> text = [];
  ScrollController _sc;
  final _key = GlobalKey<FormState>();
  var selectedLoc = "All Region", screenSize;
  bool refresh = false;
  List<File> images = [];
  var address = '', zipCode = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      for (int i = 0; i < 5; i++) {
        text.add(TextEditingController());
      }
    });
  }

  void refreshState() {
    setState(() {
      refresh = !refresh;
    });
  }

  validate() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      await DataController.getAddresses()
          .then((value) => value.forEach((key, value) {
                if (value['location'] == address) {
                  text[3].text = value['id'];
                }
              }));
      LoadingScreen.showLoading(context, 'Sending to ' + address);
      var result = await DataController.sendingRequest(images, text);
      Navigator.pop(context);
      try {
        await LoadingScreen.showResultDialog(
            context,
            int.parse(result).toString() + ' User Sended',
            MediaQuery.of(context).textScaleFactor * 25);
        Navigator.pop(context);
      } catch (e) {
        await LoadingScreen.showResultDialog(
            context, result, MediaQuery.of(context).textScaleFactor * 25);
      }
    }
  }

  Widget form(title, i, keyboard) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: TextFormField(
        controller: text[i],
        keyboardType: keyboard,
        decoration: InputDecoration(hintText: title),
        validator: (val) => val.length > 0 ? null : "Invalid Input",
      ),
    );
  }

  Widget dropDownLocation() {
    return FutureBuilder<Map>(
        future: DataController.getAddresses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (address == '') {
                address = snapshot.data.values
                    .toList()
                    .map((e) => e['location'])
                    .toList()[0]
                    .toString();
              }
              return Container(
                child: DropdownButtonFormField(
                  items: snapshot.data.values.toList().map((data) {
                    return DropdownMenuItem(
                        value: data['location'], child: Text(data['location']));
                  }).toList(),
                  onChanged: (value) {
                    address = value;
                  },
                  value: address ?? 'Alubijid',
                ),
              );
            }
            return Container();
          }
          return Container();
        });
  }

  invalidImageSize() async {
    Navigator.pop(context);
    LoadingScreen.showResultDialog(context, 'Image Size Must not exceed to 5mb',
        MediaQuery.of(context).textScaleFactor * 15);
  }

  _getPicture(source) async {
    File _item;
    try {
      _item = await ImagePicker.pickImage(source: source);
      setState(() {
        _item != null && _item.lengthSync() < 5000000
            ? images.add(_item)
            : invalidImageSize();
      });
    } catch (e) {}
    if (_item != null && _item.lengthSync() < 5000000 || _item == null)
      Navigator.pop(context);
  }

  Future<bool> chooseUpload() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Choose Upload"),
        content: Container(
            height: MediaQuery.of(context).size.height * .2,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .03,
                  ),
                  RaisedButton(
                    onPressed: () {
                      _getPicture(ImageSource.gallery);
                    },
                    child: Text("       Gallery      "),
                  ),
                  Row(children: <Widget>[
                    Expanded(child: Divider()),
                    Text("or"),
                    Expanded(child: Divider()),
                  ]),
                  RaisedButton(
                    onPressed: () {
                      _getPicture(ImageSource.camera);
                    },
                    child: Text("Take A Photo"),
                  ),
                ])),
      ),
    );
  }

  Widget sampleImage(image) {
    return FlatButton(
        padding: EdgeInsets.only(right: 5),
        onPressed: () {
          imageFullSize(image);
        },
        child: Image.file(image));
  }

  List<Widget> getImages() {
    return images.isEmpty
        ? [Center(child: Text("No Sample Image"))]
        : images.map((e) => sampleImage(e)).toList();
  }

  deleteImage(image) {
    images.removeAt(images.indexOf(image));
    refreshState();
    Navigator.pop(context);
  }

  Future<bool> imageFullSize(image) {
    return showDialog(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(bottom: 50),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: RaisedButton(
                  onPressed: () {
                    deleteImage(image);
                  },
                  child: Text('Remove'),
                ),
              ),
              Expanded(
                child: Image.file(image),
              )
            ],
          ),
        );
      },
    );
  }

  Widget sampleItems() {
    return Container(
      width: screenSize.width * 1,
      height: screenSize.height * .5,
      child: Column(children: <Widget>[
        Expanded(
            child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: getImages(),
          ),
        )),
        Align(
          alignment: Alignment.centerRight,
          child: RaisedButton(
            onPressed: images.length < 5 ? chooseUpload : null,
            child: Text("Upload Image"),
          ),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return AlertDialog(
      title: Text("Request Item || Looking For Item"),
      content: Container(
          //height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: _key,
            child: ListView(
              controller: _sc,
              children: <Widget>[
                sampleItems(),
                form("Name of Item", 0, TextInputType.text),
                form("Something to Say", 1, TextInputType.text),
                form("Budget Price", 2, TextInputType.number),
                Text('Location to Find'),
                dropDownLocation()
              ],
            ),
          )),
      actions: <Widget>[
        RaisedButton(
            color: Colors.blueAccent,
            onPressed: () {
              validate();
            },
            child: Text("Send"))
      ],
    );
  }
}

class RequestFeedback extends StatefulWidget {
  final Map otherBidItem, itemDetail, userDetail;
  RequestFeedback(
      {Key key, this.otherBidItem, this.itemDetail, this.userDetail})
      : super(key: key);
  @override
  _RequestFeedbackState createState() => _RequestFeedbackState();
}

class _RequestFeedbackState extends State<RequestFeedback> {
  List<TextEditingController> text = [];
  ScrollController _sc;
  Bidders bidder = Bidders();
  final _key = GlobalKey<FormState>();
  var screenSize, heightMultiplier = .31, address = 'None';
  bool refresh = false;
  List<File> images = [];
  List<Widget> sampleImages = [];
  Map sampleImagesMap = {};

  @override
  void initState() {
    super.initState();
    setState(() {
      for (int i = 0; i < 5; i++) {
        text.add(TextEditingController());
      }
    });
    loadFeedbackRequest();
    initAddresses();
  }

  initAddresses() async {
    Map addresses = await DataController.getAddresses();
    addresses.forEach((key, value) {
      if (value['id'] == widget.userDetail['zipCode']) {
        address = value['location'];
      }
    });
    refreshState();
  }

  void refreshState() {
    setState(() {
      refresh = !refresh;
    });
  }

  validateAcceptUpdate() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      BidItemDetail itemdetail = BidItemDetail(
          id: widget.otherBidItem['suggestedItemId'],
          itemName: text[0].text,
          itemPriceorBudget: text[2].text,
          description: text[1].text);
      LoadingScreen.showLoading(context, 'Loading ...');
      String result = widget.itemDetail['id'] == bidder.suggestedItemId
          ? await DataController.requestAcceptUpdate(
              widget.otherBidItem['id'], itemdetail, images)
          : await DataController.requestAcceptUpdate(
              widget.otherBidItem['id'], itemdetail, images, 'update');
      if (result != null) {
        Navigator.pop(context);
        await LoadingScreen.showResultDialog(context, result, 25);
        if (widget.itemDetail['id'] != bidder.suggestedItemId)
          Navigator.pop(context);
      } else {
        Navigator.pop(context);
        await LoadingScreen.showResultDialog(
            context, "Check Internet Connection", 25);
      }
    }
  }

  requestDecline() async {
    String result =
        await DataController.requestDecline(widget.otherBidItem['id']);
    if (result != null) {
      await LoadingScreen.showResultDialog(context, result, 25);
      Navigator.popAndPushNamed(context, 'RequestItem');
    } else {
      await LoadingScreen.showResultDialog(
          context, "Cannot Decline due to Check Internet Connectivity", 10);
    }
  }

  Widget form(title, i, keyboard) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: TextFormField(
        controller: text[i],
        keyboardType: keyboard,
        decoration: InputDecoration(hintText: title),
        validator: (val) => val.length > 0 ? null : "Invalid Input",
      ),
    );
  }

  //image Getter with catching
  invalidImageSize() async {
    Navigator.pop(context);
    LoadingScreen.showResultDialog(context, 'Image Size Must not exceed to 5mb',
        MediaQuery.of(context).textScaleFactor * 15);
  }

  _getPicture(source) async {
    File _item;
    try {
      _item = await ImagePicker.pickImage(source: source);
      setState(() {
        _item != null && _item.lengthSync() < 5000000
            ? images.add(_item)
            : invalidImageSize();
      });
    } catch (e) {}
    if (_item != null && _item.lengthSync() < 5000000 || _item == null)
      Navigator.pop(context);
  }

  //image Getter with catching
  Future<bool> chooseUpload() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Choose Upload"),
        content: Container(
            height: MediaQuery.of(context).size.height * .2,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .03,
                  ),
                  RaisedButton(
                    onPressed: () {
                      _getPicture(ImageSource.gallery);
                    },
                    child: Text("       Gallery      "),
                  ),
                  Row(children: <Widget>[
                    Expanded(child: Divider()),
                    Text("or"),
                    Expanded(child: Divider()),
                  ]),
                  RaisedButton(
                    onPressed: () {
                      _getPicture(ImageSource.camera);
                    },
                    child: Text("Take A Photo"),
                  ),
                ])),
      ),
    );
  }

  Widget sampleImage(image, [isArray = false, owner = 'sender']) {
    return FlatButton(
        padding: EdgeInsets.only(right: 5),
        onPressed: () {
          imageFullSize(image, isArray, owner);
        },
        child: !isArray
            ? Image.file(image)
            : Image.network(ImageController.getItemNetImage(image),
                fit: BoxFit.contain));
  }

  List<Widget> getImages() {
    return images.isEmpty && sampleImages.isEmpty
        ? [Center(child: Text("No Sample Image"))]
        : images.map((e) => sampleImage(e, false, 'reciever')).toList();
  }

  deleteImage(image) {
    images.removeAt(images.indexOf(image));
    refreshState();
    Navigator.pop(context);
  }

  deleteImageFromDb(filename) async {
    sampleImagesMap.forEach((key, value) async {
      if (value['filename'] == filename)
        await ImageController.removeBidImage(value);
    });
    refreshState();
    Navigator.pop(context);
  }

  Future<bool> imageFullSize(image, [isArray = false, owner = 'sender']) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(bottom: 50),
          child: Column(
            children: <Widget>[
              owner == 'reciever'
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: RaisedButton(
                        onPressed: () {
                          !isArray
                              ? deleteImage(image)
                              : deleteImageFromDb(image);
                          refreshState();
                        },
                        child: Text('Remove'),
                      ),
                    )
                  : Container(),
              Expanded(
                child: !isArray
                    ? Image.file(image)
                    : Image.network(ImageController.getItemNetImage(image),
                        fit: BoxFit.contain),
              )
            ],
          ),
        );
      },
    );
  }

  Widget sampleItemsImage(id) {
    return FutureBuilder(
      future: ImageController.getBidImages(id),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            sampleImages = [];
            sampleImagesMap = snapshot.data;
            if (snapshot.data.isNotEmpty && id != widget.itemDetail['id'])
              snapshot.data.forEach((key, value) {
                sampleImages
                    .add(sampleImage(value['filename'], true, 'reciever'));
              });
            return Container(
              child: Column(children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: RaisedButton(
                    onPressed: images.length + snapshot.data.length < 5
                        ? chooseUpload
                        : null,
                    child: Text("Upload Image"),
                  ),
                ),
                Container(
                    height: 150,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: sampleImages + getImages(),
                      ),
                    )),
              ]),
            );
          }
        }
        return Container();
      },
    );
  }

  loadFeedbackRequest() async {
    bidder = Bidders.toObject(widget.otherBidItem);
    Map itemDetail =
        await DataController.getItemDetails(bidder.suggestedItemId);
    if (bidder.suggestedItemId != widget.itemDetail['id'])
      setTextField(itemDetail[0]);
  }

  setTextField(data) async {
    print(data);
    setState(() {
      text[0].text = data['itemName'];
      text[1].text = data['description'];
      text[2].text = data['itemPriceorBudget'];
    });
    refreshState();
  }

  //OwnerRequest Detail
  itemImages(Map images) {
    List<Widget> listImages = [];
    if (images.isNotEmpty)
      images.forEach((key, value) {
        listImages.add(sampleImage(value['filename'], true));
      });
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          height: MediaQuery.of(context).size.height * .2,
          child: Row(
            children: images.isEmpty
                ? [Center(child: Text("No Sample Image"))]
                : listImages,
          ),
        ));
  }

  itemDetail() {
    return FutureBuilder(
        future: ImageController.getBidImages(widget.itemDetail['id']),
        builder: (_, images) {
          if (images.connectionState == ConnectionState.done) {
            if (images.hasData) {
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    itemImages(images.data),
                    SizedBox(height: 2),
                    Text('Item Name : ' + widget.itemDetail['itemName']),
                    Text('Item Description : ' +
                        widget.itemDetail['description']),
                    Text('Budget Price : P' +
                        widget.itemDetail['itemPriceorBudget']),
                    SizedBox(height: 7),
                    Text('Request by : ' +
                        widget.userDetail['firstname'] +
                        ' ' +
                        widget.userDetail['lastname']),
                    Text('Located in : ' + address),
                  ],
                ),
              );
            }
          }
          return Container(
            height: MediaQuery.of(context).size.height * .2,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  List<Widget> buttons() {
    List<Widget> buttons = [];
    if (widget.otherBidItem['requestStatus'] == '12') {
      buttons.add(RaisedButton(
          color: Colors.red,
          onPressed: () {
            requestDecline();
          },
          child: Text("Decline")));
      buttons.add(RaisedButton(
          color: Colors.blue,
          onPressed: () {
            heightMultiplier != .7
                ? heightMultiplier = .7
                : validateAcceptUpdate();
            refreshState();
          },
          child: Text("Accept")));
    }
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.otherBidItem['requestStatus'] != '12') heightMultiplier = .7;
    screenSize = MediaQuery.of(context).size;
    return AlertDialog(
      title: Container(
        child: Row(
          children: [
            Text("Item Request Detail"),
            Expanded(
              child: Container(),
            ),
            widget.itemDetail['id'] != bidder.suggestedItemId
                ? RaisedButton(
                    color: Colors.blue,
                    onPressed: validateAcceptUpdate,
                    child: Text("Update"))
                : Container()
          ],
        ),
      ),
      content: Container(
          height: MediaQuery.of(context).size.height * heightMultiplier,
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: _key,
            child: ListView(
              controller: _sc,
              children: <Widget>[
                itemDetail(),
                heightMultiplier == .7 ? Divider() : Container(),
                heightMultiplier == .7
                    ? Text('Your Feedback Request:')
                    : Container(),
                heightMultiplier == .7
                    ? form("Item Name", 0, TextInputType.text)
                    : Container(),
                heightMultiplier == .7
                    ? form("Item Condition", 1, TextInputType.text)
                    : Container(),
                heightMultiplier == .7
                    ? form("Item Price", 2, TextInputType.number)
                    : Container(),
                heightMultiplier == .7
                    ? sampleItemsImage(widget.otherBidItem['suggestedItemId'])
                    : Container(),
                heightMultiplier == .7 ? Divider() : Container(),
              ],
            ),
          )),
      actions: buttons(),
    );
  }
}

class Bidding extends StatefulWidget {
  @override
  _BiddingState createState() => _BiddingState();
}

class _BiddingState extends State<Bidding> {
  ScrollController _sc;
  List<Widget> images = [];
  bool refresh = true;

  @override
  initState() {
    super.initState();
  }

  refreshState() {
    setState(() {
      refresh = refresh ? false : true;
    });
  }

  Future<Null> refreshList() async {
    refreshState();
    Future.delayed(Duration(seconds: 1));
  }

  imageContainer(filename) {
    return Container(
      margin: EdgeInsets.only(right: 10, left: 10),
      child: Image.network(
        ImageController.getItemNetImage(filename),
        fit: BoxFit.contain,
      ),
    );
  }

  Future<Null> itemDetail(item, images, userImage) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => BiddersItemDetail(
        item: item,
        images: images,
        userImage: userImage,
      ),
    );
  }

  Widget itemImages(id) {
    return FutureBuilder(
        future: ImageController.getBidImages(id),
        builder: (_, data) {
          if (data.connectionState == ConnectionState.done) {
            if (data.hasData) {
              if (data.data.isNotEmpty) {
                images = [];
                data.data.forEach((key, value) {
                  images.add(imageContainer(value['filename']));
                });
                return Container(
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  height: MediaQuery.of(context).size.height * .4,
                  child: SingleChildScrollView(
                    controller: _sc,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: images,
                    ),
                  ),
                );
              }
              return Container(
                  height: MediaQuery.of(context).size.height * .1,
                  child: Center(
                    child: Text('No Sample Image',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                  ));
            }
            return Container(
                child: SizedBox(
              height: MediaQuery.of(context).size.height * .1,
            ));
          }
          return Container(
              child: SizedBox(
            height: MediaQuery.of(context).size.height * .1,
          ));
        });
  }

  Widget bidItemDetail(BidItem bidItem) {
    return FutureBuilder(
      future: DataController.getItemDetails(bidItem.bidItem),
      builder: (_, result) {
        if (result.connectionState == ConnectionState.done) {
          if (result.hasData) {
            return Container(
              margin: EdgeInsets.only(left: 5, right: 5),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Item Name: " + result.data[0]['itemName'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text("Description: " + result.data[0]['description'])
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "Budget Money: P " +
                              result.data[0]['itemPriceorBudget'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        getStatus(bidItem)
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        }
        return Container(
          child: Center(
            child: Text('Loading Details ...'),
          ),
        );
      },
    );
  }

  Widget bidderList(id) {
    return RefreshIndicator(
        displacement: 10.0,
        child: FutureBuilder<Map>(
          future: DataController.getBidders(id),
          builder: (_, result) {
            if (result.connectionState == ConnectionState.done) {
              if (result.hasData && result.data.isNotEmpty) {
                if (result.data[0] != 'NoConnection')
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                        controller: _sc,
                        itemCount: result.data.length,
                        itemBuilder: (_, index) {
                          return bidders(
                              result.data[index]['accountId'],
                              result.data[index]['suggestedItemId'],
                              result.data[index]['bidItemId']);
                        }),
                  );
                return Center(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text('No Connectivity'),
                  ),
                );
              }
              return Center(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text('No Participants Yet'),
                ),
              );
            }
            return Center(
              child: Align(
                alignment: Alignment.topCenter,
                child: Text('No Participants Yet'),
              ),
            );
          },
        ),
        onRefresh: refreshList);
  }

  Widget bidders(userId, suggestId, bidItemId) {
    return FutureBuilder(
        future: DataController.getBidderDetails(userId, suggestId),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            return ListTile(
              contentPadding: EdgeInsets.all(5),
              leading: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: snapshot.data[2].isNotEmpty
                        ? Image.network(
                            ImageController.getUserNetImage(
                                snapshot.data[2][0]['filename']),
                            fit: BoxFit.cover,
                            width: 53,
                          )
                        : Icon(
                            FontAwesome.user_circle_o,
                            color: Colors.blue,
                            size: 50,
                          ),
                  )),
              title: Text('' +
                  snapshot.data[0]['firstname'] +
                  ' ' +
                  snapshot.data[0]['lastname']),
              subtitle: Text(
                  "Item Price: P " + snapshot.data[1]['itemPriceorBudget']),
              trailing: IconButton(
                  icon: Icon(
                    Icons.message,
                    size: 45,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "BidChat",
                        arguments: BidChatDataHolder(
                            user: UserAccount.toObject(snapshot.data[0]),
                            bidItem: BidItem.toObject({'id': bidItemId})));
                  }),
              onTap: () {
                itemDetail(
                    snapshot.data[1], snapshot.data[3], snapshot.data[2]);
              },
            );
          }
          return Container();
        });
  }

  //Status Color Button
  Widget getStatusColor(BidItem bidItem){
    return FutureBuilder(
      future: DataController.getBidderManager(bidItem.id),
      builder: (_,snapshot){
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          if(snapshot.data[0]['bidStatus'] == '5'){
            return Container(
              margin: EdgeInsets.all(2),
              width: 70,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(150),color: Colors.green),
              child: Center(child: Text("Status"),),
            );
          }
          return Container(
            margin: EdgeInsets.all(2),
            width: 70,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(150),color: Colors.red),
            child: Center(child: Text("Status"),),
          );
        }
        return Container();
      }
    );
  }

  //Status Text
  Widget getStatus(BidItem bidItem){
    return FutureBuilder(
      future: DataController.getBidderManager(bidItem.id),
      builder: (_,snapshot){
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          if(snapshot.data[0]['bidStatus'] == '5') return Text("Status: Open");
          return Text("Status: Close");
        }
        return Container();
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    BidItem _bidItem = ModalRoute.of(context).settings.arguments;
    print(_bidItem.toMapWid().toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Bid Item"),
        actions: [
          SizedBox(width: MediaQuery.of(context).size.width * .4),
          FlatButton(
            padding: EdgeInsets.only(top: 5,bottom: 5),
            child: Stack(
              children: [
                Container(
                  width: 74,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(150),color: Colors.white),
                ),
                getStatusColor(_bidItem)
              ],
            ),
            onPressed: () {}
          ),
          IconButton(
            icon: Icon(Icons.delete,color: Colors.grey[100],size: 40,),
            onPressed: () {}
          ),
        ],
      ),
      body: ListView(
        controller: _sc,
        children: <Widget>[
          itemImages(_bidItem.bidItem),
          Divider(),
          bidItemDetail(_bidItem),
          Divider(),
          bidderList(_bidItem.id)
        ],
      ),
    );
  }
}

class BiddersItemDetail extends StatefulWidget {
  final Map item, images, userImage;
  BiddersItemDetail({Key key, this.item, this.images, this.userImage})
      : super(key: key);

  @override
  _BiddersItemDetailState createState() => _BiddersItemDetailState();
}

class _BiddersItemDetailState extends State<BiddersItemDetail> {
  Widget sampleImage(image) {
    return FlatButton(
        padding: EdgeInsets.only(right: 5),
        onPressed: () {
          imageFullSize(image);
        },
        child: Image.network(
          ImageController.getItemNetImage(image),
          fit: BoxFit.contain,
        ));
  }

  List images() {
    List<Widget> images = [];
    widget.images.forEach((key, value) {
      images.add(sampleImage(value['filename']));
    });
    return images;
  }

  List<Widget> getImages() {
    return widget.images.isEmpty
        ? [Center(child: Text("No Sample Image"))]
        : images();
  }

  Future<bool> imageFullSize(image) {
    return showDialog(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(bottom: 50),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Image.network(
                  ImageController.getItemNetImage(image),
                  fit: BoxFit.contain,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  userImage() {
    return Center(
      child: CircleAvatar(
          radius: 35,
          backgroundColor: Colors.blue,
          child: ClipOval(
            child: widget.userImage.isNotEmpty
                ? Image.network(
                    ImageController.getUserNetImage(
                        widget.userImage[0]['filename']),
                    fit: BoxFit.cover,
                    width: 70,
                  )
                : Icon(
                    FontAwesome.user_circle_o,
                    color: Colors.white,
                    size: 60,
                  ),
          )),
    );
  }

  itemImages() {
    return Container(
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, child: Row(children: getImages())),
    );
  }

  textContainer(key, value) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          key != 'Price'
              ? Text(key + ' : ',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ))
              : Text(key + ' : ',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  )),
          Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.height * .4,
        width: MediaQuery.of(context).size.width * .5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Divider(),
            userImage(),
            SizedBox(
              height: 5,
            ),
            Expanded(child: itemImages()),
            SizedBox(
              height: 5,
            ),
            textContainer('Item Name', widget.item['itemName']),
            textContainer('Condition', widget.item['description']),
            textContainer('Price', widget.item['itemPriceorBudget']),
            Divider(),
          ],
        ),
      ),
    );
  }
}

class BidChatScreen extends StatefulWidget {
  @override
  _BidChatScreenState createState() => _BidChatScreenState();
}

class _BidChatScreenState extends State<BidChatScreen> {
  BidChatDataHolder dataHolder;
  ScrollController _sc;
  TextEditingController text = TextEditingController();
  bool init = true, refresh = true;
  String userImage = 'No Image';

  @override
  initState() {
    super.initState();
    setState(() {});
  }

  refreshState() {
    setState(() => refresh = refresh ? false : true);
  }

  Future<Null> refreshMessage() async {
    Future.delayed(Duration(seconds: 1));
  }

  generateUserImg() async {
    Map image = await ImageController.fetchUserImage(dataHolder.user.id);
    userImage = image.isNotEmpty && image[0]['filename'] != 'null'
        ? image[0]['filename']
        : '';
    refreshState();
  }

  Widget other(text) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: MediaQuery.of(context).size.width * .8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  width: text.length > 50
                      ? MediaQuery.of(context).size.width * .7
                      : null,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(20))),
                  child: Text(text, softWrap: true, textAlign: TextAlign.left))
            ],
          ),
        ));
  }

  Widget you(text) {
    return Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: MediaQuery.of(context).size.width * .8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                  width: text.length > 50
                      ? MediaQuery.of(context).size.width * .7
                      : null,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(10))),
                  child: Text(text, softWrap: true, textAlign: TextAlign.right))
            ],
          ),
        ));
  }

  sendMessage() async {
    BidChat message = BidChat(
        bidItemId: dataHolder.bidItem.id,
        recieverId: dataHolder.user.id,
        senderId: dataHolder.user.id,
        message: text.text,
        messageType: '1',
        status: '9');
    Map result = await DataController.insertBidderMessage(message);
    if (result.containsKey('Connection'))
      LoadingScreen.showResultDialog(
          context, 'Cant Send to Internet Connection', 20);
    text.text = "";
    refreshState();
  }

  Widget inputText() {
    return Container(
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(FontAwesome.image), onPressed: () {}),
          Expanded(
              child: TextField(
            controller: text,
            maxLines: text.text.length > 22 ? 2 : text.text.length > 50 ? 3 : 1,
            decoration: InputDecoration(
              hintText: "Text Here",
            ),
          )),
          IconButton(
            icon: Icon(FontAwesome.send),
            onPressed: () => text.text != '' ? sendMessage() : null,
          )
        ],
      ),
    );
  }

  messageDisplay() {
    return RefreshIndicator(
        child: FutureBuilder<Map>(
            future: DataController.getBidderMessage(
                dataHolder.bidItem.id, dataHolder.user.id),
            builder: (_, snapshot) {
              if (userImage == 'No Image') generateUserImg();
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  List conversation = [];
                  if (snapshot.data.containsKey('Connection'))
                    return Container(
                      child: Text('No Internet Connection'),
                    );
                  if (snapshot.data.isEmpty) return Container();
                  snapshot.data
                      .forEach((key, value) => conversation.add(value));
                  return Container(
                    height: MediaQuery.of(context).size.height * .8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: conversation
                          .map((e) => e['senderId'] == dataHolder.user.id
                              ? other(e['message'])
                              : you(e['message']))
                          .toList(),
                    ),
                  );
                }
              }
              return Container();
            }),
        onRefresh: refreshMessage);
  }

  @override
  Widget build(BuildContext context) {
    dataHolder = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
                radius: 25,
                backgroundColor: Colors.blue,
                child: ClipOval(
                  child: userImage != '' && userImage != 'No Image'
                      ? Image.network(
                          ImageController.getUserNetImage(userImage),
                          fit: BoxFit.cover,
                          width: 50,
                        )
                      : Icon(
                          FontAwesome.user_circle_o,
                          color: Colors.white,
                          size: 40,
                        ),
                )),
            Text('\t\t' +
                dataHolder.user.firstname +
                ' ' +
                dataHolder.user.lastname)
          ],
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            child: FlatButton(
                onPressed: refreshState,
                child: Text(
                  "Refresh",
                  style: TextStyle(fontSize: 18),
                )),
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[Expanded(child: messageDisplay()), inputText()],
        ),
      ),
    );
  }
}

class BidChatDataHolder {
  UserAccount user;
  BidItem bidItem;

  BidChatDataHolder({this.user, this.bidItem});
}
