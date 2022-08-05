import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:float/app_utils/static_info.dart';
import 'package:float/constants.dart';
import 'package:float/models/comment_model.dart';
import 'package:float/models/flag_model.dart';
import 'package:float/models/resourceModel.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceDiscussionScreen extends StatefulWidget {
  final ResourceModel resourceModel;

  const ResourceDiscussionScreen({Key key, this.resourceModel})
      : super(key: key);
  @override
  _ResourceDiscussionScreenState createState() =>
      _ResourceDiscussionScreenState();
}

class _ResourceDiscussionScreenState extends State<ResourceDiscussionScreen> {
  TextEditingController commentController = TextEditingController();
  String selectedCommentId = '';
  CommentModel selectedCommentModel = CommentModel();
  final StreamController<List<CommentModel>> _commentStreamCtrl =
      StreamController<List<CommentModel>>.broadcast();
  Stream<List<CommentModel>> get commentsStream => _commentStreamCtrl.stream;
  void getCurrentComments() async {
    FirebaseFirestore.instance
        .collection(Keys.discussion)
        .doc(widget.resourceModel.id)
        .collection(Keys.comments)
        .snapshots()
        .listen((event) {
      if (event != null) {
        List<CommentModel> allComments = [];
        event.docs.forEach((element) {
          print(element.data());
          allComments.add(CommentModel.fromMap(element.data()));
        });
        if (!_commentStreamCtrl.isClosed) {
          _commentStreamCtrl.sink.add(allComments.reversed.toList());
          setState(() {});
        }
      }
    });
  }

