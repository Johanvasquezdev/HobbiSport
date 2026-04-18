import 'package:flutter/material.dart';
import 'presentation/hobbisport/hobbisport_app.dart';
import 'presentation/hobbisport/hobbisport_theme.dart';

class HobbiSportRoot extends StatefulWidget {
  const HobbiSportRoot({super.key});

  @override
  State<HobbiSportRoot> createState() => _HobbiSportRootState();
}

class _HobbiSportRootState extends State<HobbiSportRoot> {
  HobbiSportPalette _palette = HobbiSportPalette.neon;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HobbiSport',
      theme: buildHobbiSportTheme(_palette),
      home: HobbiSportApp(
        palette: _palette,
        onPaletteChanged: (palette) => setState(() => _palette = palette),
      ),
    );
  }
}
