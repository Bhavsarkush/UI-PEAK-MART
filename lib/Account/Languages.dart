import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.blue, // Fallback color
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.indigo],
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Dark Mode'),
            trailing: Switch(
              value: false, // Replace with your dark mode state
              onChanged: (value) {
                // Implement dark mode change logic
              },
            ),
          ),
          ListTile(
            title: Text('Notifications'),
            trailing: Switch(
              value: true, // Replace with your notification state
              onChanged: (value) {
                // Implement notification settings logic
              },
            ),
          ),
          ListTile(
            title: Text('Language'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // Navigate to language selection screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LanguageSelectionScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Privacy Policy'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // Navigate to privacy policy screen
            },
          ),
          ListTile(
            title: Text('Terms & Conditions'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // Navigate to terms and conditions screen
            },
          ),
          // Add more settings options as needed
        ],
      ),
    );
  }
}

class LanguageSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Language'),
      ),
      body: ListView.builder(
        itemCount: indianLanguages.length + 1, // Add 1 for English
        itemBuilder: (context, index) {
          if (index == 0) {
            return ListTile(
              title: Text('English'),
              onTap: () {
                _setLanguage(context, 'English');
              },
            );
          } else {
            final language = indianLanguages[index - 1];
            return ListTile(
              title: Text(language),
              onTap: () {
                _setLanguage(context, language);
              },
            );
          }
        },
      ),
    );
  }

  void _setLanguage(BuildContext context, String language) {
    // Implement logic to set the selected language
    // For example, you can use a localization package or implement your own localization logic
    // Here, we'll simply print the selected language
    print('Selected language: $language');

    // Update UI to reflect the selected language
    // For example, you can update the MaterialApp's locale property
    // For simplicity, we'll just show a snackbar indicating the selected language
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected language: $language'),
      ),
    );

    // Navigate back to the previous screen
    Navigator.pop(context);
  }

  // List of all languages of India
  static const List<String> indianLanguages = [
    'Hindi'
  ];
}
