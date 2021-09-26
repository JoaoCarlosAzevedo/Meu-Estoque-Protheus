import 'package:flutter/material.dart';

import 'core/routes/routes.dart';

void main() {
  runApp(MeuEstoqueApp(
     router: AppRouter(),
  ));
}

class MeuEstoqueApp extends StatelessWidget {
  final AppRouter router;

  const MeuEstoqueApp({Key? key, required this.router}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: router.generateRoute,
    );
  }
}