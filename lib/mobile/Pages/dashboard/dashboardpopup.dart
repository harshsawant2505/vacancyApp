import 'package:bits_hackathon/mobile/Pages/dashboard/userdashboard.dart';
import 'package:flutter/material.dart';

class AccountPopUp extends StatelessWidget {
  const AccountPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: const Color.fromARGB(0, 255, 255, 255),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "name here",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            "email@email.com",
            style: TextStyle(fontSize: 13),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const MenuButton(
                icon: Icons.account_circle, text: "Your account"),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const MenuButton(icon: Icons.call, text: "complain"),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Dashboard();
              }));
            },
            child: const MenuButton(icon: Icons.account_circle, text: "Account"),
          ),
        ],
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String text;
  const MenuButton({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        Row(
          children: [
            Icon(icon),
            const Spacer(),
            Text(text),
            const Spacer(flex: 5),
          ],
        ),
      ],
    );
  }
}
