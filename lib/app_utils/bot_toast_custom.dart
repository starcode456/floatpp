// import 'package:bot_toast/bot_toast.dart';
// import 'package:flutter/material.dart';

// class BotToastCustom {
//   static loadingShow() async {
//     await loadingClose();
//     BotToast.showCustomLoading(
//         toastBuilder: (func) {
//           return Column(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Center(
//                 child: CircularProgressIndicator(
//                   backgroundColor: Color(0xFF74b9ff),
//                   valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0984e3)),
//                 ),
//               ),
//             ],
//           );
//         },
//         allowClick: true,
//         clickClose: true,
//         backgroundColor: Colors.transparent);
//   }

//   static textShow({@required String text}) async {
//     await loadingClose();

//     BotToast.showCustomLoading(
//         toastBuilder: (func) {
//           return Column(
//             children: <Widget>[
//               Spacer(),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
//                 child: Text(
//                   text,
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//               SizedBox(height: 20)
//             ],
//           );
//         },
//         allowClick: true,
//         clickClose: true,
//         crossPage: true,
//         duration: Duration(seconds: 5),
//         backgroundColor: Colors.transparent);
//   }

//   static Future loadingClose() async {
//     BotToast.cleanAll();
//     await Future.delayed(Duration(milliseconds: 100));
//   }
// }
