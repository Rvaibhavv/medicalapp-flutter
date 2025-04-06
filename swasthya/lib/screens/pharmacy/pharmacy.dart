import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../config.dart';
import '../../user_provider.dart';
import 'package:swasthya/screens/mycolors.dart';
import 'cart.dart';

class PharmacyPage extends StatefulWidget {
  const PharmacyPage({super.key});

  @override
  State<PharmacyPage> createState() => _PharmacyPageState();
}

class _PharmacyPageState extends State<PharmacyPage> {
  List<dynamic> _allMedicines = [];
  List<dynamic> _filteredMedicines = [];
  final TextEditingController _searchController = TextEditingController();
  final Map<int, int> _quantities = {}; // medicineId -> quantity

  @override
  void initState() {
    super.initState();
    fetchMedicines();
  }

  Future<void> fetchMedicines() async {
    final response =
        await http.get(Uri.parse('${AppConfig.baseUrl}/pharmacy/medicines/'));

    if (response.statusCode == 200) {
      List<dynamic> medicines = jsonDecode(response.body);
      setState(() {
        _allMedicines = medicines;
        _filteredMedicines = medicines;
        for (var med in medicines) {
          _quantities[med["id"]] = 1; // default quantity = 1
        }
      });
    } else {
      throw Exception('Failed to load medicines');
    }
  }

  void _searchMedicine(String query) {
    List<dynamic> filteredList = _allMedicines
        .where((medicine) =>
            medicine["name"].toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      _filteredMedicines = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.maincolor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: 100,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: _filteredMedicines.isEmpty
                          ? const Center(child: Text("No medicines found"))
                          : GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.75,
                              ),
                              itemCount: _filteredMedicines.length,
                              itemBuilder: (context, index) {
                                return buildMedicineCard(
                                    context, _filteredMedicines[index]);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: MyColors.maincolor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 23,
                  child: Icon(
                    Icons.notifications_active_outlined,
                    color: MyColors.deepTealGreen,
                    size: 25,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  );
                },
                icon: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 23,
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    color: MyColors.deepTealGreen,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 55,
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _searchMedicine(value),
              decoration: InputDecoration(
                hintText: "Search for medicines",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.grey),
              cursorColor: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMedicineCard(
      BuildContext context, Map<String, dynamic> medicine) {
    final int userId = Provider.of<UserProvider>(context, listen: false).userId;
    final int medicineId = medicine["id"];
    int quantity = _quantities[medicineId] ?? 1;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Medicine Image
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.asset(
                    "assets/images/med.webp",
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 2,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Text(
                      "ID: ${medicine["id"]}",
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const Positioned(
                  top: 10,
                  right: 10,
                  child: Icon(
                    Icons.favorite_border,
                    color: Colors.red,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),

          // Medicine Info
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  medicine["name"],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                Text(
                  "₹${medicine["price"]}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: MyColors.deepTealGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),

                // Quantity selector
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (quantity > 1) {
                          setState(() {
                            _quantities[medicineId] = quantity - 1;
                          });
                        }
                      },
                    ),
                    Text(
                      '$quantity',
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _quantities[medicineId] = quantity + 1;
                        });
                      },
                    ),
                    const Spacer(),

                    // Add to cart button
                    MaterialButton(
                      padding: EdgeInsets.zero,
                      minWidth: 0,
                      onPressed: () async {
                        final response = await http.post(
                          Uri.parse('${AppConfig.baseUrl}/pharmacy/add-to-cart/'),
                          headers: {"Content-Type": "application/json"},
                          body: jsonEncode({
                            "user_id": userId,
                            "medicine": medicineId,
                            "quantity": quantity,
                          }),
                        );

                        if (response.statusCode == 201 || response.statusCode == 200) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Added to cart"),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Failed: ${response.statusCode}"),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 16,
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          color: MyColors.deepTealGreen,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
