import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Address.dart';
import '../model/ProductModel.dart';

class CheckOutScreen extends StatefulWidget {
  final List<ProductModel> cartItems;

  const CheckOutScreen({Key? key, required this.cartItems}) : super(key: key);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  double totalPrice = 0;
  double totalDiscount = 0;
  double deliveryCharges = 50;
  double subtotal = 0;

  String _formatCurrency(double amount) {
    final NumberFormat _indianCurrencyFormat =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return _indianCurrencyFormat.format(amount);
  }

  @override
  void initState() {
    super.initState();
    _calculatePriceDetails();
  }

  void _calculatePriceDetails() {
    totalPrice = 0;
    totalDiscount = 0;
    widget.cartItems.forEach((product) {
      double productPrice =
          double.parse(product.productPrice.replaceAll(',', ''));
      double newPrice = double.parse(product.newPrice.replaceAll(',', ''));
      int quantity = int.parse(product.selectedqty);
      totalPrice += productPrice * quantity;
      totalDiscount += (productPrice - newPrice) * quantity;
    });
    subtotal = totalPrice - totalDiscount + deliveryCharges;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  final product = widget.cartItems[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                product.images!.first,
                                width: 80,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.productName,
                                    style: textTheme.subtitle1?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Original: ${_formatCurrency(double.parse(product.productPrice))}',
                                    style: textTheme.bodyText2?.copyWith(
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  Text(
                                    'Discounted: ${_formatCurrency(double.parse(product.newPrice))}',
                                    style: textTheme.bodyText2,
                                  ),
                                  Text(
                                    'Qty: ${product.selectedqty}',
                                    style: textTheme.bodyText2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: Colors.grey),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Total: ${_formatCurrency(double.parse(product.totalprice))}',
                            style: textTheme.subtitle1?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Price Details',
                    style: textTheme.subtitle1?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildPriceDetailRow('Product Price:', totalPrice),
                  _buildPriceDetailRow('Total Discount:', totalDiscount),
                  _buildPriceDetailRow('Delivery Charges:', deliveryCharges),
                  const Divider(color: Colors.grey),
                  _buildPriceDetailRow('Subtotal:', subtotal, isBold: true),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Address()),
                );
              },
              child: Row(
                mainAxisSize:
                    MainAxisSize.min, // This helps ensure proper alignment
                children: [
                  Text(
                    'Place Order',
                    style: textTheme.subtitle1?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  const SizedBox(width: 8), // Small gap between text and icon
                  const Icon(
                    Icons.shopping_cart_outlined, // Change the icon as desired
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceDetailRow(String label, double amount,
      {bool isBold = false}) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Text(
          label,
          style: textTheme.bodyText2?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          _formatCurrency(amount),
          style: textTheme.bodyText2?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
