import 'package:float/app_utils/static_info.dart';
import 'package:float/models/resourceModel.dart';
import 'package:float/models_services/resources_service.dart';
import 'package:float/pages/resources/submit_resource.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ResourceSearchScreen extends StatefulWidget {
  final String floatId;

  const ResourceSearchScreen({Key key, @required this.floatId})
      : super(key: key);
  @override
  _ResourceSearchScreenState createState() => _ResourceSearchScreenState();
}

class _ResourceSearchScreenState extends State<ResourceSearchScreen> {
  ResourceHelper resourceHelper = ResourceHelper();
  TextEditingController searchText = TextEditingController();
  List<ResourceModel> allResoures = [];
  List<ResourceModel> filteredResources = [];
  List<String> suggestions = ['french', "english", "science"];
  int selectedIndex = 1;
  String selected = "english";
  String value = 'english';
  List<String> MatchFound = [];
  bool showBottom = false;
  bool showResult = false;
  TextEditingController searchController = TextEditingController();
  bool isAddingResource = false;
  @override
  void initState() {
    getInitialData();
    super.initState();
  }

  getInitialData() async {
    allResoures = await resourceHelper.getAllResources();
  }

  addResource(String resourceId) async {
    setState(() {
      isAddingResource = true;
    });
    var res = await resourceHelper.addResourceToFloat(
        widget.floatId, resourceId,
        userProfile: StaticInfo.userModel.profilepic);
    if (res == true) {
      Fluttertoast.showToast(msg: 'Resources added succesfully');
      setState(() {
        isAddingResource = false;
      });
      Get.back();
      Get.back();
    } else {
      Fluttertoast.showToast(msg: 'An error occured');
      setState(() {
        isAddingResource = false;
      });
    }
  }

  final List<String> allSubjects = [
    'Accounting',
    'Art & Des',
    'Classical',
    'Education',
    'Geography',
    'Languages',
    'Aerospace',
    'Sciences',
    'Computer',
    'English',
    'Geology',
    'Law',
    'Agriculture',
    'Business',
    'Creative',
    'Film',
    'History',
    'Marketing',
    'Archaelogy',
    'Engineering',
    'Dentistry',
    'Finance',
    'Hospitality',
    'Maths',
    'Architecture',
    'Chemistry',
    'Economics',
    'Games',
    'Journalism',
    'Media',
    'Medicine',
    'Midwifery',
    'Biology',
    'Music',
    'Nursing',
    'Optometry',
    'Paramedic',
    'Pharmacy',
    'Philosophy',
    'Physiology',
    'Politics',
    'Psychology',
    'Publishing',
    'Radiography',
    'S Studies',
    'Social Work',
    'Software',
    'Sport',
    'Teaching',
    'Theology',
    'Veternary',
    'Zoology'
  ];

