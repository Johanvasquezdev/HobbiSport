// lib/main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/theme_cubit.dart';
import 'core/services/theme_service.dart';
import 'injection_container.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase before anything else
  await Firebase.initializeApp();

  // Wire all dependencies
  await initDependencies();

  // Load persisted theme before first frame
  await sl<ThemeCubit>().loadSavedTheme();

  runApp(
    BlocProvider.value(
      value: sl<ThemeCubit>(),
      child: const HobbiSportApp(),
    ),
  );
}
