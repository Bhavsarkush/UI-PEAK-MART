import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pmartui/Account/My%20account.dart';
import 'package:pmartui/Account/order.dart';
import 'package:pmartui/Account/wishlist.dart';
import 'package:pmartui/Login%20&%20Sign%20up/Login.dart';

import '../Account/settings.dart';
import '../color.dart';

class account extends StatefulWidget {
  const account({super.key});

  @override
  State<account> createState() => _accountState();
}

class _accountState extends State<account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Details",style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: [
          _buildAccountCard("My Account", Icons.person, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccountUser()),
            );
          }),
          _buildAccountCard("My Wishlist", Icons.favorite, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => wishlist()),
            );
          }),
          _buildAccountCard("My Orders", Icons.shopping_cart, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderListScreen()),
            );
          }),
          _buildAccountCard("Settings", Icons.settings, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
          }),
          _buildLogoutCard("Logout", Icons.logout),
        ],
      ),
    );
  }

  Widget _buildAccountCard(String title, IconData icon, void Function() onTap) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          size: 30,
          color: Colors.cyan,
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        trailing: Icon(Icons.chevron_right, size: 30, color: Colors.cyan),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutCard(String title, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          size: 30,
          color: Colors.red,
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        trailing: Icon(Icons.chevron_right, size: 30, color: Colors.red),
        onTap: () {
          _showLogoutDialog();
        },
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut(); // Log out the user
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false,
                );
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}
