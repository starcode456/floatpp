import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:float/models/float_model.dart';
import 'package:float/models/resourceModel.dart';
import 'package:float/models_services/resources_service.dart';
import 'package:float/pages/resources/resourceInfo.dart';
import 'package:float/pages/resources/resource_discussion.dart';
import 'package:float/pages/resources/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants.dart';

class NoResourceYet extends StatefulWidget {
  final FloatModel floatModel;
  final String floatId;

  const NoResourceYet({Key key, this.floatModel, @required this.floatId})
      : super(key: key);
  @override
  _NoResourceYetState createState() => _NoResourceYetState();
}

class _NoResourceYetState extends State<NoResourceYet> {
  ResourceHelper resourceHelper = ResourceHelper();
  List<ResourceModel> allResoures = [];
  List<ResourceModel> filteredResources = [];
  bool isGettingAllResource = true;
  getInitialData() async {
    print(widget.floatId);
    filteredResources = [];
    allResoures = await resourceHelper.getAllResources() ?? [];
    widget.floatModel.resourceId.forEach((element1) {
      if (allResoures.firstWhere((element) => element.id == element1,
              orElse: null) !=
          null) {
        filteredResources.add(
          allResoures.firstWhere((element) => element.id == element1),
        );
      }
    });
    setState(() {
      isGettingAllResource = false;
    });
  }

  @override
  void initState() {
    getInitialData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //  toolbarHeight: 100,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.info_outline,
            color: Colors.white,
          ),
          onPressed: () => Get.to(ResourceInfo()),
        ),
        title: Image.asset(
          "assets/resource/bookIcon.png",
          width: 34,
          height: 44,
        ),
        backgroundColor: Color(0xffdeb4fc),
        actions: [
          IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment(0.5, 0),
                    end: Alignment(0.5, 1),
                    colors: [
              const Color(0xffdeb4fc),
              const Color(0xffce82fe)
            ]))),
      ),
      backgroundColor: Colors.white,
      body: isGettingAllResource
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 30, right: 20, left: 20),
                      child: Text(
                        "${widget.floatModel.title}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              color: const Color(0xff373737),
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              fontSize: 24.0),
                        ),
                      ),
                    ),
                    widget.floatModel.resourceId.length != 0
                        ? resourcesList()
                        : Container(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 50,
                                ),
                                Image.asset(
                                  "assets/resource/resource.png",
                                  height: 260,
                                  width: 213,
                                ),
                                SizedBox(
                                  height: 57,
                                ),
                                Text(
                                  "You have no book chats yet",
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        color: const Color(0xffafafaf),
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 24.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: InkWell(
        onTap: () => Get.to(ResourceSearchScreen(
          floatId: widget.floatId,
        )),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.15,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Color(0xff3d97eb),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50.0),
                topRight: Radius.circular(50.0),
              )),
          child: Center(
              child: Text("Find A Book Chat",
                  style: GoogleFonts.lato(
                      color: const Color(0xffffffff),
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 26.0),
                  textAlign: TextAlign.center)),
        ),
      ),
    );
  }

  Widget resultBox(int index, ResourceModel resourceModel) {
    print(resourceModel.image);
    return Padding(
      padding: const EdgeInsets.only(left: 22.0, top: 10, bottom: 10),
      child: Container(
        //  padding: const EdgeInsets.fromLTRB(18, 10, 0, 10),
        width: double.infinity,
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Container(
            height: 96,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(57),
                    bottomLeft: Radius.circular(57)),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0x80000000),
                      offset: Offset(0, 1),
                      blurRadius: 1,
                      spreadRadius: 0)
                ],
                color: const Color(0xffffffff)),
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
                    border:
                        Border.all(color: const Color(0xffdbdbdb), width: 0.4),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 8, top: 16, bottom: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${resourceModel.title}",
                          style: GoogleFonts.lato(
                              color: const Color(0xff4a4a4a),
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0)),
                      SizedBox(
                        height: 8,
                      ),
                      Expanded(
                        child: resourceModel.userImages.length == 0
                            ? Text("Be the first to post in this Book Chat",
                                style: const TextStyle(
                                    color: const Color(0xffb0b2be),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Lato",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0))
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: resourceModel.userImages.length > 4
                                    ? 5
                                    : resourceModel.userImages.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 2),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 22.0, left: 10),
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
            //         padding: EdgeInsets.only(left: 20),
            //         child: Image.asset(
            //           "assets/resource/book_img.jpg",
            //           height: 78,
            //           width: 52,
            //         ),
            //       ),
            //       SizedBox(
            //         width: 10,
            //       ),
            //       Container(
            //         width: 1,
            //         height: 78,
            //         decoration: BoxDecoration(
            //           border:
            //               Border.all(color: const Color(0xffdbdbdb), width: 0.4),
            //         ),
            //       )
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
            //                   padding:
            //                       const EdgeInsets.only(bottom: 0.0, left: 2),
            //                   child: CircleAvatar(
            //                     backgroundImage:
            //                         AssetImage("assets/resource/images.jpg"),
            //                     radius: 17.5,
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
          secondaryActions: <Widget>[
            Container(
              child: IconSlideAction(
                color: Color(0xff05dfeb),
                iconWidget: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment(0.5, 0),
                            end: Alignment(0.5, 1),
                            colors: [
                          Color.fromRGBO(255, 92, 131, 1),
                          Color.fromRGBO(208, 2, 28, 1)
                        ])),
                    alignment: Alignment.center,
                    child: // Leave
                        Text("Leave",
                            style: GoogleFonts.lato(
                                color: const Color(0xffffffff),
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                fontSize: 18.0))),
                onTap: () {
                  removeResource(resourceModel.id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  removeResource(String resourceId) async {
    await FirebaseFirestore.instance
        .collection(Keys.floats)
        .doc(widget.floatId)
        .update({
      'resourceId': FieldValue.arrayRemove([resourceId])
    });
    Get.back();
  }

  Widget resourcesList() {
    return Container(
      height: Get.height * 0.6,
      //width: double.infinity,
      child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 40),
          scrollDirection: Axis.vertical,
          itemCount: filteredResources.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
                onTap: () => Get.to(ResourceDiscussionScreen(
                      resourceModel: filteredResources[index],
                    )),
                child: resultBox(index, filteredResources[index]));
          }),
    );
  }
}
