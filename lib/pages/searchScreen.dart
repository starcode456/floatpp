import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/constants.dart';
import 'package:float/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  static String routeName = 'SearchScreen';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<UserModel> userList;
  List<UserModel> recentList = [];
  String query = "";
  TextEditingController searchController = TextEditingController();
  UserModel currentUser;
  Future<List<UserModel>> fetchAllUsers() async {
    userList = List<UserModel>();

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != FirebaseAuth.instance.currentUser.uid) {
        setState(() {
          userList.add(UserModel.fromFirestore(querySnapshot.docs[i]));
        });
      }
      if (querySnapshot.docs[i].id == FirebaseAuth.instance.currentUser.uid) {
        setState(() {
          currentUser = UserModel.fromFirestore(querySnapshot.docs[i]);

          print(currentUser.recentusers);
        });
      }

      print(userList.length);
    }
    userList.forEach((user) {
      currentUser.recentusers.forEach((element) {
        if (user.userId == element) {
          recentList.add(user);
          print(recentList.length);
        }
      });
    });

    return userList;
  }

  void addtorecent(String userId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set(
      {
        'recentusers': FieldValue.arrayUnion([userId]),
      },
      SetOptions(merge: true),
    );
  }

  buildSuggestions(String query) {
    print(userList.length);
    final List<UserModel> suggestionList = query.isEmpty
        ? []
        : userList != null
            ? userList.where((UserModel user) {
                String _getUsername = user?.fullname?.toLowerCase();
                String _query = query?.toLowerCase();
                bool matchesUsername = _getUsername.contains(_query);
                return (matchesUsername);
              }).toList()
            : [];
    print(suggestionList.length);
    return query.isNotEmpty
        ? Column(
            children: [
              Row(
                //mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                    child: Text(
                      'Searching...',
                      // textAlign: TextAlign.left,
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(194, 194, 194, 1)),
                    ),
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: suggestionList.length,
                  itemBuilder: ((context, index) {
                    UserModel searchedUser = suggestionList[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          leading: Container(
                            height: 44,
                            width: 44,
                            child: CircleAvatar(
                              backgroundImage: searchedUser?.profilepic != null
                                  ? NetworkImage(searchedUser?.profilepic)
                                  : AssetImage(profileAssets + 'profile.png'),
                            ),
                          ),
                          //mini: false,
                          onTap: () {
                            Navigator.pop(context, searchedUser);
                            addtorecent(searchedUser.userId);
                          },

                          title: Text(
                            searchedUser.fullname ?? '',
                            style: GoogleFonts.lato(
                              color: Color.fromRGBO(74, 74, 74, 1),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        )
                      ],
                    );
                  }),
                ),
              )
            ],
          )
        : Container(
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                      child: Text(
                        'Recent',
                        // textAlign: TextAlign.left,
                        style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(194, 194, 194, 1)),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: recentList.length,
                    itemBuilder: ((context, index) {
                      UserModel searchedUser = recentList[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            leading: Container(
                              height: 44,
                              width: 44,
                              child: CircleAvatar(
                                backgroundImage: searchedUser?.profilepic !=
                                        null
                                    ? NetworkImage(searchedUser?.profilepic)
                                    : AssetImage(profileAssets + 'profile.png'),
                              ),
                            ),
                            //mini: false,
                            onTap: () {
                              Navigator.pop(context, searchedUser);
                              addtorecent(searchedUser.userId);
                            },

                            title: Text(
                              searchedUser.fullname ?? '',
                              style: GoogleFonts.lato(
                                color: Color.fromRGBO(74, 74, 74, 1),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          )
                        ],
                      );
                    }),
                  ),
                )
              ],
            ),
          );
  }

  @override
  void initState() {
    fetchAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: searchAppBar(context),
        // resizeToAvoidBottomPadding: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, bottom: 0),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 42,
                        width: MediaQuery.of(context).size.width * 0.835,
                        child: TextField(
                          style: GoogleFonts.lato(
                              color: Color.fromRGBO(140, 140, 140, 1),
                              fontWeight: FontWeight.w400,
                              fontSize: 18),
                          onChanged: (value) {
                            setState(() {
                              query = value;
                            });
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 26),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(151, 151, 151, 1),
                                    width: 0.8),
                                borderRadius: BorderRadius.all(
                                  const Radius.circular(30.0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(151, 151, 151, 1),
                                    width: 0.8),
                                borderRadius: BorderRadius.all(
                                  const Radius.circular(30.0),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(151, 151, 151, 1),
                                    width: 0.8),
                                borderRadius: BorderRadius.all(
                                  const Radius.circular(30.0),
                                ),
                              ),
                              //filled: true,
                              hintStyle: GoogleFonts.lato(
                                  color: Color.fromRGBO(140, 140, 140, 1),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18),
                              hintText: "Search Friends",
                              fillColor: Colors.white70),
                        ),
                      ),
                      IconButton(
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
                buildSuggestions(query)
              ],
            ),
          ),
        ));
  }
}