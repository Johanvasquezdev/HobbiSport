// lib/features/agenda/data/datasources/event_remote_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/exceptions.dart';
import '../models/event_model.dart';

// ─── Abstract ────────────────────────────────────────────────
abstract class EventRemoteDatasource {
  Future<List<EventModel>> fetchEvents(String userId);
  Future<List<EventModel>> fetchEventsForDay(String userId, DateTime date);
  Future<EventModel> fetchEventById(String id);
  Future<String> createEvent(EventModel model, String userId);
  Future<void> updateEvent(EventModel model);
  Future<void> deleteEvent(String id);
}

// ─── Firebase Implementation ─────────────────────────────────
class EventRemoteDatasourceImpl implements EventRemoteDatasource {
  final FirebaseFirestore firestore;

  EventRemoteDatasourceImpl(this.firestore);

  static const String _collection = 'events';

  @override
  Future<List<EventModel>> fetchEvents(String userId) async {
    try {
      final snap = await firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('dateTime')
          .get();
      return snap.docs.map(EventModel.fromFirestore).toList();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch events');
    }
  }

  @override
  Future<List<EventModel>> fetchEventsForDay(
      String userId, DateTime date) async {
    try {
      final start = DateTime(date.year, date.month, date.day);
      final end = start.add(const Duration(days: 1));

      final snap = await firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('dateTime',
              isGreaterThanOrEqualTo: Timestamp.fromDate(start))
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
      final doc =
          await firestore.collection(_collection).doc(id).get();
      if (!doc.exists) throw const NotFoundException('Event not found');
      return EventModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch event');
    }
  }

  @override
  Future<String> createEvent(EventModel model, String userId) async {
    try {
      final data = model.toFirestore()..['userId'] = userId;
      final ref = await firestore.collection(_collection).add(data);
      return ref.id;
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to create event');
    }
  }

  @override
  Future<void> updateEvent(EventModel model) async {
    try {
      await firestore
          .collection(_collection)
          .doc(model.id)
          .update(model.toFirestore());
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to update event');
    }
  }

  @override
  Future<void> deleteEvent(String id) async {
    try {
      await firestore.collection(_collection).doc(id).delete();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to delete event');
    }
  }
}

// ─────────────────────────────────────────────────────────────
// LOCAL DATASOURCE
// ─────────────────────────────────────────────────────────────

abstract class EventLocalDatasource {
  Future<List<EventModel>> getCachedEvents();
  Future<void> cacheEvents(List<EventModel> events);
  Future<void> deleteEvent(String id);
}
