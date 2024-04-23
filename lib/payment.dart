import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:pmartui/Account/order.dart';
import 'BottomNavigationBar/bottomnav.dart';

class PaymentScreen extends StatefulWidget {
  final String selectedAddress;

  const PaymentScreen({Key? key, required this.selectedAddress})
      : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _paymentMethod = 'Cash on Delivery';
  double _subtotal = 0.0;
  late Razorpay _razorpay;
  bool _razorpayOrderPlaced = false;

  @override
  void initState() {
    super.initState();
    _calculateSubtotal();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _calculateSubtotal() async {
    final currentUserUID = FirebaseAuth.instance.currentUser!.uid;
    final cartSnapshot = await FirebaseFirestore.instance
        .collection('ShoppingCart')
        .where('UID', isEqualTo: currentUserUID)
        .get();

    double subtotal = 0.0;
    for (final doc in cartSnapshot.docs) {
      try {
        subtotal += double.parse(doc['totalprice']);
      } catch (e) {
        print('Error parsing total price: $e');
      }
    }

    setState(() {
      _subtotal = subtotal;
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (_paymentMethod == 'Online Payment') {
      _placeOrder('Online Payment');
    }
    _razorpayOrderPlaced = true;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ConfirmationScreen()),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Error: ${response.message} - ${response.code}");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment failed. Please try again.')),
    );
  }

  void _openRazorpay() {
    final options = {
      'key': 'rzp_test_nLQYAWuOKvzENb',
      'amount': (_subtotal * 100).toInt(),
      'name': 'Peak Mart',
      'description': 'Product Purchase',
      'prefill': {
        'contact': '6355919771',
        'email': 'CUSTOMER_EMAIL',
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error in opening Razorpay: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open payment gateway.')),
      );
    }
  }

  Future<void> _placeOrder(String paymentMethod) async {
    try {
      final currentUserUID = FirebaseAuth.instance.currentUser!.uid;
      final cartSnapshot = await FirebaseFirestore.instance
          .collection('ShoppingCart')
          .where('UID', isEqualTo: currentUserUID)
          .get();

      final items = cartSnapshot.docs.map((doc) {
        return {
          'Price': doc['productNewPrice'],
          'Product': doc['productName'],
          'SelectedQuantity': doc['quantity'],
        };
      }).toList();

      final order = {
        'Address': widget.selectedAddress,
        'Amount': _subtotal.toStringAsFixed(2),
        'PaymentMethod': paymentMethod,
        'Items': items,
        'UID': currentUserUID,
        'Timestamp': Timestamp.now(),
        'Status': 'Pending',
      };

      final orderRef =
          await FirebaseFirestore.instance.collection('Orders').add(order);

      cartSnapshot.docs.forEach((doc) => doc.reference.delete());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your order has been placed.')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ConfirmationScreen()),
      );
    } catch (error) {
      print('Error placing order: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error placing order. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Payment Method',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            ListTile(
              title: Text('Cash on Delivery'),
              leading: Radio(
                value: 'Cash on Delivery',
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value.toString();
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Online Payment'),
              leading: Radio(
                value: 'Online Payment',
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value.toString();
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Subtotal: ₹$_subtotal',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () async {
                if (_paymentMethod == 'Online Payment') {
                  _openRazorpay();
                } else {
                  await _placeOrder('Cash on Delivery');
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Place Order',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.shopping_basket, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        centerTitle: true,
        title: const Text('Order Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'Your order has been successfully placed!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor:
                    Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderListScreen(),
                    ),
                    (route) => false);
              },
              child: Text(
                'View Orders',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor:
                    Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BottomNavigationHome(selectedIndex: 0),
                    ),
                    (route) => false);
              },
              child: Text(
                'Continue Shopping',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
