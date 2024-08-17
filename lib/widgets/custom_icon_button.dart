import 'package:flutter/material.dart';
import 'package:trip_to_kumari/pages/notification.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    Key? key,
    required this.icon,
    required EdgeInsets padding,
  }) : super(key: key);
  final Widget icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color.fromARGB(255, 255, 255, 255),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 32, 100, 231).withOpacity(0.1),
            spreadRadius: 6,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationPage(),
            ),
          );
        },
        constraints: const BoxConstraints.tightFor(width: 60),
        color: const Color.fromARGB(255, 32, 100, 231),
        icon: icon,
        splashRadius: 32,
      ),
    );
  }
}
