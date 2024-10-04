import 'package:eukay/navigation_menu.dart';
import 'package:eukay/pages/auth/bloc/auth_bloc.dart';
import 'package:eukay/pages/auth/repo/auth_repo.dart';
import 'package:eukay/pages/cart/bloc/cart_bloc.dart';
import 'package:eukay/pages/cart/repo/cart_repo.dart';
import 'package:eukay/pages/check_out/bloc/check_out_bloc.dart';
import 'package:eukay/pages/check_out/repo/check_out_repo.dart';
import 'package:eukay/pages/dashboard/bloc/dashboard_bloc.dart';
import 'package:eukay/pages/dashboard/repo/dashboard_repo.dart';
import 'package:eukay/pages/profile/bloc/profile_bloc.dart';
import 'package:eukay/pages/profile/repo/profile_repo.dart';
import 'package:eukay/pages/search/bloc/search_bloc.dart';
import 'package:eukay/pages/search/repo/search_repo.dart';
import 'package:eukay/pages/shop/bloc/shop_bloc.dart';
import 'package:eukay/pages/shop/repo/shop_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(AuthRepo()),
        ),
        BlocProvider(
          create: (context) => CartBloc(CartRepo()),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(ProfileRepo()),
        ),
        BlocProvider(
          create: (context) => ShopBloc(ShopRepo()),
        ),
        BlocProvider(
          create: (context) => DashboardBloc(DashboardRepo()),
        ),
        BlocProvider(
          create: (context) => SearchBloc(SearchRepo()),
        ),
        BlocProvider(
          create: (context) => CheckOutBloc(CheckOutRepo()),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Ukay',
        theme: ThemeData(
          colorScheme: const ColorScheme(
            primary: Color(0xFFADB4BF),
            secondary: Color(0xFF164BA1),
            surface: Color.fromARGB(255, 47, 21, 47),
            onSurface: Color(0xFFF0F4FA),
            onPrimary: Color(0xFFF8F8FF),
            onSecondary: Color(0xFF0C0C0C),
            error: Colors.red,
            onError: Colors.white,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const NavigationMenu(),
      ),
    );
  }
}
