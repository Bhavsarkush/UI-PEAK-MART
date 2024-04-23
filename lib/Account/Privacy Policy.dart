import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
          backgroundColor: Colors.cyan, // Fallback color
      ),
      body:Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only( left: 17.5),
                  child: Text(
                    'Privacy Policy',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Divider(thickness: 3,),
              SizedBox(height: 16),
              Text(
                'Your Trust is Our Top Priority',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 16),

              Text(
                'Dear User,',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Thank you for choosing Peak Mart. We take your privacy seriously and are committed to protecting your personal information. Our Privacy Policy outlines how we collect, use, and safeguard your data.',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Information We Collect',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'When you use our app, we may collect certain information to provide and improve our services. This may include device information, usage data, and information you provide to us.',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'How We Use Your Information',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'We use the information we collect to personalize your experience, communicate with you, and improve our app. Your data is never shared with third parties without your consent.',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              // Add more sections as needed
            ],
          ),
        ),
      ),
    );
  }
}
