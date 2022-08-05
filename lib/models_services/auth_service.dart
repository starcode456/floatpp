import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart' as messaging;
import 'package:google_sign_in/google_sign_in.dart';

import '../app_utils/appVersion.dart';
import '../models/update.dart';
import '../models/user.dart';

class AuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //static final FirebaseMessaging _firestoreMessaging = messaging.FirebaseMessaging.instance.;

/* --------------------------- NOTE Stream Update --------------------------- */
  static Future<Stream<Update>> streamUpdate() async {
    var ref = FirebaseFirestore.instance
        .collection('appVersion')
        .doc('appVersionServer');
    return ref.snapshots().map((snap) => Update.fromFirestore(snap));
  }

  /* ----------------- NOTE Get User i.e Stream<User> != User ----------------- */
  static Future<UserModel> getUserx() async {
    auth.User fbUser = await auth.FirebaseAuth.instance.currentUser;

    UserModel user;
    Stream<UserModel> streamUser;
    if (fbUser != null) {
      streamUser = await streamUserx();
      streamUser = streamUser.take(1);
      await for (UserModel i in streamUser) {
        if (i != null) {
          user = i;
        }
      }
    }
    return user;
  }

  /* ---------------------------- NOTE Stream User ---------------------------- */
  static Future<Stream<UserModel>> streamUserx() async {
    auth.User user = await auth.FirebaseAuth.instance.currentUser;

    if (user != null) {
      var ref = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .asBroadcastStream();
      return ref.map((snap) => UserModel.fromFirestore(snap));
    }
    return null;
  }

/* ------------------------ NOTE Register with Email ------------------------ */
  static Future<auth.User> registerUserEmailAndPassword(
      {UserRegister userRegister}) async {
    try {
      auth.UserCredential authResult =
          await _auth.createUserWithEmailAndPassword(
              email: userRegister.email, password: userRegister.password);
      auth.User firebaseUser = authResult.user;

      await registerUserUpdateFirestore(
          fbUser: firebaseUser, userRegister: userRegister);
      // sending email verification
      firebaseUser.sendEmailVerification();
      print('sending email');
      return firebaseUser;
    } catch (err) {
      // print(err);
      return null;
    }
  }

/* ------------------------ NOTE Sign in with Email ------------------------ */
  static Future<auth.User> signInUserEmailAndPassword(
      {String email, String password}) async {
    try {
      auth.UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      auth.User firebaseUser = authResult.user;
      print('user is signed in $firebaseUser');
      return firebaseUser;
    } catch (err) {
      // print(err);
      return null;
    }
  }

/* --------------------- NOTE Reset Password With email --------------------- */
  static Future<String> resetPassword({String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 'Email sent';
    } catch (err) {
      print(err);
      return null;
    }
  }

  /* --------------------------- NOTE Register User --------------------------- */
  static Future<void> registerUserUpdateFirestore(
      {auth.User fbUser, UserRegister userRegister}) async {
    String currentDevToken =
        await messaging.FirebaseMessaging.instance.getToken();
    // print('user data + ${fbUser.email}');
    //  print('user data + ${userRegister.firstName}');
    //  print('firing + $currentDevToken');
    await _firestore
        .collection('users')
        .doc(fbUser.uid)
        .get()
        .then((value) async {
      print(value.data());
      if (value.data() == null) {
        await _firestore.collection('users').doc(fbUser.uid).set({
          'email': fbUser.email,
          'fullname': userRegister.fullname,
          'uni': '',
          'userId': fbUser.uid,
          'timestampRegister': DateTime.now(),
          'timestampLastLogin': DateTime.now(),
          'devTokens': FieldValue.arrayUnion([currentDevToken]),
          'isNotificationsEnabled': true,
          'appVersionLocal': AppVersionLocal.appVersionLocal,
        });
        await _firestore.collection('user').doc(fbUser.uid).set({
          'name': userRegister.fullname,
          'uni': '',
        });
      }
    });

    return;
  }

/* ------------------------ NOTE Sign in with Google ------------------------ */
  static Future<auth.User> googleSignIn() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      auth.UserCredential authResult =
          await _auth.signInWithCredential(credential);
      auth.User firebaseUser = authResult.user;
      await registerUser(fbUser: firebaseUser);

      return firebaseUser;
    } catch (error) {
      print('This is the error in google sifn in $error');
      return null;
    }
  }

