import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/view/home/product_by_brand_screen.dart';
import 'package:flutter/material.dart';

class BrandList extends StatefulWidget {
  const BrandList({super.key});

  @override
  State<BrandList> createState() => _BrandListState();
}

class _BrandListState extends State<BrandList> {
  List<Map<String, dynamic>> brands = [];
  String selectedBrand = ''; // Thêm dòng này

  @override
  void initState() {
    super.initState();
    fetchBrands();
  }

  Future<void> fetchBrands() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference brandsCollection = firestore.collection('brands');

      QuerySnapshot snapshot = await brandsCollection.get();
      List<Map<String, dynamic>> loadedBrands = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'] ?? '',
          'image': doc['image'] ?? '',
        };
      }).toList();

      setState(() {
        brands = loadedBrands;
        selectedBrand = 'Puma'; // Mặc định chọn Nike
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return brands.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              
              children: brands.map((brand) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedBrand = brand['name'];
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductByBrandScreen(
                          brandId: brand['id'],
                          brandName: brand['name'],
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Container(
                      height: 48,
                      width: 120,
                      decoration: BoxDecoration(
                        color: selectedBrand == brand['name'] 
                            ? Colors.blue 
                            : Colors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              brand['name'],
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: selectedBrand == brand['name'] 
                                    ? Colors.white 
                                    : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: brand['image'].isNotEmpty
                                  ? NetworkImage(brand['image'])
                                  : null,
                              child: brand['image'].isEmpty
                                  ? const Icon(Icons.image, color: Colors.grey)
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
  }
}
