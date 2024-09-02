import 'package:eukay/pages/dashboard/ui/dashboard_page.dart';
import 'package:eukay/pages/profile/ui/profile_page.dart';
import 'package:eukay/pages/shop/ui/shop_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NavigationMenu extends StatelessWidget {
  final String token;
  const NavigationMenu({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController(token));

    return Scaffold(
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => NavigationBarTheme(
          data: NavigationBarThemeData(
            iconTheme: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const IconThemeData(color: Colors.black54);
              }
              return const IconThemeData(color: Colors.black);
            }),
            labelTextStyle: WidgetStateProperty.all(
              const TextStyle(
                fontSize: 12,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            indicatorColor: Colors.grey[300],
          ),
          child: NavigationBar(
            backgroundColor: Colors.white,
            height: 75,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) =>
                controller.selectedIndex.value = index,
            destinations: const [
              NavigationDestination(icon: Icon(Iconsax.home), label: "Home"),
              NavigationDestination(icon: Icon(Iconsax.shop), label: "Shop"),
              NavigationDestination(icon: Icon(Iconsax.user), label: "Profile"),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final String token;

  NavigationController(this.token);

  List<Widget> get screens => [
        const DashboardPage(),
        ShopPage(
          token: token,
        ),
        ProfilePage(token: token),
      ];
}
