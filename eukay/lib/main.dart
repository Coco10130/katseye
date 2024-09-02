import 'package:eukay/navigation_menu.dart';
import 'package:eukay/pages/auth/bloc/auth_bloc.dart';
import 'package:eukay/pages/auth/repo/auth_repo.dart';
import 'package:eukay/pages/cart/bloc/cart_bloc.dart';
import 'package:eukay/pages/auth/ui/auth_page.dart';
import 'package:eukay/pages/profile/bloc/profile_bloc.dart';
import 'package:eukay/pages/profile/repo/profile_repo.dart';
import 'package:eukay/pages/shop/bloc/shop_bloc.dart';
import 'package:eukay/pages/shop/repo/shop_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(
    token: prefs.getString("token"),
  ));
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(AuthRepo()),
        ),
        BlocProvider(
          create: (context) => CartBloc(),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(ProfileRepo()),
        ),
        BlocProvider(
          create: (context) => ShopBloc(ShopRepo()),
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
            onPrimary: Color(0xFFF8F8FF),
            onSecondary: Color(0xFF252525),
            error: Colors.red,
            onError: Colors.white,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: (token != null && JwtDecoder.isExpired(token!) == false)
            ? NavigationMenu(token: token!)
            : const AuthPage(),
      ),
    );
  }
}
