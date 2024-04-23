import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../color.dart';
import '../demo.dart';
import 'Favorite.dart';
import 'Home.dart';
import 'account.dart';
import 'cart.dart';

class BottomNavigationHome extends StatefulWidget {
  int selectedIndex;
  BottomNavigationHome({super.key, required this.selectedIndex});

  @override
  State<BottomNavigationHome> createState() => _BottomNavigationHomeState();
}

class _BottomNavigationHomeState extends State<BottomNavigationHome> {
  List<Widget> widgetspage = [
    HomeScreen(),
    const FavoriteScreen(),
    AddToCartScreen(),
    const account(),
  ];

  Future<bool> _onWillPop() async {
    if (widget.selectedIndex == 0) {
      return true;
    } else {
      setState(() {
        widget.selectedIndex = 0;
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Register the callback for back button press
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: CupertinoColors.black,
          unselectedItemColor: CupertinoColors.white,
          currentIndex: widget.selectedIndex!.toInt(),
          onTap: (value) {
            setState(() {
              widget.selectedIndex = value;
            });
          },
          items: const [
            BottomNavigationBarItem(
              backgroundColor: Colors.cyan,
              label: "Home",
              icon: Icon(
                Icons.home_outlined,
                color: CupertinoColors.black,
              ),
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.cyan,
              label: "Favorite",
              icon: Icon(
                Icons.favorite_border,
                color: CupertinoColors.black,
              ),
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.cyan,
              label: "Cart",
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: CupertinoColors.black,
              ),
            ),
            BottomNavigationBarItem(
              label: "Account",
              backgroundColor: Colors.cyan,
              icon: Icon(
                Icons.person_outline_outlined,
                color: CupertinoColors.black,
              ),
            ),
          ],
        ),
        body: widgetspage.elementAt(widget.selectedIndex!.toInt()),
      ),
    );
  }
}
