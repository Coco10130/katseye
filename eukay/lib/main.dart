import 'package:eukay/pages/auth/bloc/auth_bloc.dart';
import 'package:eukay/pages/cart/bloc/cart_bloc.dart';
import 'package:eukay/pages/auth/ui/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => CartBloc(),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Ukay',
        theme: ThemeData(
          colorScheme: const ColorScheme(
            primary: Color(0xFFADB4BF),
            secondary: Color(0xFF164BA1),
            surface: Color(0xFFFFFEFF),
            onSurface: Color(0xFFF0F4FA),
            onPrimary: Colors.white,
            onSecondary: Colors.black,
            error: Colors.red,
            onError: Colors.white,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const AuthPage(),
      ),
    );
  }
}
