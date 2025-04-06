import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../config.dart';
import '../../user_provider.dart';
import '../mycolors.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<dynamic> _cartItems = [];
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> fetchCartItems() async {
    final int userId = Provider.of<UserProvider>(context, listen: false).userId;
    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/pharmacy/cart/?user_id=$userId'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _cartItems = jsonDecode(response.body);
      });
    } else {
      print('Failed to load cart items: ${response.statusCode}');
    }
  }

  Future<void> removeCartItem(int cartItemId) async {
    final response = await http.delete(
      Uri.parse('${AppConfig.baseUrl}/pharmacy/cart/$cartItemId/'),
    );

    if (response.statusCode == 204) {
      fetchCartItems();
    } else {
      print('Failed to remove item: ${response.statusCode}');
    }
  }

  double getTotalPrice() {
    double total = 0.0;
    for (var item in _cartItems) {
      double price = double.tryParse(item['medicine_price'].toString()) ?? 0.0;
      int quantity = item['quantity'] ?? 1;
      total += price * quantity;
    }
    return total;
  }

  void _startPayment() {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    double totalPrice = getTotalPrice();

    var options = {
      'key': AppConfig.razorpayKey,
      'amount': (totalPrice * 100).toInt(),
      'currency': 'INR',
      'name': 'Your App Name',
      'description': 'Medicine Purchase',
      'prefill': {'contact': '1234567890', 'email': 'user@example.com'},
      'external': {'wallets': ['paytm']},
      'notes': {'userId': userId},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("Payment Success: ${response.paymentId}");

    final int userId = Provider.of<UserProvider>(context, listen: false).userId;

    // Call backend to clear user's cart
    final res = await http.delete(
      Uri.parse('${AppConfig.baseUrl}/pharmacy/clear-cart/?user_id=$userId'),
    );

    if (res.statusCode == 204 || res.statusCode == 200) {
      setState(() {
        _cartItems.clear(); // Clear UI cart
      });

      
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment done, but failed to clear cart.")),
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Error: ${response.message}");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment Failed")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = getTotalPrice();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Checkout",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: MyColors.maincolor,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: _cartItems.isEmpty
                ? const Center(child: Text("Cart is empty"))
                : ListView.builder(
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return ListTile(
                        title: Text(item['medicine_name']),
                        subtitle: Text("₹${item['medicine_price']} x ${item['quantity']}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => removeCartItem(item['id']),
                        ),
                      );
                    },
                  ),
          ),
          if (_cartItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "₹${totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _startPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.deepTealGreen,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      "Pay Now",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
