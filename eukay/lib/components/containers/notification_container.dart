import 'package:flutter/material.dart';

class NotificationContainer extends StatelessWidget {
  final String icon, message;
  const NotificationContainer(
      {super.key, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Container(
        color: Theme.of(context).colorScheme.onPrimary,
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // icon
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 25,
              backgroundImage: NetworkImage(icon),
            ),
            // spacing
            const SizedBox(width: 10),

            // message
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
