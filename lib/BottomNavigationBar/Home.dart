import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pmartui/product/ProductDetailsScreen.dart';
import 'package:pmartui/color.dart'; // Import custom colors
import 'package:pmartui/subcategory/subcategory.dart';
import '../model/Category model.dart';
import '../model/ProductModel.dart';
import '../product/search .dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> _fetchImages() async {
    final QuerySnapshot querySnapshot =
        await _firestore.collection('Banner').get();
    return querySnapshot.docs.map((doc) => doc['image'] as String).toList();
  }

  Future<bool> _onBackPressed() async {
    bool shouldExit =
        await ExitConfirmationDialog.showExitDialog(context) ?? false;
    return shouldExit;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          // Use custom color
          title: const Text(
            'Peak Mart',
            style: TextStyle(
                color: CupertinoColors.black, fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                );
              },
              icon: Padding(
                padding: const EdgeInsets.only(right: 14),
                child: const Icon(
                  Icons.search,
                  size: 30,
                  color: CupertinoColors.black,
                ),
              ),
            ),
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.cyan.shade500, Colors.cyan.shade200],
              stops: [0.0, 0.7], // Adjust stops as needed
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BannerSlider(),
                  SizedBox(
                    height: 20,
                  ),
                  CategoryList(),
                  const SizedBox(height: 20),
                  ProductHome(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// Rest of the code remains the same...

// class CategoryList extends StatelessWidget {
//   const CategoryList({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('Categories').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(
//               color: valo,
//             ),
//           );
//         }
//
//         if (!snapshot.hasData || snapshot.data == null) {
//           return const Center(
//             child: Text('No data available'),
//           );
//         }
//
//         final categoryDocs = snapshot.data!.docs;
//
//         return SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: categoryDocs.map((doc) {
//               final category = CategoryModel.fromSnapshot(doc);
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) =>
//                             BrandScreen(selectedcategory: category)),
//                   );
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: Column(
//                     children: [
//                       CircleAvatar(
//                         radius: 30,
//                         backgroundColor: Colors.white,
//                         backgroundImage: NetworkImage(category.image),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         category.category,
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         );
//       },
//     );
//   }
// }
class CategoryList extends StatelessWidget {
  const CategoryList({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Categories').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Text('No data available'),
          );
        }

        final categoryDocs = snapshot.data!.docs;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categoryDocs.map((doc) {
              final category = CategoryModel.fromSnapshot(doc);
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BrandScreen(
                              selectedCategory: category,
                            )),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(category.image),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 70, // Set a fixed width for better alignment
                        child: Text(
                          category.category,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          // maxLines: 1, // Allow up to 2 lines of text
                          // overflow: TextOverflow.ellipsis, // Truncate with ellipsis if text overflows
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class ProductHome extends StatefulWidget {
  const ProductHome({super.key});

  @override
  State<ProductHome> createState() => _ProductHomeState();
}

class _ProductHomeState extends State<ProductHome> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: valo,
          ));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No data available'));
        }

        final productDocs = snapshot.data!.docs;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              // crossAxisSpacing: 1,
              mainAxisSpacing: 7,
              childAspectRatio: 0.7),
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
class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0), // Consistent padding
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProductDetails(product: product),
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with fixed size and padding
                Container(
                  height: 170, // Fixed height for image
                  child: Image.network(
                    product.images != null && product.images!.isNotEmpty
                        ? product.images![0]
                        : 'https://via.placeholder.com/150', // Fallback image
                    fit: BoxFit.cover,
                    width: double.infinity, // Full width
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(12), // Padding around text
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name with overflow handling
                      Text(
                        product.productName ?? 'Product Name', // Fallback name
                        maxLines: 2, // Limits to 2 lines to avoid overflow
                        overflow: TextOverflow.ellipsis, // If text is too long
                        style: theme.textTheme.subtitle1?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8), // Spacing between elements

                      // Row for prices with proper spacing
                      Row(
                        children: [
                          // Original price with strikethrough
                          Text(
                            '₹${product.productPrice}',
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),

                          const Spacer(), // Ensures space between prices

                          // Discounted price with emphasis
                          Text(
                            '₹${product.newPrice}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green, // Highlighting new price
                            ),
                          ),
                        ],
                      ),
                    ],
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


class ExitConfirmationDialog {
  static Future<bool?> showExitDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Exit Peak Mart?',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
        ),
        content: const Text(
          'Are you sure you want to exit?',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pop(false); // Return false to indicate user canceled exit
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pop(true); // Return true to indicate user confirmed exit
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}

class BannerSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Banner').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 200,
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final List<QueryDocumentSnapshot> bannerDocs = snapshot.data!.docs;

        return CarouselSlider.builder(
          itemCount: bannerDocs.length,
          itemBuilder: (context, index, realIndex) {
            final bannerData = bannerDocs[index].data() as Map<String, dynamic>;
            final bannerImage = bannerData['image'] ?? '';

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: bannerImage,
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: Icon(Icons.error),
                  ),
                ),
              ),
            );
          },
          options: CarouselOptions(
            aspectRatio: 19 / 9,
            viewportFraction: 2,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            onPageChanged: (index, reason) {},
          ),
        );
      },
    );
  }
}
