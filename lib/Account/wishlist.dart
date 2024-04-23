import 'package:flutter/material.dart';
import 'package:pmartui/BottomNavigationBar/Favorite.dart';

class wishlist extends StatefulWidget {
  const wishlist({super.key});

  @override
  State<wishlist> createState() => _wishlistState();
}

class _wishlistState extends State<wishlist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FavoriteScreen(),
    );
  }
}
