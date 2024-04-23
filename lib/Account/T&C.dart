// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class TermsOfUseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('Terms of Use',style: TextStyle( color: Colors.black,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.only(left: 114),
                child: Text(
                  'Terms of Use',
                  style: TextStyle(
                    color: Colors.black, // Changed to black
                    fontSize: 28, // Increased font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Divider(thickness: 3,),
              SizedBox(height: 16),
              Text(
                'Welcome To Peak Mart!',

                style: TextStyle(
                  color: Colors.black, // Changed to black
                  fontSize: 20, // Increased font size
                  fontStyle: FontStyle.italic,
                ),
              ),

              SizedBox(height: 16),

              Text(
                'Dear User,',
                style: TextStyle(
                  color: Colors.black, // Changed to black
                  fontSize: 18, // Increased font size
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Thank you for choosing Peak Mart. These Terms of Use govern your use of our mobile application. By accessing or using the app, you agree to be bound by these terms. If you disagree with any part of these terms, you may not use the app.',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                '1. License',
                style: TextStyle(
                  color: Colors.black, // Changed to black
                  fontSize: 22, // Increased font size
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'We grant you a limited, non-exclusive, non-transferable, and revocable license to use our app for your personal and non-commercial purposes only. You may not modify, reproduce, or distribute the app in any way without our prior written consent.',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(height: 16),
              Divider(thickness: 3,),
              Text(
                '2. User Conduct',
                style: TextStyle(
                  color: Colors.black, // Changed to black
                  fontSize: 22, // Increased font size
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 8),
              Text(
                'You agree to use the app in compliance with all applicable laws, regulations, and third-party agreements. You must not engage in any activity that interferes with or disrupts the operation of the app or its servers.',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(height: 16),
              Divider(thickness: 3,),
              Text(
                '3. Intellectual Property Rights',
                style: TextStyle(
                  color: Colors.black, // Changed to black
                  fontSize: 22, // Increased font size
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'The app and its original content, features, and functionality are owned by us and are protected by international copyright, trademark, patent, trade secret, and other intellectual property or proprietary rights.',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(height: 16),
              // Add more sections as needed
            ],
          ),
        ),
      ),
    );
  }
}
