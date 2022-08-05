
import 'package:float/models_providers/notifications_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsPage extends StatefulWidget {
  NotificationsPage({Key key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool showNotifications = true;

  @override
  void initState() {
    getNotificationStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Notifications', 
            style: GoogleFonts.lato(
              color: Colors.black, 
              fontSize: 22, 
              fontWeight: FontWeight.bold
            )
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          // automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: <Widget>[],
        ),
        body: Container(
          child: SwitchListTile(
            title: Container(
              child: Text(
                'Show Notifications',
                style: GoogleFonts.lato()
              )
            ),
            value: showNotifications,
            onChanged: (val) async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('showNotifications', val);
              showNotifications = val;
              if (!showNotifications) Provider.of<NotificationsProvider>(context, listen: false).cancleAllNotifications();
              setState(() {});
            },
          ),
        ));
  }

  void getNotificationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    showNotifications = prefs.getBool('showNotifications') ?? true;

    setState(() {});
  }
}
