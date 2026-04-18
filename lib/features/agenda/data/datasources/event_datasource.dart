import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/error/exceptions.dart';
import '../models/event_model.dart';

abstract class EventRemoteDatasource {
  Future<List<EventModel>> fetchEvents(String userId);
  Future<List<EventModel>> fetchEventsForDay(String userId, DateTime date);
  Future<EventModel> fetchEventById(String id);
  Future<void> createEvent(EventModel model, String userId);
  Future<void> updateEvent(EventModel model);
  Future<void> deleteEvent(String id);
}

class EventRemoteDatasourceImpl implements EventRemoteDatasource {
  EventRemoteDatasourceImpl(this.firestore);

  final FirebaseFirestore firestore;
  static const _collection = 'events';
  CollectionReference<Map<String, dynamic>> get _events =>
      firestore.collection(_collection);

  @override
  Future<List<EventModel>> fetchEvents(String userId) async {
    try {
      final snap = await _events
          .where('userId', isEqualTo: userId)
          .orderBy('dateTime')
          .get();
      return snap.docs.map(EventModel.fromFirestore).toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch events');
    }
  }

  @override
  Future<List<EventModel>> fetchEventsForDay(String userId, DateTime date) async {
    try {
      final start = DateTime(date.year, date.month, date.day);
      final end = start.add(const Duration(days: 1));

      final snap = await _events
          .where('userId', isEqualTo: userId)
          .where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('dateTime', isLessThan: Timestamp.fromDate(end))
          .orderBy('dateTime')
          .get();
      return snap.docs.map(EventModel.fromFirestore).toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch events for day');
    }
  }

  @override
  Future<EventModel> fetchEventById(String id) async {
    try {
      final doc = await _events.doc(id).get();
      if (!doc.exists || doc.data() == null) {
        throw const NotFoundException('Event not found');
      }
      return EventModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch event');
    }
  }

  @override
  Future<void> createEvent(EventModel model, String userId) async {
    try {
      final data = model.toFirestore()..['userId'] = userId;
      await _events.doc(model.id).set(data);
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to create event');
    }
  }

  @override
  Future<void> updateEvent(EventModel model) async {
    try {
      await _events.doc(model.id).update(model.toFirestore());
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to update event');
    }
  }

  @override
  Future<void> deleteEvent(String id) async {
    try {
      await _events.doc(id).delete();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to delete event');
    }
  }
}

abstract class EventLocalDatasource {
  Future<List<EventModel>> getCachedEvents();
  Future<void> cacheEvents(List<EventModel> events);
  Future<void> deleteEvent(String id);
}

class EventLocalDatasourceImpl implements EventLocalDatasource {
  EventLocalDatasourceImpl(this.database);

  final Database database;
  static const _table = 'events';

  @override
  Future<void> cacheEvents(List<EventModel> events) async {
    try {
      final batch = database.batch();
      for (final event in events) {
        batch.insert(_table, event.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    } catch (e) {
      throw CacheException('Failed to cache events: $e');
    }
  }

  @override
  Future<void> deleteEvent(String id) async {
    try {
      await database.delete(_table, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw CacheException('Failed to delete cached event: $e');
    }
  }

  @override
  Future<List<EventModel>> getCachedEvents() async {
    try {
      final rows = await database.query(_table, orderBy: 'dateTime ASC');
      return rows.map(EventModel.fromJson).toList();
    } catch (e) {
      throw CacheException('Failed to load cached events: $e');
    }
  }
}
