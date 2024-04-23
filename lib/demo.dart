// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:pmartui/ProductDetailsScreen.dart';
// import 'package:pmartui/color.dart';
// import 'package:pmartui/subcategory/subcategory.dart';
//
// import '../ProductModel.dart';
// import '../model/Category model.dart';
// import 'BottomNavigationBar/cart.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<List<String>> _fetchImages() async {
//     final QuerySnapshot querySnapshot =
//         await _firestore.collection('Banner').get();
//     return querySnapshot.docs.map((doc) => doc['image'] as String).toList();
//   }
//
//   Future<bool> _onBackPressed() async {
//     bool shouldExit =
//         await ExitConfirmationDialog.showExitDialog(context) ?? false;
//     return shouldExit;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onBackPressed,
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: valo,
//           title: const Text(
//             'PEAK MART',
//             style: TextStyle(fontSize: 25, color: CupertinoColors.white),
//           ),
//           automaticallyImplyLeading: false,
//           centerTitle: true,
//           actions: <Widget>[
//             IconButton(
//               onPressed: () {
//                 //   Navigator.push(
//                 //       context,
//                 //       MaterialPageRoute(
//                 //           builder: (context) => const SearchScreen()));
//               },
//               icon: const Icon(Icons.search),
//             ),
//           ],
//         ),
//         body: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 BannerSlider(),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 const CategoryList(),
//                 const SizedBox(height: 20),
//                 const ProductHome(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
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
//                       builder: (context) => BrandScreen(selectedcategory: category)
//                     ),
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
//
// class ProductHome extends StatefulWidget {
//   const ProductHome({super.key});
//
//   @override
//   State<ProductHome> createState() => _ProductHomeState();
// }
//
// class _ProductHomeState extends State<ProductHome> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('Products').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//               child: CircularProgressIndicator(
//             color: valo,
//           ));
//         }
//
//         if (!snapshot.hasData || snapshot.data == null) {
//           return const Center(child: Text('No data available'));
//         }
//
//         final productDocs = snapshot.data!.docs;
//
//         return GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 2,
//               mainAxisSpacing: 2,
//               childAspectRatio: 0.7),
//           itemCount: productDocs.length,
//           itemBuilder: (context, index) {
//             final product = ProductModel.fromSnapshot(productDocs[index]);
//             return ProductCard(product: product);
//           },
//         );
//       },
//     );
//   }
// }
//
// class ProductCard extends StatelessWidget {
//   final ProductModel product;
//
//   const ProductCard({
//     Key? key,
//     required this.product,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final cardWidth = screenWidth * 0.4;
//
//     return SizedBox(
//       width: cardWidth,
//       child: GestureDetector(
//         onTap: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//                 builder: (context) => ProductDetailScreen(product: product)),
//           );
//         },
//         child: Card(
//           elevation: 4,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(12),
//                     topRight: Radius.circular(12),
//                   ),
//                   child: Image.network(
//                     product.images![0],
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       product.productName,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           '₹ ${product.newPrice}',
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.green,
//                           ),
//                         ),
//                         Text(
//                           '₹ ${product.productPrice}',
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.red,
//                             fontWeight: FontWeight.bold,
//                             decoration: TextDecoration.lineThrough,
//                             decorationColor: Colors.red,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class ExitConfirmationDialog {
//   static Future<bool?> showExitDialog(BuildContext context) async {
//     return showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text(
//           'Exit Peak Mart?',
//           style: TextStyle(
//               fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
//         ),
//         content: const Text(
//           'Are you sure you want to exit?',
//           style: TextStyle(
//               fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context)
//                   .pop(false); // Return false to indicate user canceled exit
//             },
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context)
//                   .pop(true); // Return true to indicate user confirmed exit
//             },
//             child: const Text('Exit'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class BannerSlider extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('Banner').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Container(
//             height: 200,
//             color: Colors.white,
//             child: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         }
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }
//
//         final List<QueryDocumentSnapshot> bannerDocs = snapshot.data!.docs;
//
//         return CarouselSlider.builder(
//           itemCount: bannerDocs.length,
//           itemBuilder: (context, index, realIndex) {
//             final bannerData = bannerDocs[index].data() as Map<String, dynamic>;
//             final bannerImage = bannerData['image'] ?? '';
//
//             return Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(8.0),
//                 child: Image.network(
//                   bannerImage,
//                   width: MediaQuery.of(context).size.width,
//                   height: 200,
//                   fit: BoxFit.cover,
//                   loadingBuilder: (context, child, loadingProgress) {
//                     if (loadingProgress == null) return child;
//                     return Container(
//                       color: Colors.grey[200],
//                       width: MediaQuery.of(context).size.width,
//                       height: 200,
//                       child: Center(
//                         child: CircularProgressIndicator(),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             );
//           },
//           options: CarouselOptions(
//             aspectRatio: 19 / 9,
//             viewportFraction: 2,
//             autoPlay: true,
//             autoPlayInterval: Duration(seconds: 3),
//             autoPlayCurve: Curves.fastOutSlowIn,
//             enableInfiniteScroll: true,
//             onPageChanged: (index, reason) {},
//           ),
//         );
//       },
//     );
//   }
// }
