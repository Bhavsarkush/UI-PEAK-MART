import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/Category model.dart';
import '../model/ProductModel.dart';
import '../model/subcategory.dart';
import '../product/ProductDetailsScreen.dart';

class BrandScreen extends StatefulWidget {
  final CategoryModel selectedCategory;

  const BrandScreen({Key? key, required this.selectedCategory})
      : super(key: key);

  @override
  _BrandScreenState createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {
  late Future<List<SubCategoryModel>> subcategoriesFuture;
  SubCategoryModel? selectedSubCategory;

  @override
  void initState() {
    super.initState();
    subcategoriesFuture = _fetchSubcategories();
  }

  Future<List<SubCategoryModel>> _fetchSubcategories() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('SubCategories')
        .where('category', isEqualTo: widget.selectedCategory.category)
        .get();
    return querySnapshot.docs
        .map((doc) => SubCategoryModel.fromSnapshot(doc))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedSubCategory?.subcategory ?? widget.selectedCategory.category,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: FutureBuilder<List<SubCategoryModel>>(
        future: subcategoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading subcategories"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No subcategories found"));
          }

          final subcategories = snapshot.data!;
          selectedSubCategory ??= subcategories.first;

          return Row(
            children: [
              // Vertical list of subcategories
              VerticalSubCategoryList(
                subcategories: subcategories,
                selectedSubCategory: selectedSubCategory!,
                onSubcategoryTap: (subcategory) {
                  setState(() => selectedSubCategory = subcategory);
                },
              ),
              // Product grid
              Expanded(
                child: ProductGrid(selectedSubCategory: selectedSubCategory!),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Vertical scrolling list of subcategories
class VerticalSubCategoryList extends StatelessWidget {
  final List<SubCategoryModel> subcategories;
  final SubCategoryModel selectedSubCategory;
  final Function(SubCategoryModel) onSubcategoryTap;

  const VerticalSubCategoryList({
    Key? key,
    required this.subcategories,
    required this.selectedSubCategory,
    required this.onSubcategoryTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120, // Fixed width to prevent overflow
      color: Colors.grey[200],
      child: ListView.builder(
        itemCount: subcategories.length,
        itemBuilder: (context, index) {
          final subcategory = subcategories[index];
          final isSelected = subcategory == selectedSubCategory;

          return GestureDetector(
            onTap: () => onSubcategoryTap(subcategory),
            child: Container(
              color: isSelected ? Colors.cyan[100] : Colors.transparent,
              padding: const EdgeInsets.all(8), // Reasonable padding
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(subcategory.image),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      subcategory.subcategory,
                      overflow: TextOverflow.ellipsis, // Prevent overflow
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.black : Colors.black,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Grid of products for a specific subcategory
class ProductGrid extends StatelessWidget {
  final SubCategoryModel selectedSubCategory;

  const ProductGrid({
    Key? key,
    required this.selectedSubCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsQuery = FirebaseFirestore.instance
        .collection('Products')
        .where('category', isEqualTo: selectedSubCategory.category)
        .where('subCategory', isEqualTo: selectedSubCategory.subcategory);

    return StreamBuilder<QuerySnapshot>(
      stream: productsQuery.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Error loading products"));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No products found"));
        }

        final productDocs = snapshot.data!.docs;

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, // Ensures grid has enough space
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: productDocs.length,
          itemBuilder: (context, index) {
            final product = ProductModel.fromSnapshot(productDocs[index]);
            return ProductCard(product: product);
          },
        );
      },
    );
  }
}

// Card to display individual products
class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetails(product: product),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 15,right: 15),
        child: Card(
          color: Colors.white70,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Rounded corners
          ),
          elevation: 4, // Adds subtle shadow for depth
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16)), // Matches card shape
                child: Image.network(
                  product.images != null && product.images!.isNotEmpty
                      ? product.images![0] // First image
                      : 'https://via.placeholder.com/150', // Fallback image
                  width: double.infinity, // Full card width
                  height: 180, // Fixed height for image
                  fit: BoxFit.cover, // Ensures the image fills the space
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 100,
                      color: Colors.grey, // Indicates a loading or broken image
                    ),
                  ),
                ),
              ),

              // Product Details
              Padding(
                padding:
                    const EdgeInsets.all(12), // Consistent padding around text
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          product.productName ??
                              'Product Name', // Product name with fallback
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15, // Larger font size
                            overflow: TextOverflow.ellipsis, // Prevents text overflow
                          ),
                        ),
                      ),

                      const SizedBox(height: 8), // Spacing between name and prices

                      // Pricing Information
                      Row(
                        // Proper spacing
                        children: [
                          // Original Price with strikethrough (if it exists)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              '₹${product.productPrice}', // Original price
                              style: const TextStyle(
                                color: Colors.black,
                                decoration:
                                    TextDecoration.lineThrough, // Strikethrough
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 90,
                          ),
                          // Discounted/New Price (if it exists)
                          Text(
                            '₹${product.newPrice}', // New price
                            style: const TextStyle(
                              color: Colors.green, // Emphasizes savings
                              fontWeight: FontWeight.bold, // Bold for emphasis
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
