import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart';

Future<bool> checkEmailRegistered(String? email) async {
  if (email == null) {
    return false;
  }
  try {
    final list = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

    if (list.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  } catch (error) {
    return false;
  }
}

Future<bool> registerNewUser(Map<String, dynamic> userData) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userData['email'], password: userData['password']['password']);
    await FirebaseAuth.instance.currentUser
        ?.updateDisplayName("${userData['name']} ${userData['surname']}");
    developer.log("Registered new user successfully", name: "api");
    return true;
  } catch (e) {
    developer.log("Failed registration", name: "api", error: e);
    return false;
  }
}