/* ------------------------ NOTE Sign in with Apple------------------------ */
  static Future<auth.User> appleSignIn() async {
    try {
      auth.UserCredential _res;
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);
      print(result.credential);
      switch (result.status) {
        case AuthorizationStatus.authorized:
          try {
            print("successfull sign in");
            final AppleIdCredential appleIdCredential = result.credential;

            OAuthProvider oAuthProvider = new OAuthProvider("apple.com");
            final AuthCredential credential = oAuthProvider.credential(
              idToken: String.fromCharCodes(appleIdCredential.identityToken),
              accessToken:
                  String.fromCharCodes(appleIdCredential.authorizationCode),
            );

            _res = await FirebaseAuth.instance.signInWithCredential(credential);
            print(appleIdCredential.fullName.givenName);
            print(appleIdCredential.fullName.familyName);
            print(appleIdCredential.fullName.middleName);
            //_res.user.displayName = appleIdCredential.fullName.givenName + " "+ appleIdCredential.fullName.familyName ?? '';

            await registerUser(
                fbUser: _res.user,
                username: appleIdCredential.fullName.givenName +
                        " " +
                        appleIdCredential.fullName.familyName ??
                    '');
            return _res.user;
            // FirebaseAuth.instance.currentUser.then((val) async {
            //   UserUpdateInfo updateUser = UserUpdateInfo();
            //   updateUser.displayName =
            //       "${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}";
            //   updateUser.photoUrl =
            //       "define an url";
            //   await val.updateProfile(updateUser);
            // });

          } catch (e) {
            print("error");
          }
          break;
        case AuthorizationStatus.error:
          // do something
          break;

        case AuthorizationStatus.cancelled:
          print('User cancelled');
          break;
      }
      return _res.user;
    } catch (error) {
      print("error with apple sign in");
    }
  }

/* --------------------------- NOTE Register User --------------------------- */
  static Future<void> registerUser({auth.User fbUser, String username}) async {
    var userRef = await _firestore.collection('users').doc(fbUser.uid).get();

    UserModel user = UserModel.fromFirestore(userRef);

    String currentDevToken =
        await messaging.FirebaseMessaging.instance.getToken();
    print('1');
    print(fbUser.displayName);
    print('2');
    print(fbUser.providerData.first.displayName);
    print('3');
    print(username);

    await _firestore.collection('users').doc(fbUser.uid).set({
      'email': fbUser.email,
      'fullname': fbUser.displayName ??
          fbUser.providerData.first.displayName ??
          username,
      'userId': fbUser.uid,
      'timestampRegister': user?.timestampRegister ?? DateTime.now(),
      'timestampLastLogin': user?.timestampRegister ?? DateTime.now(),
      'profilepic': user?.profilepic ?? null,
      'devTokens': FieldValue.arrayUnion([currentDevToken]),
      'isNotificationsEnabled': user?.isNotificationsEnabled ?? true,
      'appVersionLocal': AppVersionLocal.appVersionLocal,
    }, SetOptions(merge: true));

    return;
  }

/* --------------------- NOTE Update Notification Status -------------------- */
  static Future<void> updateNotificationStatus(bool status) async {
    auth.User user = await FirebaseAuth.instance.currentUser;
    await _firestore.collection('users').doc(user.uid).update(
      {
        'isNotificationsEnabled': status,
      },
    );
  }

/* --------------------- NOTE Update Appversion & Login --------------------- */
  static Future<void> updateAppVersionLastLogin() async {
    auth.User user = await FirebaseAuth.instance.currentUser;

    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'appVersionLocal': AppVersionLocal.appVersionLocal,
        'timestampLastLogin': DateTime.now(),
      });
    }
  }

/* ------------------------------ NOTE Sign Out ----------------------------- */
  static Future<void> signOut() async {
    auth.User fbUser = FirebaseAuth.instance.currentUser;
    _auth.signOut();

    String currentDevToken =
        await messaging.FirebaseMessaging.instance.getToken();

    if (fbUser != null) {
      await _firestore.collection('users').doc(fbUser.uid).update({
        'devTokens': FieldValue.arrayRemove([currentDevToken]),
      });
    }
    return;
  }
}
