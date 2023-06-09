import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:library_project/Widget/AppConstants.dart';
import 'package:library_project/Widget/AppWidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  //=======================Student Sing up method======================================

  static Future<String> studentSingUpFu({
    required String name,
    required String email,
    required String password,
    required String stId,
    required String major,
    required String phone,
    required String searchInterest,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.trim(), password: password);
      if (userCredential.user != null) {
        await AppConstants.userCollection.add({
          'name': name,
          'userId': userCredential.user?.uid,
          'password': password,
          'email': email,
          'major': major,
          'stId': stId,
          'type': AppConstants.student,
          'searchInterest': searchInterest,
          'phone': phone
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
        await AppConstants.userCollection.add({
          'name': name,
          'userId': userCredential.user?.uid,
          'password': password,
          'email': email,
          'major': major,
          'searchInterest': searchInterest,
          'type': AppConstants.supervisor,
          'phone': phone
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

//student Update Profile============================================================================================
  static Future<String> updateProfile(
      {required String name,
      String? stId,
      required String major,
      required String phone,
      required String searchInterest,
      required String docId,
      required String type}) async {
    try {
      await AppConstants.userCollection
          .doc(docId)
          .update(type == AppConstants.typeIsStudent
              ? {
                  'name': name,
                  'major': major,
                  'stId': stId,
                  'type': AppConstants.typeIsStudent,
                  'searchInterest': searchInterest,
                  'phone': phone
                }
              : {
                  'name': name,
                  'major': major,
                  'type': AppConstants.typeIsSupervisor,
                  'searchInterest': searchInterest,
                  'phone': phone
                });
      return 'done';
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
        return 'wrong-password';
      }
    } catch (e) {
      return 'error';
    }
    return 'error';
  }

//get Student vi userId=============================================================================
  static Future<String> getDataViUserId(
      {required String currentUserUid}) async {
    String name = '';

    await AppConstants.userCollection
        .where('userId', isEqualTo: currentUserUid)
        .get()
        .then((getData) {
      getData.docs.forEach((element) {
        name = element['name'];
      });
    });
    return name;
  }

//get request status=============================================================================
  static Future<int> getStatus({required String id}) async {
    var status = 0;

    await AppConstants.requestCollection
        .where('studentUid', isEqualTo: id)
        .get()
        .then((getData) {
      getData.docs.forEach((element) {
        print('status: ${element.id}');
      });
      print('status: $status');
    });
    return status;
  }

  //student Supervision Requests=============================================================
  static Future studentSupervisionRequests({
    required BuildContext context,
    required String studentUid,
    required String supervisorUid,
    required String supervisorName,
    required String supervisorInterest,
    required String studentName,
    required String description,
    required String projectName,
  }) async {
    try {
      AppConstants.requestCollection.add({
        'studentUid': studentUid,
        'supervisorUid': supervisorUid,
        'status': AppConstants.statusIsWaiting,
        'requestId': AppWidget.uniqueOrder(),
        'supervisorName': supervisorName,
        'supervisorInterest': supervisorInterest,
        'studentName': studentName,
        'description': description,
        'projectName': projectName
      });
      return 'done';
    } catch (e) {
      return 'error';
    }
  }
//===================================================================
  static Future<String> resetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      return 'done';
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        return 'user-not-found';
      }
    } catch (e) {
      return 'error';
    }
    return 'error';
  }
//==========================================================================
  static Future updateRequestStatus(
      {required bool isAccept,
      required int status,
      required String docId}) async {
    try {
      await AppConstants.requestCollection
          .doc(docId)
          .update({'status': status, 'isAccept': isAccept});
      return 'done';
    } catch (e) {
      print('Update Status Error $e');
      return 'error';
    }
  }

//=========================================================================================================
  static Future<String> addProject({
    required String name,
    required String year,
    required String link,
    required String fileName,
    required String major,
    required String searchInterest,
    required String superName,
    required String from,
    required int status,
    required int projectId,
    required String superId,
    required String studentId,
    required bool isAccept,
    String? comment,
  }) async {
    try {
      AppConstants.projectCollection.add({
        'name': name,
        'year': year,
        'link': link,
        'fileName': fileName,
        'major': major,
        'searchInterest': searchInterest,
        'superName': superName,
        'status': status,
        'from': from,
        'projectId': projectId,
        'isAccept': isAccept,
        'createdOn': FieldValue.serverTimestamp(),
        'superId': superId,
        'studentId': studentId,
        'comment': comment ?? ''
      });
      return 'done';
    } catch (e) {
      return 'error';
    }
  }

//Update project=========================================================================================================
  static Future<String> updateProject(
      {required String name,
      required String year,
      required String link,
      required String fileName,
      required String major,
      required String searchInterest,
      required String superName,
      required int status,
      String? comment,
      required String docId}) async {
    try {
      AppConstants.projectCollection.doc(docId).update({
        'name': name,
        'year': year,
        'link': link,
        'fileName': fileName,
        'major': major,
        'searchInterest': searchInterest,
        'superName': superName,
        'status': status,
        'comment': comment
      });
      return 'done';
    } catch (e) {
      return 'error';
    }
  }

  //Update status=========================================================================================================
  static Future<String> updateProjectStatus(
      {required String docId, required bool isAccept}) async {
    try {
      AppConstants.projectCollection.doc(docId).update(
          {'status': AppConstants.statusIsComplete, 'isAccept': isAccept});
      return 'done';
    } catch (e) {
      return 'error';
    }
  }

  //=======================add comment======================================
  static Future<String> addComment({
    required String comment,
    required String data,
    required String name,
    required String userId,
    required int projectId,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('comments').add({
        'comment': comment,
        'data': data,
        'name': name,
        'userId': userId,
        'createdOn': FieldValue.serverTimestamp(),
        'projectId': projectId
      });
      return 'done';
    } catch (e) {
      return 'error';
    }
  }

  //=========================Dawonlde file===========================================
  static Future lodeFirbase(String url) async {
    try {
      final refPDF = FirebaseStorage.instance.ref('project/$url');
      final byets = await refPDF.getData(1024 * 1024 * 15);
      return storFile(url, byets!);
    } catch (e) {
      return e.toString();
    }
  }

  //=========================show file===========================================
  static Future<File> storFile(String url, List<int> byets) async {
    final filename = path.basename(url);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(
      byets,
      flush: true,
    );
    return file;
  }
}
