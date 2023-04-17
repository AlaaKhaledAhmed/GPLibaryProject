
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChangConstModel extends ChangeNotifier {
  String? selectedMajor;
  String? selectedSearch;

  // late var supervisorList;

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


}
