import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import 'core/services/auth_service.dart';
import 'core/services/storage_service.dart';
import 'core/services/theme_service.dart';
import 'core/theme/theme_cubit.dart';
import 'features/agenda/data/datasources/event_datasource.dart';
import 'features/agenda/data/repositories/event_repository_impl.dart';
import 'features/agenda/domain/repositories/event_repository.dart';
import 'features/agenda/domain/usecases/agenda_usecases.dart';
import 'features/agenda/presentation/cubit/agenda_cubit.dart';
import 'features/community/data/datasources/post_local_datasource.dart';
import 'features/community/data/datasources/post_remote_datasource.dart';
import 'features/community/data/repositories/post_repository_impl.dart';
import 'features/community/domain/repositories/post_repository.dart';
import 'features/community/domain/usecases/community_usecases.dart';
import 'features/community/presentation/cubit/post_cubit.dart';
import 'features/hobbies/data/datasources/hobby_datasource.dart';
import 'features/hobbies/data/repositories/hobby_repository_impl.dart';
import 'features/hobbies/domain/repositories/hobby_repository.dart';
import 'features/hobbies/domain/usecases/hobby_usecases.dart';
import 'features/hobbies/presentation/cubit/hobby_cubit.dart';
import 'features/sports/data/datasources/sport_datasource.dart';
import 'features/sports/data/repositories/sport_repository_impl.dart';
import 'features/sports/domain/repositories/sport_repository.dart';
import 'features/sports/domain/usecases/sport_usecases.dart';
import 'features/sports/presentation/cubit/sport_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  await _registerExternal();
  await _registerCore();
  _registerHobbies();
  _registerCommunity();
  _registerAgenda();
  _registerSports();
}

Future<void> _registerExternal() async {
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<Uuid>(() => const Uuid());

  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);
}

Future<void> _registerCore() async {
  if (!kIsWeb) {
    sl.registerLazySingleton<StorageService>(() => StorageServiceImpl());
    final db = await sl<StorageService>().database();
    sl.registerSingleton<Database>(db);
  }

  sl.registerLazySingleton<AuthService>(() => AuthServiceImpl(sl<FirebaseAuth>()));
  sl.registerLazySingleton<ThemeService>(() => ThemeServiceImpl(sl<SharedPreferences>()));
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit(sl<ThemeService>()));
}

void _registerHobbies() {
  sl.registerLazySingleton<HobbyRemoteDatasource>(
    () => HobbyRemoteDatasourceImpl(sl<FirebaseFirestore>()),
  );
  sl.registerLazySingleton<HobbyLocalDatasource>(() => HobbyLocalDatasourceImpl());

  sl.registerLazySingleton<HobbyRepository>(
    () => HobbyRepositoryImpl(remote: sl(), local: sl(), auth: sl()),
  );

  sl.registerLazySingleton(() => GetHobbies(sl<HobbyRepository>()));
  sl.registerLazySingleton(() => AddHobby(sl<HobbyRepository>(), sl<Uuid>()));
  sl.registerLazySingleton(() => UpdateHobby(sl<HobbyRepository>()));
  sl.registerLazySingleton(() => DeleteHobby(sl<HobbyRepository>()));

  sl.registerFactory(
    () => HobbyCubit(
      getHobbies: sl(),
      addHobby: sl(),
      updateHobby: sl(),
      deleteHobby: sl(),
    ),
  );
}

void _registerCommunity() {
  sl.registerLazySingleton<PostRemoteDatasource>(
    () => PostRemoteDatasourceImpl(sl<FirebaseFirestore>()),
  );
  sl.registerLazySingleton<PostLocalDatasource>(() {
    if (kIsWeb) return InMemoryPostLocalDatasource();
    return PostLocalDatasourceImpl(sl<Database>());
  });

  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(remote: sl(), local: sl(), auth: sl()),
  );

  sl.registerLazySingleton(() => GetPosts(sl<PostRepository>()));
  sl.registerLazySingleton(() => CreatePost(sl<PostRepository>(), sl<Uuid>()));
  sl.registerLazySingleton(() => DeletePost(sl<PostRepository>()));
  sl.registerLazySingleton(() => ToggleLike(sl<PostRepository>()));

  sl.registerFactory(
    () => PostCubit(
      getPosts: sl(),
      createPost: sl(),
      deletePost: sl(),
      toggleLike: sl(),
    ),
  );
}

void _registerAgenda() {
  sl.registerLazySingleton<EventRemoteDatasource>(
    () => EventRemoteDatasourceImpl(sl<FirebaseFirestore>()),
  );
  sl.registerLazySingleton<EventLocalDatasource>(() {
    if (kIsWeb) return InMemoryEventLocalDatasource();
    return EventLocalDatasourceImpl(sl<Database>());
  });

  sl.registerLazySingleton<EventRepository>(
    () => EventRepositoryImpl(remote: sl(), local: sl(), auth: sl()),
  );

  sl.registerLazySingleton(() => GetEvents(sl<EventRepository>()));
  sl.registerLazySingleton(() => GetEventsForDay(sl<EventRepository>()));
  sl.registerLazySingleton(() => AddEvent(sl<EventRepository>(), sl<Uuid>()));
  sl.registerLazySingleton(() => UpdateEvent(sl<EventRepository>()));
  sl.registerLazySingleton(() => DeleteEvent(sl<EventRepository>()));

  sl.registerFactory(
    () => AgendaCubit(
      getEvents: sl(),
      addEvent: sl(),
      updateEvent: sl(),
      deleteEvent: sl(),
    ),
  );
}

void _registerSports() {
  sl.registerLazySingleton<SportRemoteDatasource>(
    () => SportRemoteDatasourceImpl(sl<FirebaseFirestore>()),
  );
  sl.registerLazySingleton<SportLocalDatasource>(() {
    if (kIsWeb) return InMemorySportLocalDatasource();
    return SportLocalDatasourceImpl(sl<Database>());
  });

  sl.registerLazySingleton<SportRepository>(
    () => SportRepositoryImpl(remote: sl(), local: sl(), auth: sl()),
  );

  sl.registerLazySingleton(() => GetActivities(sl<SportRepository>()));
  sl.registerLazySingleton(() => GetActivitiesByType(sl<SportRepository>()));
  sl.registerLazySingleton(() => LogActivity(sl<SportRepository>(), sl<Uuid>()));
  sl.registerLazySingleton(() => UpdateActivity(sl<SportRepository>()));
  sl.registerLazySingleton(() => DeleteActivity(sl<SportRepository>()));
  sl.registerLazySingleton(() => GetStats(sl<SportRepository>()));

  sl.registerFactory(
    () => SportCubit(
      getActivities: sl(),
      getActivitiesByType: sl(),
      logActivity: sl(),
      updateActivity: sl(),
      deleteActivity: sl(),
      getStats: sl(),
    ),
  );
}
