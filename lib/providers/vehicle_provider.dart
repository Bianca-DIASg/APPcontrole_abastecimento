import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../modelos/vehicle.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VehicleProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Vehicle> _vehicles = [];
  List<Vehicle> get vehicles => _vehicles;

  String get uid => FirebaseAuth.instance.currentUser!.uid;

  Future<void> loadVehicles() async {
    final snapshot = await _db
        .collection("users")
        .doc(uid)
        .collection("veiculos")
        .get();

    _vehicles = snapshot.docs
        .map((d) => Vehicle.fromMap(d.id, d.data()))
        .toList();

    notifyListeners();
  }

  Future<void> addVehicle(Vehicle v) async {
    await _db
        .collection("users")
        .doc(uid)
        .collection("veiculos")
        .add(v.toMap());

    await loadVehicles();
  }

  Future<void> deleteVehicle(String id) async {
    await _db
        .collection("users")
        .doc(uid)
        .collection("veiculos")
        .doc(id)
        .delete();

    await loadVehicles();
  }
}
