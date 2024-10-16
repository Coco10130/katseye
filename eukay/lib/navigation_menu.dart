import 'package:eukay/pages/dashboard/ui/dashboard_page.dart';
import 'package:eukay/pages/profile/ui/profile_page.dart';
import 'package:eukay/pages/shop/ui/shop_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => NavigationBarTheme(
          data: NavigationBarThemeData(
            iconTheme: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return IconThemeData(
                  color: Theme.of(context).colorScheme.onSecondary,
                );
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
            indicatorColor: Theme.of(context).colorScheme.onSurface,
          ),
          child: NavigationBar(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
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

  List<Widget> get screens => const [
        DashboardPage(),
        ShopPage(),
        ProfilePage(),
      ];
}
