import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';

import '../model/ProductModel.dart';
import 'ProductDetailsScreen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = searchController.text;
      isSearching = searchQuery.isNotEmpty;
    });
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.white,
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Container(
                height: 50,
                width: 50,
                color: Colors.grey,
              ),
              title: Container(
                height: 16,
                color: Colors.grey,
              ),
              subtitle: Container(
                height: 14,
                color: Colors.grey,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(25),
          ),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search for products...',
              border: InputBorder.none,
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
              suffixIcon: isSearching
                  ? IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: Colors.grey,
                ),
                onPressed: () => searchController.clear(),
              )
                  : null,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Products").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerEffect();
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Error fetching data',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          final products = snapshot.data!.docs
              .map((doc) => ProductModel.fromSnapshot(doc))
              .toList();

          if (isSearching) {
            final filteredProducts = products.where((product) {
              final queryLower = searchQuery.toLowerCase();
              return product.productName.toLowerCase().contains(queryLower) ||
                  product.category.toLowerCase().contains(queryLower) ||
                  product.brand.toLowerCase().contains(queryLower);
            }).toList();

            if (filteredProducts.isEmpty) {
              return Center(
                child: Text(
                  'No results found.',
                  style: const TextStyle(color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: ListTile(
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product.images![0],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(product.productName),
                    subtitle: Text(
                      'Brand: ${product.brand}',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetails(
                            product: product,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                'Search for products',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
