import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pmartui/Login%20&%20Sign%20up/sign%20up.dart';
import '../BottomNavigationBar/bottomnav.dart';
import '../color.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = false;
  double _imagePositionX = -150; // Initial position off-screen to the left

  @override
  void initState() {
    super.initState();

    // Set visibility to true after a delay
    Timer(Duration(seconds: 2), () {
      setState(() {
        _isVisible = true;
      });
    });

    // Animate image to center after a delay
    Timer(Duration(seconds: 3), () {
      setState(() {
        _imagePositionX = (MediaQuery.of(context).size.width - 150) / 2;
      });
    });

    // Navigate after a delay
    Timer(Duration(seconds: 4), () {
      if (FirebaseAuth.instance.currentUser != null) {
        // User is already logged in, navigate to HomeScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => BottomNavigationHome(selectedIndex: 0,),
          ),
        );
      } else {
        // User is not logged in, navigate to LoginScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      }
    });
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          // Detect left swipe gesture
          if (details.delta.dx < 0) {
            _navigateToLogin();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.cyan.shade500, Colors.cyan.shade100],
              stops: [0.0, 0.7], // Adjust stops as needed
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated image with position
                AnimatedPositioned(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  left: _imagePositionX,
                  child: AnimatedOpacity(
                    opacity: _isVisible ? 1.0 : 0.0,
                    duration: Duration(seconds: 1), // Adjust duration as needed
                    child: Image.asset(
                      'assets/images/splash.png',
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'PeakMart',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 100, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome to ShopperStore",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Let's User Login to the ShopperStore",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter email";
                        } else if (!value.contains("@") || !value.contains(".")) {
                          return "Please Enter A Valid Email";
                        }
                        return null;
                      },
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Enter Your Email",
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Password";
                        }
                        return null;
                      },
                      controller: passwordController,
                      obscureText: passwordVisible,
                      decoration: InputDecoration(
                        hintText: "Enter Your Password",
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                          icon: passwordVisible
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      height: 60,
                      width: 60,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              await FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => BottomNavigationHome(selectedIndex: 0,)),
                              );
                              setState(() {
                                emailController.clear();
                                passwordController.clear();
                              });
                            } on FirebaseAuthException catch (e) {
                              print("Firebase Auth Exception: ${e.code}");
                              if (e.code == "user-not-found" || e.code == "wrong-password") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Invalid Email or Password"),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Invalid Email or Password"),
                                  ),
                                );
                              }
                            } catch (e) {
                              print("Error: $e");
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Invalid Email or Password"),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan[600],
                          side: const BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(70),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Center(
                            child: Icon(Icons.arrow_forward_outlined, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       TextButton(onPressed: (){
                  //         Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotScreen()));
                  //       },
                  //           child: Text("Forgot Password?")
                  //       )
                  //     ],
                  //   ),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an Account ?"),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                        },
                        child: const Text("Sign Up", style: TextStyle(color: Colors.blueGrey)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}