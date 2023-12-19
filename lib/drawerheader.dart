import 'package:flutter/material.dart';
import 'package:microhabits/authentication/pages/login.dart';
import 'package:microhabits/trying/pedochart.dart';
import 'package:microhabits/trying/schedule.dart';

class MyHeaderDrawer extends StatelessWidget {
  const MyHeaderDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.65,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("make you day "),
              accountEmail: Text('a great day'),
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 225, 181, 181)),
            ),
            ListTile(
              leading: const Icon(Icons.run_circle),
              title: const Text('my progress'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StepCountHistoryPage(),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favorites'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TODOChart(),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("logout"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ));
              },
            )
          ],
        ),
      ),
    );
  }
}
