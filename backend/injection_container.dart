// lib/injection_container.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Core ────────────────────────────────────────────────────
import 'core/services/auth_service.dart';
import 'core/services/storage_service.dart';
import 'core/services/theme_service.dart';
import 'core/theme/theme_cubit.dart';

// ─── Hobbies ─────────────────────────────────────────────────
import 'features/hobbies/data/datasources/hobby_datasource.dart';
import 'features/hobbies/data/repositories/hobby_repository_impl.dart';
import 'features/hobbies/domain/repositories/hobby_repository.dart';
import 'features/hobbies/domain/usecases/hobby_usecases.dart';
import 'features/hobbies/presentation/cubit/hobby_cubit.dart';

// ─── Community ───────────────────────────────────────────────
import 'features/community/data/datasources/post_local_datasource.dart';
import 'features/community/data/datasources/post_remote_datasource.dart';
import 'features/community/data/repositories/post_repository_impl.dart';
import 'features/community/domain/repositories/post_repository.dart';
import 'features/community/domain/usecases/community_usecases.dart';
import 'features/community/presentation/cubit/post_cubit.dart';

// ─── Agenda ──────────────────────────────────────────────────
import 'features/agenda/data/datasources/event_datasource.dart';
import 'features/agenda/data/models/event_model.dart';
import 'features/agenda/data/repositories/event_repository_impl.dart';
import 'features/agenda/domain/repositories/event_repository.dart';
import 'features/agenda/domain/usecases/agenda_usecases.dart';
import 'features/agenda/presentation/cubit/agenda_cubit.dart';

// ─── Sports ──────────────────────────────────────────────────
import 'features/sports/data/datasources/sport_datasource.dart';
import 'features/sports/data/repositories/sport_repository_impl.dart';
import 'features/sports/domain/repositories/sport_repository.dart';
import 'features/sports/domain/sports_domain.dart';
import 'features/sports/presentation/cubit/sport_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  await _registerExternal();
  _registerCore();
  _registerHobbies();
  _registerCommunity();
  _registerAgenda();
  _registerSports();
}

// ─────────────────────────────────────────────────────────────
// EXTERNAL
// ─────────────────────────────────────────────────────────────
Future<void> _registerExternal() async {
  sl.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);
}

// ─────────────────────────────────────────────────────────────
// CORE
// ─────────────────────────────────────────────────────────────
void _registerCore() {
  sl.registerLazySingleton<StorageService>(() => StorageServiceImpl(sl()));
  sl.registerLazySingleton<AuthService>(() => AuthServiceImpl());
  sl.registerLazySingleton<ThemeService>(() => ThemeServiceImpl(sl()));
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit(sl()));
}

// ─────────────────────────────────────────────────────────────
// HOBBIES
// ─────────────────────────────────────────────────────────────
void _registerHobbies() {
  sl.registerLazySingleton<HobbyRemoteDatasource>(
    () => HobbyRemoteDatasourceImpl(sl<FirebaseFirestore>()),
  );
  sl.registerLazySingleton<HobbyLocalDatasource>(
    () => HobbyLocalDatasourceImpl(),
  );
  sl.registerLazySingleton<HobbyRepository>(
    () => HobbyRepositoryImpl(remote: sl(), local: sl(), auth: sl()),
  );
  sl.registerLazySingleton(() => GetHobbies(sl()));
  sl.registerLazySingleton(() => AddHobby(sl()));
  sl.registerLazySingleton(() => UpdateHobby(sl()));
  sl.registerLazySingleton(() => DeleteHobby(sl()));
  sl.registerFactory(() => HobbyCubit(
        getHobbies: sl(),
        addHobby: sl(),
        updateHobby: sl(),
        deleteHobby: sl(),
      ));
}

// ─────────────────────────────────────────────────────────────
// COMMUNITY
// ─────────────────────────────────────────────────────────────
void _registerCommunity() {
  sl.registerLazySingleton<PostRemoteDatasource>(
    () => PostRemoteDatasourceImpl(sl<FirebaseFirestore>()),
  );
  sl.registerLazySingleton<PostLocalDatasource>(
    () => PostLocalDatasourceImpl(null),
  );
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(remote: sl(), local: sl(), auth: sl()),
  );
  sl.registerLazySingleton(() => GetPosts(sl()));
  sl.registerLazySingleton(() => CreatePost(sl()));
  sl.registerLazySingleton(() => DeletePost(sl()));
  sl.registerLazySingleton(() => ToggleLike(sl()));
  sl.registerFactory(() => PostCubit(
        getPosts: sl(),
        createPost: sl(),
        deletePost: sl(),
        toggleLike: sl(),
      ));
}

// ─────────────────────────────────────────────────────────────
// AGENDA
// ─────────────────────────────────────────────────────────────
void _registerAgenda() {
  sl.registerLazySingleton<EventRemoteDatasource>(
    () => EventRemoteDatasourceImpl(sl<FirebaseFirestore>()),
  );
  sl.registerLazySingleton<EventLocalDatasource>(
    () => _EventLocalStub(),
  );
  sl.registerLazySingleton<EventRepository>(
    () => EventRepositoryImpl(remote: sl(), local: sl(), auth: sl()),
  );
  sl.registerLazySingleton(() => GetEvents(sl()));
  sl.registerLazySingleton(() => GetEventsForDay(sl()));
  sl.registerLazySingleton(() => AddEvent(sl()));
  sl.registerLazySingleton(() => UpdateEvent(sl()));
  sl.registerLazySingleton(() => DeleteEvent(sl()));
  sl.registerFactory(() => AgendaCubit(
        getEvents: sl(),
        addEvent: sl(),
        updateEvent: sl(),
        deleteEvent: sl(),
      ));
}

// ─────────────────────────────────────────────────────────────
// SPORTS
// ─────────────────────────────────────────────────────────────
void _registerSports() {
  sl.registerLazySingleton<SportRemoteDatasource>(
    () => SportRemoteDatasourceImpl(sl<FirebaseFirestore>()),
  );
  sl.registerLazySingleton<SportLocalDatasource>(
    () => SportLocalDatasourceImpl(null),
  );
  sl.registerLazySingleton<SportRepository>(
    () => SportRepositoryImpl(remote: sl(), local: sl(), auth: sl()),
  );
  sl.registerLazySingleton(() => GetActivities(sl()));
  sl.registerLazySingleton(() => GetActivitiesByType(sl()));
  sl.registerLazySingleton(() => LogActivity(sl()));
  sl.registerLazySingleton(() => UpdateActivity(sl()));
  sl.registerLazySingleton(() => DeleteActivity(sl()));
  sl.registerLazySingleton(() => GetStats(sl()));
  sl.registerFactory(() => SportCubit(
        getActivities: sl(),
        getActivitiesByType: sl(),
        logActivity: sl(),
        updateActivity: sl(),
        deleteActivity: sl(),
        getStats: sl(),
      ));
}

// ─────────────────────────────────────────────────────────────
// STUBS — replace with real sqflite impls in v2
// ─────────────────────────────────────────────────────────────
class _EventLocalStub implements EventLocalDatasource {
  @override
  Future<List<EventModel>> getCachedEvents() async => [];
  @override
  Future<void> cacheEvents(List<EventModel> events) async {}
  @override
  Future<void> deleteEvent(String id) async {}
}
