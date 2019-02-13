import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();
// final FacebookLogin facebookSignIn = new FacebookLogin();
Future<FirebaseUser> signInWithGoogle() async {
  // Attempt to get the currently authenticated user
  GoogleSignInAccount currentUser = _googleSignIn.currentUser;
  if (currentUser == null) {
    // Attempt to sign in without user interaction
    currentUser = await _googleSignIn.signInSilently();
  }
  if (currentUser == null) {
    // Force the user to interactively sign in
    currentUser = await _googleSignIn.signIn();
  }

  final GoogleSignInAuthentication googleAuth =
      await currentUser.authentication;

  // Authenticate with firebase
  final FirebaseUser user = await firebaseAuth.signInWithGoogle(
    idToken: googleAuth.idToken,
    accessToken: googleAuth.accessToken,
  );

  assert(user != null);
  assert(!user.isAnonymous);

  return user;
}

// Future<FacebookAccessToken> singIntWithFacebook() async {
//   final FacebookLoginResult result =
//       await facebookSignIn.logInWithReadPermissions(['email']);

//   switch (result.status) {
//     case FacebookLoginStatus.loggedIn:
//       final FacebookAccessToken accessToken = result.accessToken;
//       _showMessage('''
//          Logged in!
//          Token: ${accessToken.token}
//          User id: ${accessToken.userId}
//          Expires: ${accessToken.expires}
//          Permissions: ${accessToken.permissions}
//          Declined permissions: ${accessToken.declinedPermissions}
//          ''');
//       break;
//     case FacebookLoginStatus.cancelledByUser:
//       _showMessage('Login cancelled by the user.');
//       break;
//     case FacebookLoginStatus.error:
//       _showMessage('Something went wrong with the login process.\n'
//           'Here\'s the error Facebook gave us: ${result.errorMessage}');
//       break;
//   }
//   return result.accessToken;
// }

Future<Null> signOutWithGoogle() async {
  // Sign out with firebase
  await firebaseAuth.signOut();
  // Sign out with google
  await _googleSignIn.signOut();
}

// Future<Null> signOutWithFacebook() async {
//   await facebookSignIn.logOut();
//   _showMessage('Logged out.');
// }

void _showMessage(String message) {
  print('message $message');
}
