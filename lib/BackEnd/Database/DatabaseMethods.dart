import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:library_project/Widget/AppConstants.dart';

class Database {
  //=======================Student Sing up method======================================
  static  CollectionReference getUserCollection =
      FirebaseFirestore.instance.collection('users');
  static Future<String> studentSingUpFu({
    required String name,
    required String email,
    required String password,
    required String stId,
    required String major,
    required String phone,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.trim(), password: password);
      if (userCredential.user != null) {
        await getUserCollection.add({
          'name': name,
          'userId': userCredential.user?.uid,
          'password': password,
          'email': email,
          'major': major,
          'stId': stId,
          'type': AppConstants.student,
          'auth': ''
        });
        return 'done';
      }
    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        return 'weak-password';
      }
      if (e.code == 'email-already-in-use') {
        return 'email-already-in-use';
      }
    } catch (e) {
      return e.toString();
    }
    return 'error';
  }

  //=======================supervisor Sing up method======================================
  static Future<String> supervisorSingUpFu({
    required String name,
    required String email,
    required String password,
    required String searchInterest,
    required String major,
    required String phone,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.trim(), password: password);
      if (userCredential.user != null) {
        await getUserCollection.add({
          'name': name,
          'userId': userCredential.user?.uid,
          'password': password,
          'email': email,
          'major': major,
          'searchInterest': searchInterest,
          'type': AppConstants.supervisor
        });
        return 'done';
      }
    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        return 'weak-password';
      }
      if (e.code == 'email-already-in-use') {
        return 'email-already-in-use';
      }
    } catch (e) {
      return e.toString();
    }
    return 'error';
  }

//=======================Log in method======================================

  static Future<String> loggingToApp(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.trim(), password: password);
      if (userCredential.user != null) {
        return '${userCredential.user?.uid}';
        //
      }
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        return 'user-not-found';
      }
      if (e.code == 'wrong-password') {
        return 'user-not-found';
      }
    } catch (e) {
      return 'error';
    }
    return 'error';
  }

//=======================Add team======================================
  static Future<String> addTeam(
      {required String name,
      required String stId,
      required String auth,
      required String userId}) async {
    try {} catch (e) {
      return e.toString();
    }

    return 'error';
  }

//get Student vi userId=============================================================================
  static getDataViUserId({required String uId, required String userType}) {
    Map<String, dynamic> userData = {};

    getUserCollection
        .where('userId', isEqualTo: uId)
        .where('type', isEqualTo: userType).get();

   getUserCollection.doc().get().then((value) {
      print(value);
    });
    print(getUserCollection.runtimeType);
    print(getUserCollection.runtimeType);
  }

  //get supervisor=============================================================
  static Future studentSupervisionRequests({
    required BuildContext context,
    required String stId,
    required String supervisorId,
  }) async {
    Navigator.pop(context);

    return 'error';
  }
}
