import 'package:eukay/components/loading_screen.dart';
import 'package:eukay/pages/dashboard/ui/dashboard_page.dart';
import 'package:eukay/pages/notification/ui/notification_page.dart';
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return LoadingScreen(color: Theme.of(context).colorScheme.secondary);
        }
        return controller.screens[controller.selectedIndex.value];
      }),
      bottomNavigationBar: Obx(
        () => NavigationBarTheme(
          data: NavigationBarThemeData(
            iconTheme: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return IconThemeData(
                  color: Theme.of(context).colorScheme.secondary,
                );
              }
              return IconThemeData(
                  color: Theme.of(context).colorScheme.onSecondary);
            }),
            labelTextStyle: WidgetStateProperty.all(
              TextStyle(
                fontSize: 12,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            indicatorColor: Theme.of(context).colorScheme.onSurface,
          ),
          child: NavigationBar(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            height: 75,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            onDestinationSelected: (index) {
              if (index >= 0 && index < controller.screens.length) {
                if (controller.selectedIndex.value == index) {
                  controller.refreshPage(index);
                } else {
                  controller.selectedIndex.value = index;
                }
              }
            },
            destinations: [
              // home destination
              NavigationDestination(
                icon: controller.isLoading.value &&
                        controller.selectedIndex.value == 0
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: LoadingScreen(
                            color: Theme.of(context).colorScheme.secondary),
                      )
                    : const Icon(Iconsax.home),
                label: "Home",
              ),

              // shop destination
              NavigationDestination(
                icon: controller.isLoading.value &&
                        controller.selectedIndex.value == 1
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: LoadingScreen(
                            color: Theme.of(context).colorScheme.secondary),
                      )
                    : const Icon(Iconsax.shop),
                label: "Shop",
              ),

              // notifications destination
              NavigationDestination(
                icon: controller.isLoading.value &&
                        controller.selectedIndex.value == 2
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: LoadingScreen(
                            color: Theme.of(context).colorScheme.secondary),
                      )
                    : const Icon(Iconsax.notification),
                label: "Notifications",
              ),

              // profile destination
              NavigationDestination(
                icon: controller.isLoading.value &&
                        controller.selectedIndex.value == 3
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: LoadingScreen(
                            color: Theme.of(context).colorScheme.secondary),
                      )
                    : const Icon(Iconsax.user),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final Rx<bool> isLoading = false.obs;

  final RxList<UniqueKey> screenKeys = [
    UniqueKey(),
    UniqueKey(),
    UniqueKey(),
    UniqueKey(),
  ].obs;

  List<Widget> get screens => [
        DashboardPage(key: screenKeys[0]),
        ShopPage(key: screenKeys[1]),
        NotificationPage(key: screenKeys[2]),
        ProfilePage(key: screenKeys[3]),
      ];

  void refreshPage(int index) async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    screenKeys[index] = UniqueKey();
    isLoading.value = false;
    update();
  }
}
