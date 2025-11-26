import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/computer_model.dart';

class ComputerService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collectionName = 'computers';

  Future<List<Computer>> getComputers() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return []; 
    }

    final String userId = user.uid;

    final snapshot = await _db
        .collection(_collectionName)
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) => Computer.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> insertComputer(Computer computer) {
    if (computer.userId == null) {
       throw Exception("UserID must be provided for insertion.");
    }
    return _db.collection(_collectionName).add(computer.toMap());
  }

  Future<void> updateComputer(Computer computer) {
    if (computer.id == null || computer.userId == null) {
      throw Exception("ID and UserID must be provided for update.");
    }
    return _db.collection(_collectionName).doc(computer.id).update(computer.toMap());
  }

  Future<void> deleteComputer(String id) {
    return _db.collection(_collectionName).doc(id).delete();
  }
}