  showBottomSheet(String resourceId) {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: new Container(
                // height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.grey,
                            ),
                            onPressed: () => Navigator.pop(context))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text("💪🏾",
                              style: const TextStyle(
                                  color: const Color(0xff8c8c8c),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "AppleColorEmoji",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 63.0)),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            'Add book?',
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(64, 64, 64, 1),
                                fontSize: 30),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: Text(
                            'Connect this book to your essay. See\nwhat others are saying too.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                                color: Color.fromRGBO(64, 64, 64, 1),
                                fontSize: 16),
                          ),
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Get.back();
                        addResource(resourceId);
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.12,
                        decoration: BoxDecoration(
                          color: Color(0xff3d97eb),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(42),
                              topRight: Radius.circular(42)),
                        ),
                        child: Center(
                          child: Text(
                            'I want to add this book',
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 24),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          );
        });
  }

  List<String> getCommaSeperatedString() {
    List<String> abc = searchController.text.split(',');
    return abc;
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isAddingResource,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, bottom: 0),
                  child: Row(
                    children: [
                      Container(
                        width: Get.width * 0.835,
                        height: 42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(21)),
                          border: Border.all(
                            color: const Color(0xff979797),
                            width: 0.4,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: Get.width * 0.61,
                              child: TextField(
                                style: GoogleFonts.lato(
                                    color: Color.fromRGBO(140, 140, 140, 1),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18),
                                onChanged: (val) {
                                  if (val.isNotEmpty) {
                                    filteredResources = [];
                                    filteredResources.addAll(allResoures
                                        .where((element) =>
                                            (element.title
                                                    .toLowerCase()
                                                    .contains(
                                                        val.toLowerCase()) ||
                                                element.tags
                                                    .join(',')
                                                    .toLowerCase()
                                                    .contains(
                                                        val.toLowerCase())) &&
                                            element.subject
                                                .toLowerCase()
                                                .contains(value.toLowerCase()))
                                        .toList());
                                    showResult = true;
                                    setState(() {
                                      MatchFound = suggestions
                                          .where((element) => (element
                                              .toLowerCase()
                                              .contains(val.toLowerCase())))
                                          .toList();
                                    });
                                  } else {
                                    filteredResources = [];
                                    showResult = false;
                                    setState(() {});
                                  }
                                },
                                controller: searchController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        left: 15,
                                        bottom: 11,
                                        top: 00,
                                        right: 15),
                                    hintStyle: GoogleFonts.lato(
                                        color: const Color(0xff8c8c8c),
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 15.0),
                                    hintText: "Seperate key words by comma",
                                    fillColor: Colors.white70),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _modalBottomSheetMenu(context);
                                setState(() {
                                  showBottom = true;
                                });
                              },
                              child: Container(
                                width: Get.width * 0.21,
                                height: 31,
                                decoration: BoxDecoration(
                                  color: getSubjectColor(value).bgColor,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(21),
                                    bottomRight: Radius.circular(21),
                                  ),
                                ),
                                child: Center(
                                  child: Text("$value",
                                      style: GoogleFonts.lato(
                                          color:
                                              getSubjectColor(value).textColor,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0),
                                      textAlign: TextAlign.center),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(
                            Icons.clear,
                            color: Color.fromRGBO(140, 140, 140, 1),
                          ),
                          onPressed: () {
                            FocusManager.instance.primaryFocus.unfocus();
                            Navigator.of(context).pop();
                          })
                    ],
                  ),
                ),
                Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    showResult
                        ? Container(
                            height: 31,
                            padding: EdgeInsets.only(left: 22),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: getCommaSeperatedString().length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                print(getCommaSeperatedString());
                                return
                                    // suggestions[index] == value
                                    //     ? Container()
                                    //     :
                                    sugesstion(
                                        getCommaSeperatedString()[index]);
                              },
                            ),
                          )
                        : Container(),
                    searchController.text.isNotEmpty &&
                            filteredResources.length > 0
                        ? Container(
                            margin: EdgeInsets.only(
                                top: 8, bottom: 14, right: 12, left: 22),
                            width: double.infinity,
                            child: Text(
                              "Swipe left to add resource",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    color: const Color(0xffb0b2be),
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                              ),
                            ),
                          )
                        : searchController.text.isNotEmpty
                            ? SingleChildScrollView(
                                physics: NeverScrollableScrollPhysics(),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                      ),
                                      Text("Nothing has come up yet",
                                          style: GoogleFonts.lato(
                                              color: const Color(0xffafafaf),
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 24.0),
                                          textAlign: TextAlign.center),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Get.to(SubmitResource());
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xff50c53f),
                                            borderRadius:
                                                BorderRadius.circular(31.5),
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.85,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15.0),
                                          child: Center(
                                            child: Text("Submit a book title",
                                                style: GoogleFonts.lato(
                                                    color:
                                                        const Color(0xffffffff),
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 22.0),
                                                textAlign: TextAlign.center),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                    filteredResources.length > 0
                        ? Container(
                            width: double.infinity,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: filteredResources.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return resultBox(
                                      index, filteredResources[index]);
                                }),
                          )
                        : Container(),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.02,
                  ),
                  child: Column(
                    children: [
                      showResult == false
                          ? Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.03,
                              ),
                              child: Text("Tap to change subject",
                                  style: GoogleFonts.lato(
                                      color: const Color(0xffc2c2c2),
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 24.0),
                                  textAlign: TextAlign.center),
                            )
                          : Container(),
                      searchController.text.isEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.1,
                              ),
                              child: Image.asset(
                                "assets/resource/resource.png",
                                width: 140,
                                height: 171,
                                scale: 3.0,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget SearchBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.black)),
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.57,
                margin: EdgeInsets.only(left: 12),
                padding: EdgeInsets.only(bottom: 5),
                child: TextFormField(
                    onChanged: (val) {
                      if (val.isNotEmpty) {
                        showResult = true;
                        setState(() {
                          MatchFound = suggestions
                              .where((element) => (element
                                  .toLowerCase()
                                  .contains(val.toLowerCase())))
                              .toList();
                        });
                      }
                    },
                    controller: searchController,
                    decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      border: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: 'Separate key words by comma',
                      hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w400),
                    validator: (txt) {
                      if (searchController.text.isEmpty) {
                        return 'Invalid';
                      }
                      return "";
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 3, top: 3, bottom: 3),
                child: GestureDetector(
                  onTap: () {
                    showBottom = true;
                    setState(() {});
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    decoration: BoxDecoration(
                        color: const Color(0xffedd1ff),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(50.0),
                          topRight: Radius.circular(50.0),
                        )),
                    child: Center(
                        child: Text(
                      selected,
                      style: TextStyle(fontSize: 12),
                    )),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          height: 20,
          width: 20,
          margin: EdgeInsets.only(bottom: 16),
          child: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  MatchFound = [];
                  searchText.clear();
                });
              }),
        ),
      ],
    );
  }

  Widget sugesstion(String text) {
    return Container(
      //margin: EdgeInsets.all(2),
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(1.996500000000001)),
            color: getSubjectColor(text).bgColor,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 14.0, right: 14),
              child: Text("$text",
                  style: GoogleFonts.lato(
                      color: getSubjectColor(text).textColor,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0),
                  textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> _modalBottomSheetMenu(BuildContext context) {
    TextStyle _textStyle = GoogleFonts.lato(
        color: const Color(0xff4a4a4a),
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        fontSize: 18.0);
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        color: Colors.white,
        height: Get.height * 0.35,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.lato(
                            fontSize: 18,
                            color: Colors.grey,
                            decoration: TextDecoration.none),
                      )),
                  GestureDetector(
                    onTap: () {
                      setState(() {});
                      Get.back();
                    },
                    child: Text(
                      "Done",
                      style: GoogleFonts.lato(
                          color: Color(0xff02bbd3),
                          fontSize: 18,
                          decoration: TextDecoration.none),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: Get.height * 0.25,
              child: CupertinoPicker(
                  selectionOverlay: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Divider(),
                        SizedBox(
                          height: 38,
                        ),
                        Divider()
                      ],
                    ),
                  ),
                  children: allSubjects
                      .map((e) => Center(
                              child: Text(
                            "$e",
                            style: _textStyle,
                          )))
                      .toList(),
                  //   [
                  //   Center(
                  //       child: Text(
                  //     "French",
                  //     style: _textStyle,
                  //   )),
                  //   Center(
                  //       child: Text(
                  //     'English',
                  //     style: _textStyle,
                  //   )),
                  //   Center(
                  //       child: Text(
                  //     'Science',
                  //     style: _textStyle,
                  //   )),
                  // ],
                  scrollController:
                      FixedExtentScrollController(initialItem: selectedIndex),
                  itemExtent: 70.0,
                  looping: false,
                  //diameterRatio: 200.1,

                  //magnification: 1.5,
                  squeeze: 1.45,
                  backgroundColor: Colors.white,
                  onSelectedItemChanged: (item) {
                    value = allSubjects[item];
                    // selectedIndex = item;
                    // if (item == 0) {
                    //   value = 'french';
                    // } else if (item == 1) {
                    //   value = 'english';
                    // } else {
                    //   value = 'Science';
                    // }
                    setState(() {});
                    print(value);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget resultBox(int index, ResourceModel resourceModel) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 0, 10),
      width: double.infinity,
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: Container(
          height: 96,
          child: Padding(
            padding: EdgeInsets.only(left: 0),
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(57.0),
                    topLeft: Radius.circular(57.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0x80939393),
                        offset: Offset(0, 1),
                        blurRadius: 3,
                        spreadRadius: 0)
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        EdgeInsets.only(left: 38, top: 9, bottom: 9, right: 14),
                    child: resourceModel.image.isEmpty
                        ? Image.asset(
                            "assets/resource/defaultResource.png",
                            height: 78,
                            width: 52,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            resourceModel.image,
                            // "assets/resource/book_img.jpg",
                            height: 78,
                            width: 52,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Container(
                    width: 1,
                    height: 78,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color(0xffdbdbdb), width: 0.4),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 8, top: 16, bottom: 18),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: Get.width * 0.5,
                          child: Text("${resourceModel.title}",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.lato(
                                  color: const Color(0xff4a4a4a),
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 17.0)),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Expanded(
                          child: resourceModel.userImages.length == 0
                              ? Text("Be the first to post in this Book Chat",
                                  style: GoogleFonts.lato(
                                      color: const Color(0xffb0b2be),
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 15.0))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: resourceModel.userImages.length > 4
                                      ? 5
                                      : resourceModel.userImages.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            resourceModel.userImages[index]),
                                        radius: 16.5,
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                  resourceModel.userImages.length == 0
                      ? Container()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 22.0, left: 10),
                              child: Text(
                                  resourceModel.userImages.length > 4
                                      ? "+${resourceModel.userImages.length - 5}"
                                      : '',
                                  style: GoogleFonts.lato(
                                      color: const Color(0xff3f3f3f),
                                      fontWeight: FontWeight.w900,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 22.0),
                                  textAlign: TextAlign.center),
                            ),
                          ],
                        )
                ],
              ),

              // ListTile(
              //   leading: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Container(
              //         height: 70,
              //         padding: EdgeInsets.only(left: 20),
              //         child: Image.asset("assets/resource/book_img.jpg"),
              //       ),
              //       SizedBox(
              //         width: 10,
              //       ),
              //       Container(
              //           width: 1,
              //           height: 78,
              //           decoration: BoxDecoration(
              //               border: Border.all(
              //                   color: const Color(0xffdbdbdb), width: 0.4)))
              //     ],
              //   ),
              //   title: Text("${resourceModel.title}",
              //       style: GoogleFonts.lato(
              //           color: const Color(0xff4a4a4a),
              //           fontWeight: FontWeight.w700,
              //           fontStyle: FontStyle.normal,
              //           fontSize: 16.0)),
              //   subtitle: Container(
              //     height: 75,
              //     alignment: Alignment.center,
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         ListView.builder(
              //           shrinkWrap: true,
              //           physics: NeverScrollableScrollPhysics(),
              //           scrollDirection: Axis.horizontal,
              //           itemCount: 5,
              //           itemBuilder: (BuildContext context, int index) {
              //             return Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               crossAxisAlignment: CrossAxisAlignment.center,
              //               children: [
              //                 Padding(
              //                   padding: const EdgeInsets.only(
              //                       bottom: 0.0, left: 2),
              //                   child: CircleAvatar(
              //                     backgroundImage: AssetImage(
              //                         "assets/resource/images.jpg"),
              //                     radius: 18.0,
              //                   ),
              //                 ),
              //               ],
              //             );
              //           },
              //         ),
              //         Text("+39",
              //             style: GoogleFonts.lato(
              //                 color: const Color(0xff3f3f3f),
              //                 fontWeight: FontWeight.w900,
              //                 fontStyle: FontStyle.normal,
              //                 fontSize: 22.0),
              //             textAlign: TextAlign.center)
              //       ],
              //     ),
              //   ),
              // ),
            ),
          ),
        ),
        secondaryActions: <Widget>[
          Container(
            child: IconSlideAction(
              color: Color(0xff05dfeb),
              iconWidget: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xff3d97eb),
                  ),
                  alignment: Alignment.center,
                  child: Text("Join",
                      style: GoogleFonts.lato(
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 18.0))),
              onTap: () {
                showBottomSheet(resourceModel.id);
              },
            ),
          ),
        ],
      ),
    );
  }

  SubjectColors getSubjectColor(String subject) {
    if (subject.length > 0) {
      String firstLetter = subject[0].toLowerCase();
      if (firstLetter == 'a') {
        return SubjectColors(
          bgColor: Color(0xffedd1ff),
          textColor: Color(0xffbc63ff),
        );
      } else if (firstLetter == 'b') {
        return SubjectColors(
          bgColor: Color(0xffd1d3ff),
          textColor: Color(0xff6e6eff),
        );
      } else if (firstLetter == 'c' || firstLetter == 'd') {
        return SubjectColors(
          bgColor: Color(0xffffc998),
          textColor: Color(0xfffa6400),
        );
      } else if (firstLetter == 'e' || firstLetter == 'f') {
        return SubjectColors(
          bgColor: Color(0xff98ffb7),
          textColor: Color(0xff257e3d),
        );
      } else if (firstLetter == 'g' ||
          firstLetter == 'h' ||
          firstLetter == 'j') {
        return SubjectColors(
          bgColor: Color(0xff98fff5),
          textColor: Color(0xff356f8b),
        );
      } else if (firstLetter == 'k' ||
          firstLetter == 'l' ||
          firstLetter == 'm') {
        return SubjectColors(
          bgColor: Color(0xffff98ad),
          textColor: Color(0xffa12722),
        );
      } else if (firstLetter == 'n' || firstLetter == 'o') {
        return SubjectColors(
          bgColor: Color(0xd398f1ff),
          textColor: Color(0xff2e49ae),
        );
      } else if (firstLetter == 'p' || firstLetter == 'r') {
        return SubjectColors(
          bgColor: Color(0xd3c0c0c0),
          textColor: Color(0xff494949),
        );
      } else {
        return SubjectColors(
          bgColor: Color(0xd3e9f2ac),
          textColor: Color(0xffbb8900),
        );
      }
    } else {
      return SubjectColors(
        bgColor: Color(0xd3e9f2ac),
        textColor: Color(0xffbb8900),
      );
    }
  }
}

class SubjectColors {
  Color bgColor;
  Color textColor;
  SubjectColors({this.bgColor, this.textColor});
}
