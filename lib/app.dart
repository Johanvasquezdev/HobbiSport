import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/services/theme_service.dart';
import 'core/theme/theme_cubit.dart';
import 'features/agenda/presentation/cubit/agenda_cubit.dart';
import 'features/community/presentation/cubit/post_cubit.dart';
import 'features/hobbies/presentation/cubit/hobby_cubit.dart';
import 'features/sports/presentation/cubit/sport_cubit.dart';
import 'injection_container.dart';
import 'presentation/hobbisport/hobbisport_app.dart';
import 'presentation/hobbisport/hobbisport_theme.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<HobbyCubit>()..loadHobbies()),
        BlocProvider(create: (_) => sl<PostCubit>()..loadPosts()),
        BlocProvider(create: (_) => sl<AgendaCubit>()..loadEvents()),
        BlocProvider(create: (_) => sl<SportCubit>()..loadActivities()),
      ],
      child: BlocBuilder<ThemeCubit, AppThemeMode>(
        builder: (context, mode) {
          final palette = _mapPalette(mode);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'HobbiSport',
            theme: buildHobbiSportTheme(palette),
            home: HobbiSportApp(
              palette: palette,
              onPaletteChanged: (next) {
                context.read<ThemeCubit>().setTheme(_mapMode(next));
              },
            ),
          );
        },
      ),
    );
  }

  HobbiSportPalette _mapPalette(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.neon:
        return HobbiSportPalette.neon;
      case AppThemeMode.sunset:
        return HobbiSportPalette.sunset;
      case AppThemeMode.pop:
        return HobbiSportPalette.pop;
    }
  }

  AppThemeMode _mapMode(HobbiSportPalette palette) {
    switch (palette) {
      case HobbiSportPalette.neon:
        return AppThemeMode.neon;
      case HobbiSportPalette.sunset:
        return AppThemeMode.sunset;
      case HobbiSportPalette.pop:
        return AppThemeMode.pop;
    }
  }
}
