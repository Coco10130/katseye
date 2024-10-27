import 'package:eukay/components/buttons/my_button.dart';
import 'package:eukay/components/containers/notification_container.dart';
import 'package:eukay/components/loading_screen.dart';
import 'package:eukay/components/my_snackbar.dart';
import 'package:eukay/components/navigate_to_auth.dart';
import 'package:eukay/components/server_error_message.dart';
import 'package:eukay/components/transitions/navigation_transition.dart';
import 'package:eukay/pages/auth/ui/auth_page.dart';
import 'package:eukay/pages/cart/ui/cart_page.dart';
import 'package:eukay/pages/notification/bloc/notification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late SharedPreferences pref;
  late String cartCount;
  late String token = "";
  String? userId;
  bool initializedToken = false;

  void onResetToken() {
    initPref().then((_) {
      initCartCount();
    });
  }

  Future<void> initPref() async {
    try {
      pref = await SharedPreferences.getInstance();
      setState(() {
        initializedToken = true;
        token = pref.getString("token") ?? "";
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void initCartCount() {
    if (token.isNotEmpty) {
      final Map<String, dynamic> jwtDecocded = JwtDecoder.decode(token);
      setState(() {
        cartCount = jwtDecocded["cartItems"].toString();
        userId = jwtDecocded["id"].toString();
      });
    }
  }

  Future<void> _fetchNotifications() async {
    context
        .read<NotificationBloc>()
        .add(FetchNotificationsEvent(token: token, userId: userId!));
  }

  @override
  void initState() {
    super.initState();
    initPref().then((_) {
      initCartCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!initializedToken) {
      return LoadingScreen(color: Theme.of(context).colorScheme.onSecondary);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            "Notifications",
            style: TextStyle(
              fontSize: 24,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        actions: [
          // cart action button
          token != ""
              ? Stack(
                  children: [
                    Positioned(
                      right: 15,
                      child: Text(
                        cartCount,
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: "Poppins",
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: IconButton(
                        icon: const ImageIcon(
                          AssetImage("assets/icons/shopping-cart.png"),
                          size: 24,
                          color: Color(0xFFFFFFFF),
                        ),
                        onPressed: () {
                          initializedToken = false;
                          navigateWithSlideTransition(
                              context: context,
                              page: CartPage(
                                token: pref.getString("token")!,
                              ),
                              onFetch: () {
                                onResetToken();
                                _fetchNotifications();
                              });
                        },
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: MyButton(
                    title: "Sign in",
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    textColor: Theme.of(context).colorScheme.onSecondary,
                    widthFactor: 0.20,
                    fontSize: 12,
                    height: 40,
                    verticalPadding: 5,
                    onPressed: () {
                      navigateWithSlideTransition(
                        context: context,
                        page: const AuthPage(),
                        onFetch: () => onResetToken(),
                      );
                    },
                  ),
                ),
        ],
      ),
      body: token.isEmpty
          ? NavigateAuthButtons(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              textColor: Theme.of(context).colorScheme.onSecondary,
              buttonTextColor: Theme.of(context).colorScheme.onPrimary,
              onReset: () => onResetToken(),
            )
          : NotificationBody(
              onFetch: () => _fetchNotifications(),
              userId: userId!,
              token: token,
            ),
    );
  }
}

class NotificationBody extends StatefulWidget {
  final String userId, token;
  final VoidCallback onFetch;
  const NotificationBody(
      {super.key,
      required this.userId,
      required this.token,
      required this.onFetch});

  @override
  State<NotificationBody> createState() => _NotificationBodyState();
}

class _NotificationBodyState extends State<NotificationBody> {
  @override
  void initState() {
    super.initState();
    widget.onFetch();
  }

  Future<void> _refresh() async {
    widget.onFetch();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is FetchNotificationFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            mySnackBar(
              message: state.errorMessage,
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.error,
            ),
          );
        } else if (state is NotificationServerErrorState) {
          navigateWithSlideTransition(
            context: context,
            page: ServerErrorMessage(message: state.errorMessage),
            onFetch: () => widget.onFetch(),
          );
        }
      },
      builder: (context, state) {
        if (state is FetchNotificationSuccessState) {
          final notifications = state.notifications;
          notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          if (notifications.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => _refresh(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  height:
                      MediaQuery.of(context).size.height - kToolbarHeight - 100,
                  alignment: Alignment.center,
                  child: Center(
                    child: Text(
                      "No notifications available yet",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => _refresh(),
            child: SingleChildScrollView(
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];

                        return NotificationContainer(
                          icon: notification.icon,
                          message: notification.message,
                        );
                      })),
            ),
          );
        }

        return LoadingScreen(color: Theme.of(context).colorScheme.onSecondary);
      },
    );
  }
}
