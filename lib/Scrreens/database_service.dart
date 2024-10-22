import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // Firestore collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  // Update user data or create a new document
  Future<void> updateUserData(String email, String displayName) async {
    return await userCollection.doc(uid).set({
      'email': email,
      'displayName': displayName,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get user data stream
  Stream<DocumentSnapshot> get userData {
    return userCollection.doc(uid).snapshots();
  }
}
