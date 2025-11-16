import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../modelos/refueling.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RefuelingProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Refueling> _refuelings = [];
  List<Refueling> get refuelings => _refuelings;

  String get uid => FirebaseAuth.instance.currentUser!.uid;

  Future<void> loadRefuelings() async {
    final snapshot = await _db
        .collection("users")
        .doc(uid)
        .collection("abastecimentos")
        .orderBy("data", descending: true)
        .get();

    _refuelings = snapshot.docs
        .map((d) => Refueling.fromMap(d.id, d.data()))
        .toList();

    notifyListeners();
  }

  Future<void> addRefueling(Refueling refueling) async {
    await _db
        .collection("users")
        .doc(uid)
        .collection("abastecimentos")
        .add(refueling.toMap());

    await loadRefuelings();
  }

  Future<void> deleteRefueling(String id) async {
    await _db
        .collection("users")
        .doc(uid)
        .collection("abastecimentos")
        .doc(id)
        .delete();

    await loadRefuelings();
  }

  List<Refueling> getRefuelingsByVehicle(String vehicleId) {
    return _refuelings.where((r) => r.veiculoId == vehicleId).toList();
  }

  double getTotalSpentByVehicle(String vehicleId) {
    final vehicleRefuelings = getRefuelingsByVehicle(vehicleId);
    return vehicleRefuelings.fold(0.0, (total, r) => total + r.valorPago);
  }

  double getAverageConsumption(String vehicleId) {
    final vehicleRefuelings = getRefuelingsByVehicle(vehicleId);
    if (vehicleRefuelings.isEmpty) return 0.0;
    
    final totalConsumption = vehicleRefuelings.fold(0.0, (total, r) => total + r.consumo);
    return totalConsumption / vehicleRefuelings.length;
  }
}
