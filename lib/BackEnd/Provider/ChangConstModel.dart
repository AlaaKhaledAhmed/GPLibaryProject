import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/SupervisorModel.dart';

class ChangConstModel extends ChangeNotifier {
  String? selectedMajor;
  String? selectedSearch;
  late QuerySnapshot supervisorCollection;
  late var supervisorList;

  List<bool> isSupervisor = [false];
  List<bool> setType() {
    isSupervisor[0] = !isSupervisor[0];
    notifyListeners();
    return isSupervisor;
  }

  String? setMajor(String select) {
    selectedMajor = select;
    notifyListeners();
    return selectedMajor;
  }

  String? setSearch(String select) {
    selectedSearch = select;
    notifyListeners();
    return selectedSearch;
  }

  //=============================================================
  Future getSupervisor() async {
    supervisorCollection = await FirebaseFirestore.instance
        .collection('users')
        .where('type', isEqualTo: 'supervisor')
        .get();
    supervisorList = supervisorCollection.docs
        .map((QueryDocumentSnapshot d) =>
            Supervisor.fromMap((d.data() as Map), (d.id)))
        .toList();
    return supervisorList;
  }
}
