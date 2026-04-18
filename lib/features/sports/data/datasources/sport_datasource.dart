import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/sport_activity.dart';
import '../models/sport_activity_model.dart';

abstract class SportRemoteDatasource {
  Future<List<SportActivityModel>> fetchActivities(String userId);
  Future<List<SportActivityModel>> fetchActivitiesByType(String userId, SportType type);
  Future<SportActivityModel> fetchActivityById(String id);
  Future<void> createActivity(SportActivityModel model, String userId);
  Future<void> updateActivity(SportActivityModel model);
  Future<void> deleteActivity(String id);
}

class SportRemoteDatasourceImpl implements SportRemoteDatasource {
  SportRemoteDatasourceImpl(this.firestore);

  final FirebaseFirestore firestore;
  static const _collection = 'sport_activities';
  CollectionReference<Map<String, dynamic>> get _activities =>
      firestore.collection(_collection);

  @override
  Future<List<SportActivityModel>> fetchActivities(String userId) async {
    try {
      final snap = await _activities
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();
      return snap.docs.map(SportActivityModel.fromFirestore).toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch activities');
    }
  }

  @override
  Future<List<SportActivityModel>> fetchActivitiesByType(String userId, SportType type) async {
    try {
      final snap = await _activities
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
      final doc = await _activities.doc(id).get();
      if (!doc.exists || doc.data() == null) {
        throw const NotFoundException('Activity not found');
      }
      return SportActivityModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch activity');
    }
  }

  @override
  Future<void> createActivity(SportActivityModel model, String userId) async {
    try {
      await _activities.doc(model.id).set({
        ...model.toFirestore(),
        'userId': userId,
      });
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to log activity');
    }
  }

  @override
  Future<void> updateActivity(SportActivityModel model) async {
    try {
      await _activities.doc(model.id).update(model.toFirestore());
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to update activity');
    }
  }

  @override
  Future<void> deleteActivity(String id) async {
    try {
      await _activities.doc(id).delete();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to delete activity');
    }
  }
}

abstract class SportLocalDatasource {
  Future<List<SportActivityModel>> getCachedActivities();
  Future<void> cacheActivities(List<SportActivityModel> activities);
  Future<void> deleteActivity(String id);
}

class SportLocalDatasourceImpl implements SportLocalDatasource {
  SportLocalDatasourceImpl(this.database);

  final Database database;
  static const _table = 'sport_activities';

  @override
  Future<void> cacheActivities(List<SportActivityModel> activities) async {
    try {
      final batch = database.batch();
      for (final activity in activities) {
        batch.insert(_table, activity.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
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

  @override
  Future<List<SportActivityModel>> getCachedActivities() async {
    try {
      final rows = await database.query(_table, orderBy: 'date DESC');
      return rows.map(SportActivityModel.fromJson).toList();
    } catch (e) {
      throw CacheException('Failed to load cached activities: $e');
    }
  }
}

class InMemorySportLocalDatasource implements SportLocalDatasource {
  final Map<String, SportActivityModel> _cache = <String, SportActivityModel>{};

  @override
  Future<void> cacheActivities(List<SportActivityModel> activities) async {
    for (final activity in activities) {
      _cache[activity.id] = activity;
    }
  }

  @override
  Future<void> deleteActivity(String id) async {
    _cache.remove(id);
  }

  @override
  Future<List<SportActivityModel>> getCachedActivities() async {
    final activities = _cache.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return activities;
  }
}
