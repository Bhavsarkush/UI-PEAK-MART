import 'package:flutter/material.dart';
import 'package:pmartui/Account/Languages.dart';
import 'package:pmartui/Account/Privacy%20Policy.dart';
import 'package:pmartui/Account/T&C.dart';
import 'package:provider/provider.dart';

import '../Provider.dart';
import '../color.dart';
import 'Helpcenter.dart';
import 'Saved address.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: valo,
        centerTitle: true,
        elevation: 4.0, // Add a subtle shadow to the AppBar
      ),
      body: Padding( // Add padding for a better layout
        padding: const EdgeInsets.all(16.0),
        child: Column( // Changed to Column with separated sections
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preferences',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 10), // Consistent spacing
            ListTile(
              title: Text('Dark Mode'),
              leading: Icon(Icons.dark_mode), // Added leading icon
              trailing: Switch(
                value: false, // Replace with your dark mode state
                onChanged: (value) {
                  Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                },
              ),
            ),
            Divider(), // Add divider between sections
            ListTile(
              title: Text('Notifications'),
              leading: Icon(Icons.notifications, color: Colors.blue),
              trailing: Switch(
                value: true, // Replace with your notification state
                onChanged: (value) {
                  // Implement notification settings logic
                },
              ),
            ),
            Divider(), // Divider between sections
            Text(
              'General',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 10), // Consistent spacing
            ListTile(
              title: Text('Saved Address'),
              leading: Icon(Icons.location_pin, color: Colors.green),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Saveaddress()),
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text('Privacy Policy'),
              leading: Icon(Icons.privacy_tip, color: Colors.red),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text('Terms & Conditions'),
              leading: Icon(Icons.rule, color: Colors.purple),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TermsOfUseScreen()),
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text('Help Center'),
              leading: Icon(Icons.help, color: Colors.orange),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NeedHelpScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
