import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    super.initState();
    fetchCartItems();
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

  @override
  Widget build(BuildContext context) {
    double totalPrice = getTotalPrice();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        backgroundColor: MyColors.maincolor,
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
                    onPressed: () {
                      // checkout logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.deepTealGreen,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      "Proceed to Checkout",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
