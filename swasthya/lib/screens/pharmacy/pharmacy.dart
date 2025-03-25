import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';
import 'package:swasthya/screens/mycolors.dart';

class PharmacyPage extends StatefulWidget {
  const PharmacyPage({super.key});

  @override
  State<PharmacyPage> createState() => _PharmacyPageState();
}

class _PharmacyPageState extends State<PharmacyPage> {
  List<dynamic> _allMedicines = [];
  List<dynamic> _filteredMedicines = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMedicines();
  }

  Future<void> fetchMedicines() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}/pharmacy/medicines/'));

    if (response.statusCode == 200) {
      List<dynamic> medicines = jsonDecode(response.body);
      setState(() {
        _allMedicines = medicines;
        _filteredMedicines = medicines; // Initially display all medicines
      });
    } else {
      throw Exception('Failed to load medicines');
    }
  }

  void _searchMedicine(String query) {
    List<dynamic> filteredList = _allMedicines
        .where((medicine) => medicine["name"].toLowerCase().contains(query.toLowerCase()))
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
            // Header Section with Search Bar
            _buildHeader(),

            // Medicine Cards Section
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

                    // Rounded Grey Line
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
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.75,
                              ),
                              itemCount: _filteredMedicines.length,
                              itemBuilder: (context, index) {
                                return buildMedicineCard(_filteredMedicines[index]);
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

  // Header Section (Search Bar & Icons)
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
                onPressed: () {},
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

          // Search Bar
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

  // Medicine Card Widget
  Widget buildMedicineCard(Map<String, dynamic> medicine) {
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
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.asset(
                    "assets/images/med.webp",
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                // ID Badge (Top Left)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                // Favorite Icon (Top Right)
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

          // Medicine Info (Name & Price)
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name & Cart Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        medicine["name"],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    MaterialButton(
                      padding: EdgeInsets.zero,
                      minWidth: 0,
                      onPressed: () {
                        print("Added ${medicine["name"]} to cart!");
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
                const SizedBox(height: 4),

                // Medicine Price
                Text(
                  "₹${medicine["price"]}",
                  style: TextStyle(
                    fontSize: 14,
                    color: MyColors.deepTealGreen,
                    fontWeight: FontWeight.bold,
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
