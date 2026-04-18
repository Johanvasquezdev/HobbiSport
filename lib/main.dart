import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'core/theme/theme_cubit.dart';
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await initDependencies();
  await sl<ThemeCubit>().loadSavedTheme();

  runApp(
    BlocProvider.value(
      value: sl<ThemeCubit>(),
      child: const AppRoot(),
    ),
  );
}
