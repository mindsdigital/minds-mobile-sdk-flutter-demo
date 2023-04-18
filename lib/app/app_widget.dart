import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/presenter/theme/minds_colors.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Minds SDK Demo',
      theme: ThemeData().copyWith(
        colorScheme:
            ThemeData().colorScheme.copyWith(primary: MindsColors.green),
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
      debugShowCheckedModeBanner: false,
    );
  }
}
