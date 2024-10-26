import 'package:eukay/components/appbar/my_app_bar.dart';
import 'package:flutter/material.dart';

class ServerErrorMessage extends StatelessWidget {
  final String message;
  const ServerErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: MyAppBar(
        label: "Server Error",
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
      body: Center(
        child: Text(
          message,
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }
}
