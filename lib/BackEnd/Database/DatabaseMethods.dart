import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Database {
  //=======================Student Sing up method======================================
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
        await FirebaseFirestore.instance.collection('users').add({
          'name': name,
          'userId': userCredential.user?.uid,
          'password': password,
          'email': email,
          'major': major,
          'stId': stId,
          'type': 'student',
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
        await FirebaseFirestore.instance.collection('users').add({
          'name': name,
          'userId': userCredential.user?.uid,
          'password': password,
          'email': email,
          'major': major,
          'searchInterest': searchInterest,
          'type': 'supervisor'
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

  //get supervisor=============================================================
  static Future studentSendRequest({
    required BuildContext context,
    required String stId,
    required String supervisorId,
  }) async {
    Navigator.pop(context);



    return 'error';
  }
}
