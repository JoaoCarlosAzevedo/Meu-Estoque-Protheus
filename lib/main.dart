import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meuestoque_protheus/core/constants.dart';

import 'core/routes/routes.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  runApp(
    MeuEstoqueApp(
      router: AppRouter(),
    ),
  );
}

class MeuEstoqueApp extends StatelessWidget {
  final AppRouter router;

  const MeuEstoqueApp({Key? key, required this.router}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: router.generateRoute,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
    );
  }
}
