import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/error/exceptions.dart';
import '../models/hobby_model.dart';

abstract class HobbyRemoteDatasource {
  Future<List<HobbyModel>> fetchHobbies(String userId);
  Future<HobbyModel> fetchHobbyById(String id);
  Future<void> createHobby(HobbyModel model);
  Future<void> updateHobby(HobbyModel model);
  Future<void> deleteHobby(String id);
}

class HobbyRemoteDatasourceImpl implements HobbyRemoteDatasource {
  HobbyRemoteDatasourceImpl(this.firestore);

  final FirebaseFirestore firestore;
  static const _collection = 'hobbies';
  CollectionReference<Map<String, dynamic>> get _hobbies =>
      firestore.collection(_collection);

  @override
  Future<List<HobbyModel>> fetchHobbies(String userId) async {
    try {
      final snap = await _hobbies
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      return snap.docs.map(HobbyModel.fromFirestore).toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch hobbies');
    }
  }

  @override
  Future<HobbyModel> fetchHobbyById(String id) async {
    try {
      final doc = await _hobbies.doc(id).get();
      if (!doc.exists || doc.data() == null) {
        throw const NotFoundException('Hobby not found');
      }
      return HobbyModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch hobby');
    }
  }

  @override
  Future<void> createHobby(HobbyModel model) async {
    try {
      await _hobbies.doc(model.id).set(model.toFirestore());
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to create hobby');
    }
  }

  @override
  Future<void> updateHobby(HobbyModel model) async {
    try {
      await _hobbies.doc(model.id).update({
        ...model.toFirestore(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to update hobby');
    }
  }

  @override
  Future<void> deleteHobby(String id) async {
    try {
      await _hobbies.doc(id).delete();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to delete hobby');
    }
  }
}

abstract class HobbyLocalDatasource {
  Future<List<HobbyModel>> getCachedHobbies();
  Future<void> cacheHobbies(List<HobbyModel> hobbies);
  Future<void> deleteHobby(String id);
}

class HobbyLocalDatasourceImpl implements HobbyLocalDatasource {
  @override
  Future<void> cacheHobbies(List<HobbyModel> hobbies) async {}

  @override
  Future<void> deleteHobby(String id) async {}

  @override
  Future<List<HobbyModel>> getCachedHobbies() async => <HobbyModel>[];
}
