import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pmartui/model/ProductModel.dart';
import 'package:pmartui/product/ProductDetailsScreen.dart';

import '../color.dart';
import '../subcategory/subcategory.dart';
import 'cart.dart';
class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<String> favoriteProductIds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Products',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Favorites')
            .where('UID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final favoriteProducts = snapshot.data!.docs;

          if (favoriteProducts.isEmpty) {
            return Center(
              child: Text('You have no favorite products yet.',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            );
          }

          favoriteProductIds =
              favoriteProducts.map((doc) => doc.id).toList();

          return ListView.builder(
            itemCount: favoriteProducts.length,
            itemBuilder: (context, index) {
              final favoriteProduct = ProductModel.fromSnapshot(
                  favoriteProducts[index]);
              return ProductCard(
                product: favoriteProduct,
                onFavoriteTap: () async {
                  await FirebaseFirestore.instance
                      .collection('Favorites')
                      .doc(favoriteProduct.id)
                      .delete();
                },
                onCartTap: () async {
                  await _addToCart(favoriteProduct);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddToCartScreen(),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _addToCart(ProductModel product) async {
    try {
      double totalPrice = double.parse(product.newPrice.replaceAll(',', '')) *
          int.parse(product.selectedqty);
      await FirebaseFirestore.instance.collection('ShoppingCart').add({
        'UID': FirebaseAuth.instance.currentUser!.uid,
        'images': product.images,
        'productName': product.productName,
        'productPrice': product.productPrice,
        'productNewPrice': product.newPrice,
        'discount': product.discount,
        'quantity': product.selectedqty,
        'totalprice': totalPrice.toString(),
        'productTitle1': product.title1,
        'productTitle2': product.title2,
        'productTitle3': product.title3,
        'productTitle4': product.title4,
        'productTitleDetail1': product.product1,
        'productTitleDetail2': product.product2,
        'productTitleDetail3': product.product3,
        'productTitleDetail4': product.product4,
        'productDescription': product.productDescription,
        'productColor': product.color,
        'brand': product.brand,
      });

      // Remove the product from favorites after adding to cart
      await FirebaseFirestore.instance
          .collection('Favorites')
          .doc(product.id)
          .delete();

      print('Product added to cart and removed from favorites successfully!');
    } catch (e) {
      print('Error processing your request: $e');
    }
  }

}

  class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onFavoriteTap;
  final VoidCallback onCartTap;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onFavoriteTap,
    required this.onCartTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          leading: Image.network(
            product.images![0],
            width: 90,
            height: 90,
            fit: BoxFit.cover,
          ),
          title: Text(
            product.productName,
            style: theme.textTheme.subtitle1?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '₹${product.newPrice}',
                style: theme.textTheme.subtitle1?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Quantity: ${product.selectedqty}',
                style: theme.textTheme.subtitle1?.copyWith(
                  color: Colors.black,
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                onPressed: onFavoriteTap,
              ),
              IconButton(
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: CupertinoColors.black,
                ),
                onPressed: onCartTap,
              ),
            ],
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductDetails(product: product),
              ),
            );
          },
        ),
      ),
    );
  }
}