  reportMessage(CommentModel commentModel, ReplyModel replyModel) {
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
                          child: Text("😖",
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
                            child: // Offensive
                                Text("Offensive",
                                    style: GoogleFonts.lato(
                                        color: const Color(0xff404040),
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 34.0),
                                    textAlign: TextAlign.center))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: Text(
                            'Why isn’t this person talking about\nthe resource. Seriously?',
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
                      onTap: () async {
                        FlagModel flagModel;
                        if (replyModel == null) {
                          flagModel = FlagModel(
                              commentId: commentModel.id,
                              commentText: commentModel.comment,
                              isReply: false,
                              date: Timestamp.now(),
                              flagId: commentModel.id,
                              replyModel: null,
                              resourceId: widget.resourceModel.id,
                              subject: widget.resourceModel.subject);
                        } else {
                          flagModel = FlagModel(
                              commentId: replyModel.commentId,
                              isReply: true,
                              commentText: replyModel.comment,
                              date: Timestamp.now(),
                              flagId: replyModel.id,
                              replyModel: replyModel,
                              resourceId: widget.resourceModel.id,
                              subject: widget.resourceModel.subject);
                        }

                        await FirebaseFirestore.instance
                            .collection(Keys.flags)
                            .doc(flagModel.flagId)
                            .set(flagModel.toMap());
                        Get.back();
                        // addResource(resourceId);
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
                            'Send Flag',
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

  sendMessage(String value) async {
    if (value.isEmpty) {
      Fluttertoast.showToast(msg: 'Comment can\'t be empty');
      return;
    }
    if (selectedCommentId.isEmpty) {
      String id = DateTime.now().microsecondsSinceEpoch.toString();
      CommentModel commentModel = CommentModel(
        comment: commentController.text,
        isReply: false,
        userName: StaticInfo.userModel.fullname,
        userProfile: StaticInfo.userModel.profilepic,
        commnetTime: Timestamp.now(),
        id: id,
      );
      commentController.text = '';
      selectedCommentId = '';
      await FirebaseFirestore.instance
          .collection(Keys.discussion)
          .doc(widget.resourceModel.id)
          .collection(Keys.comments)
          .doc(commentModel.id)
          .set(commentModel.toMap());
    } else {
      String id = DateTime.now().microsecondsSinceEpoch.toString();
      ReplyModel replyModel = ReplyModel(
          comment: commentController.text,
          isReply: true,
          userName: StaticInfo.userModel.fullname,
          userProfile: StaticInfo.userModel.profilepic,
          commnetTime: Timestamp.now(),
          id: id,
          commentId: selectedCommentId);
      commentController.text = '';

      await FirebaseFirestore.instance
          .collection(Keys.discussion)
          .doc(widget.resourceModel.id)
          .collection(Keys.comments)
          .doc(selectedCommentId)
          .update({
        'replies': FieldValue.arrayUnion([replyModel.toMap()])
      });
      selectedCommentId = '';
    }
  }

  setReplyMessage(String userName, String commentId) {
    commentController.text = '@$userName ';
    selectedCommentId = commentId;
  }

  @override
  void initState() {
    getCurrentComments();
    super.initState();
  }

  @override
  void dispose() {
    _commentStreamCtrl.close();
    super.dispose();
  }

  launchUrl(String url) async {
    try {
      await launch(url);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.resourceModel.title,
          style: GoogleFonts.lato(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.shopping_bag_outlined,
            color: Colors.white,
          ),
          onPressed: () {
            launchUrl(widget.resourceModel.link);
          },
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.white,
            ),
            onPressed: () => Get.back(),
          )
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
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: StreamBuilder<List<CommentModel>>(
            stream: commentsStream,
            builder: (context, snapshot) {
              // print(snapshot.data.length);
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {}
              return ListView.builder(
                reverse: true,
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  CommentModel commentModel = snapshot.data[index];
                  return Slidable(
                    actionPane: SlidableStrechActionPane(),
                    actionExtentRatio: 0.22,
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        iconWidget: Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment(0.5, 0),
                                    end: Alignment(0.5, 1),
                                    colors: [
                                  const Color(0xffa8fff3),
                                  const Color(0xff00abaf)
                                ])),
                            child: Center(
                              child: Text("📭",
                                  style: const TextStyle(
                                      color: const Color(0xff9b9b9b),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "AppleColorEmoji",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 19.2)),
                            )),
                        onTap: () {
                          setReplyMessage(
                            commentModel.userName,
                            commentModel.id,
                          );
                        },
                      ),
                      IconSlideAction(
                        iconWidget: Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment(0.5, 0),
                                    end: Alignment(0.5, 1),
                                    colors: [
                                  const Color(0xffdfdfdf),
                                  const Color(0xff616161)
                                ])),
                            child: Center(
                              child: Text("😖",
                                  style: const TextStyle(
                                      color: const Color(0xff9b9b9b),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "AppleColorEmoji",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 19.2)),
                            )),
                        onTap: () => reportMessage(commentModel, null),
                      )
                    ],
                    child: Column(
                      children: [
                        CommentWidget(
                          commentModel: commentModel,
                          setReplyMessage: setReplyMessage,
                          reportMessage: reportMessage,
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
      ),
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: Get.height * 0.12,
          child: Column(children: [
            Divider(),
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage:
                          StaticInfo.userModel?.profilepic == null ||
                                  StaticInfo.userModel?.profilepic.isEmpty
                              ? AssetImage(
                                  profileAssets + 'profile.png',
                                )
                              : NetworkImage(StaticInfo.userModel.profilepic),
                    ),
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
                      child: Container(
                        width: Get.width * 0.61,
                        child: TextField(
                          controller: commentController,
                          style: GoogleFonts.lato(
                              color: Color.fromRGBO(140, 140, 140, 1),
                              fontWeight: FontWeight.w400,
                              fontSize: 18),
                          onSubmitted: (value) async {
                            await sendMessage(value);
                          },

                          onChanged: (val) {
                            if (val.isEmpty) {
                              selectedCommentId = '';
                            }
                          },
                          // controller: searchController,
                          textInputAction: TextInputAction.send,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 00, right: 15),
                              hintStyle: GoogleFonts.lato(
                                  color: const Color(0xff8c8c8c),
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 15.0),
                              hintText: "Join the discussion",
                              fillColor: Colors.white70),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  const CommentWidget({
    Key key,
    @required this.commentModel,
    @required this.reportMessage,
    this.setReplyMessage,
  }) : super(key: key);

  final CommentModel commentModel;
  final Function setReplyMessage;
  final Function reportMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                        radius: 24,
                        backgroundImage: commentModel.userProfile.isEmpty
                            ? AssetImage(profileAssets + 'profile.png')
                            : NetworkImage(commentModel.userProfile)),
                  ],
                ),
                Container(
                  width: commentModel.comment.contains('@')
                      ? Get.width * 0.7
                      : Get.width * 0.8,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${commentModel.userName}",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.lato(
                              color: const Color(0xff9b9b9b),
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0)),
                      Text("${commentModel.comment}",
                          style: GoogleFonts.lato(
                              color: const Color(0xff4a4a4a),
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0))
                    ],
                  ),
                )
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 20),
          //   child: Container(
          //       width: 397.5,
          //       height: 1,
          //       decoration: BoxDecoration(
          //           border: Border.all(
          //               color: const Color(0xffcecece), width: 0.4))),
          // ),
          ListView.builder(
            //  reverse: true,
            itemCount: commentModel.replies.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              commentModel.replies.sort((b, a) =>
                  a.commnetTime.toDate().compareTo(b.commnetTime.toDate()));
              ReplyModel replyModel = commentModel.replies[index];
              return Slidable(
                actionPane: SlidableStrechActionPane(),
                actionExtentRatio: 0.22,
                secondaryActions: <Widget>[
                  IconSlideAction(
                    iconWidget: Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment(0.5, 0),
                                end: Alignment(0.5, 1),
                                colors: [
                              const Color(0xffa8fff3),
                              const Color(0xff00abaf)
                            ])),
                        child: Center(
                          child: Text("📭",
                              style: const TextStyle(
                                  color: const Color(0xff9b9b9b),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "AppleColorEmoji",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 19.2)),
                        )),
                    onTap: () {
                      setReplyMessage(
                        replyModel.userName,
                        replyModel.commentId,
                      );
                    },
                  ),
                  IconSlideAction(
                    iconWidget: Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment(0.5, 0),
                                end: Alignment(0.5, 1),
                                colors: [
                              const Color(0xffdfdfdf),
                              const Color(0xff616161)
                            ])),
                        child: Center(
                          child: Text("😖",
                              style: const TextStyle(
                                  color: const Color(0xff9b9b9b),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "AppleColorEmoji",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 19.2)),
                        )),
                    onTap: () => reportMessage(null, replyModel),
                  )
                ],
                child: ReplyWidget(replyModel: replyModel),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ReplyWidget extends StatelessWidget {
  const ReplyWidget({
    Key key,
    @required this.replyModel,
  }) : super(key: key);

  final ReplyModel replyModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
                top: 10, left: Get.width * 0.1, right: 10, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                        radius: 24,
                        backgroundImage: replyModel.userProfile.isEmpty
                            ? AssetImage(profileAssets + 'profile.png')
                            : NetworkImage(replyModel.userProfile)),
                  ],
                ),
                Container(
                  width: replyModel.comment.contains('@')
                      ? Get.width * 0.7
                      : Get.width * 0.8,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${replyModel.userName}",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.lato(
                              color: const Color(0xff9b9b9b),
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0)),
                      Text("${replyModel.comment}",
                          style: GoogleFonts.lato(
                              color: const Color(0xff4a4a4a),
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0))
                    ],
                  ),
                )
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 20),
          //   child: Divider(),
          // ),
        ],
      ),
    );
  }
}
