import 'package:devfest/functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:notes_app/function.dart';
// import 'package:notes_app/notes_home.dart';
// import 'package:notes_app/provider/user_provider.dart';
// import 'package:notes_app/widgets.dart/boarding.dart';

// import 'package:notes_app/provider/note_provider.dart';
// import 'package:provider/provider.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  getCurrentUser() async {
    return auth.currentUser;
  }

  signInWithGoogle(BuildContext context) async {
    // final notesProvider =
    //     Provider.of<NotesDataProvider>(context, listen: false);
    // final userProvider = Provider.of<UserDataProvider>(context, listen: false);

    print("Google auth clicked");
    // final GoogleSignInAccount? googleSignInAccount =
    //     await _googleSignIn.signInSilently();

    GoogleSignInAccount? googleSignInAccount = kIsWeb
        ? await (_googleSignIn.signInSilently())
        : await (_googleSignIn.signIn());

    if (kIsWeb && googleSignInAccount == null)
      googleSignInAccount = await (_googleSignIn.signIn());
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    print("Google auth clicked 2");

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    print("Google auth clicked 3${credential.token}");

    UserCredential result = await auth.signInWithCredential(credential);

    User userDetails = result.user!;

    if (result != null) {
      print("${userDetails.metadata.creationTime}is a creation time");
      print(
          "google data userid(auth uid) set! ${googleSignInAuthentication.idToken}");
      print(userDetails.displayName.toString() + " Success ");
      userAddToFirebase(userDetails, context);
      // notesProvider.setuserid(userDetails.uid);
      // userProvider.setUserData(
      //     userDetails.uid,
      //     userDetails.displayName ?? "",
      //     userDetails.email ?? "",
      //     userDetails.phoneNumber ?? "",
      //     userDetails.photoURL ?? "");

      // navigateslide(NotesHomePage(), context);
    } else {
      print("its disgusting not happening");
    }
  }

  void signOut(BuildContext context) async {
    print("User GoogleSign out !!");
    // navigateslide(BoardingScreen(), context);
    // setprefab(false, "userid", "", "", "", "");
    await _googleSignIn.signOut();
    await auth.signOut();
  }
}
