import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_split/models/group_model.dart';

class GroupRepository {
  final FirebaseFirestore firestore;

  GroupRepository(this.firestore);

  Future<List<Group>> fetchGroups(String uid) async {
    final snapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection('groups')
        .get();

    return snapshot.docs.map((doc) => Group.fromMap(doc.data())).toList();
  }
}
