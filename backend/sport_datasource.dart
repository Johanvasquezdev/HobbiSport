// lib/features/sports/data/datasources/sport_remote_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/exceptions.dart';
import '../models/sport_activity_model.dart';
import '../../domain/entities/sport_activity.dart';

// ─── Abstract ────────────────────────────────────────────────
abstract class SportRemoteDatasource {
  Future<List<SportActivityModel>> fetchActivities(String userId);
  Future<List<SportActivityModel>> fetchActivitiesByType(
      String userId, SportType type);
  Future<SportActivityModel> fetchActivityById(String id);
  Future<String> createActivity(SportActivityModel model, String userId);
  Future<void> updateActivity(SportActivityModel model);
  Future<void> deleteActivity(String id);
}

// ─── Firebase Implementation ─────────────────────────────────
class SportRemoteDatasourceImpl implements SportRemoteDatasource {
  final FirebaseFirestore firestore;

  SportRemoteDatasourceImpl(this.firestore);

  static const String _collection = 'sport_activities';

  @override
  Future<List<SportActivityModel>> fetchActivities(String userId) async {
    try {
      final snap = await firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();
      return snap.docs.map(SportActivityModel.fromFirestore).toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch activities');
    }
  }

  @override
  Future<List<SportActivityModel>> fetchActivitiesByType(
      String userId, SportType type) async {
    try {
      final snap = await firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('sportType', isEqualTo: type.name)
          .orderBy('date', descending: true)
          .get();
      return snap.docs.map(SportActivityModel.fromFirestore).toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch activities by type');
    }
  }

  @override
  Future<SportActivityModel> fetchActivityById(String id) async {
    try {
      final doc = await firestore.collection(_collection).doc(id).get();
      if (!doc.exists) throw const NotFoundException('Activity not found');
      return SportActivityModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch activity');
    }
  }

  @override
  Future<String> createActivity(
      SportActivityModel model, String userId) async {
    try {
      final data = model.toFirestore()..['userId'] = userId;
      final ref = await firestore.collection(_collection).add(data);
      return ref.id;
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to log activity');
    }
  }

  @override
  Future<void> updateActivity(SportActivityModel model) async {
    try {
      await firestore
          .collection(_collection)
          .doc(model.id)
          .update(model.toFirestore());
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to update activity');
    }
  }

  @override
  Future<void> deleteActivity(String id) async {
    try {
      await firestore.collection(_collection).doc(id).delete();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to delete activity');
    }
  }
}

// ─────────────────────────────────────────────────────────────
// LOCAL DATASOURCE
// ─────────────────────────────────────────────────────────────

abstract class SportLocalDatasource {
  Future<List<SportActivityModel>> getCachedActivities();
  Future<void> cacheActivities(List<SportActivityModel> activities);
  Future<void> deleteActivity(String id);
}

class SportLocalDatasourceImpl implements SportLocalDatasource {
  final dynamic database; // Replace with: final Database database;

  SportLocalDatasourceImpl(this.database);

  static const String _table = 'sport_activities';

  @override
  Future<List<SportActivityModel>> getCachedActivities() async {
    try {
      final rows = await database.query(
        _table,
        orderBy: 'date DESC',
      ) as List<Map<String, dynamic>>;
      return rows.map(SportActivityModel.fromJson).toList();
    } catch (e) {
      throw CacheException('Failed to load cached activities: $e');
    }
  }

  @override
  Future<void> cacheActivities(List<SportActivityModel> activities) async {
    try {
      final batch = database.batch();
      for (final a in activities) {
        batch.insert(
          _table,
          a.toJson(),
          conflictAlgorithm: 5, // ConflictAlgorithm.replace
        );
      }
      await batch.commit(noResult: true);
    } catch (e) {
      throw CacheException('Failed to cache activities: $e');
    }
  }

  @override
  Future<void> deleteActivity(String id) async {
    try {
      await database.delete(_table, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw CacheException('Failed to delete cached activity: $e');
    }
  }
}
