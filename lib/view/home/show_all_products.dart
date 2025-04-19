import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/respository/components/product_container.dart';
import 'package:ecommerce_app/respository/components/route_names.dart';
import 'package:ecommerce_app/utils/fav_provider.dart';
import 'package:ecommerce_app/utils/formatter.dart';
import 'package:ecommerce_app/view/home/product_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowProducts extends StatefulWidget {
  const ShowProducts({super.key});

  @override
  State<ShowProducts> createState() => _ShowProductsState();
}

class _ShowProductsState extends State<ShowProducts> {
  final db2 = FirebaseFirestore.instance.collection('Favourites');
  final id = FirebaseAuth.instance.currentUser!.uid.toString();

  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
  TextEditingController searchController = TextEditingController();

  // Biến cho bộ lọc giá và sắp xếp tên
  double minPrice = 1000000;
  double maxPrice = 10000000;
  String selectedSort = 'Tất cả';
  TextEditingController minPriceController = TextEditingController(text: '1000000');
  TextEditingController maxPriceController = TextEditingController(text: '10000000');

  Future<void> initData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference productsCollection = firestore.collection('products');

    try {
      QuerySnapshot querySnapshot = await productsCollection.get();
      products = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Khởi tạo filteredProducts với toàn bộ sản phẩm
      filteredProducts = List.from(products);
      setState(() {});
    } catch (_) {}
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  void searchProducts(String query) {
    // Lọc sản phẩm theo tên và giá
    List<Map<String, dynamic>> tempList = products.where((product) {
      double price = double.tryParse(product['productprice'].toString()) ?? 0;
      bool matchesQuery = product['productname']
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase());
      bool matchesPrice = price >= minPrice && price <= maxPrice;
      return matchesQuery && matchesPrice;
    }).toList();

    // Sắp xếp theo tên nếu cần
    if (selectedSort == 'A-Z') {
      tempList.sort((a, b) =>
          a['productname'].toString().compareTo(b['productname'].toString()));
    } else if (selectedSort == 'Z-A') {
      tempList.sort((a, b) =>
          b['productname'].toString().compareTo(a['productname'].toString()));
    } else if (selectedSort == 'Giá cao - thấp') {
      tempList.sort((a, b) {
        double priceA = double.tryParse(a['productprice'].toString()) ?? 0;
        double priceB = double.tryParse(b['productprice'].toString()) ?? 0;
        return priceB.compareTo(priceA);
      });
    } else if (selectedSort == 'Giá thấp - cao') {
      tempList.sort((a, b) {
        double priceA = double.tryParse(a['productprice'].toString()) ?? 0;
        double priceB = double.tryParse(b['productprice'].toString()) ?? 0;
        return priceA.compareTo(priceB);
      });
    }

    setState(() {
      filteredProducts = tempList;
    });
  }

  void updatePriceFromControllers() {
    double? newMinPriceNullable = double.tryParse(minPriceController.text);
    double? newMaxPriceNullable = double.tryParse(maxPriceController.text);
    
    // Use default values if parsing fails
    double newMinPrice = newMinPriceNullable ?? 1000000;
    double newMaxPrice = newMaxPriceNullable ?? 10000000;
    
    if (newMinPrice > newMaxPrice) {
      // Swap values if min > max
      double temp = newMinPrice;
      newMinPrice = newMaxPrice;
      newMaxPrice = temp;
      
      minPriceController.text = newMinPrice.toString();
      maxPriceController.text = newMaxPrice.toString();
    }
    
    setState(() {
      minPrice = newMinPrice;
      maxPrice = newMaxPrice;
    });
    searchProducts(searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final favprovider = Provider.of<FavouriteProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xfff7f7f9),
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pushNamed(context, RouteNames.navbarscreen);
          },
          child: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: const Text('Tất cả sản phẩm'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tìm kiếm sản phẩm
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.blue),
                    hintText: 'Tìm kiếm giày...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFFF5F7FA),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              searchController.clear();
                              searchProducts('');
                            },
                          )
                        : null,
                  ),
                  onChanged: searchProducts,
                ),
                const SizedBox(height: 16),

                // Tiêu đề phần lọc giá
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.filter_list, color: Colors.blue, size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Lọc theo giá:",
                      style: TextStyle(
                        fontWeight: FontWeight.w600, 
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Input fields for price range
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: minPriceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Giá thấp nhất",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          isDense: true,
                        ),
                        onSubmitted: (_) => updatePriceFromControllers(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: maxPriceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Giá cao nhất",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          isDense: true,
                        ),
                        onSubmitted: (_) => updatePriceFromControllers(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: updatePriceFromControllers,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Áp dụng",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Price range label
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Formatter.formatCurrency(minPrice.toInt()),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      Formatter.formatCurrency(maxPrice.toInt()),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // RangeSlider hiện đại hơn
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 4,
                      activeTrackColor: Colors.blue,
                      inactiveTrackColor: Colors.grey[200],
                      thumbColor: Colors.white,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 9,
                        elevation: 4,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 18,
                      ),
                      overlayColor: Colors.blue.withOpacity(0.2),
                    ),
                    child: RangeSlider(
                      values: RangeValues(minPrice, maxPrice),
                      min: 1000000,
                      max: 10000000,
                      divisions: 20,
                      onChanged: (values) {
                        setState(() {
                          minPrice = values.start;
                          maxPrice = values.end;
                          minPriceController.text = minPrice.toInt().toString();
                          maxPriceController.text = maxPrice.toInt().toString();
                        });
                        searchProducts(searchController.text);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Sắp xếp dạng chips hiện đại
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.sort, color: Colors.blue, size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Sắp xếp:",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['Tất cả', 'A-Z', 'Z-A', 'Giá cao - thấp', 'Giá thấp - cao']
                              .map((sortOption) => Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ChoiceChip(
                                      label: Text(
                                        sortOption,
                                        style: TextStyle(
                                          color: selectedSort == sortOption
                                              ? Colors.white
                                              : Colors.black87,
                                          fontWeight: selectedSort == sortOption
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                      selected: selectedSort == sortOption,
                                      selectedColor: Colors.blue,
                                      backgroundColor: const Color(0xFFF5F7FA),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      onSelected: (bool selected) {
                                        if (selected) {
                                          setState(() {
                                            selectedSort = sortOption;
                                          });
                                          searchProducts(searchController.text);
                                        }
                                      },
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 0.8,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  return ShowProductContainer(
                    subtitle: filteredProducts[index]['productname'],
                    imagelink: filteredProducts[index]['imagelink'],
                    price: Formatter.formatCurrency(
                      double.parse(filteredProducts[index]['productprice'])
                          .toInt(),
                    ),
                    quantity: 0,
                    fav: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        if (favprovider.items
                            .contains(filteredProducts[index]['productId'])) {
                          favprovider
                              .remove(filteredProducts[index]['productId']);
                          db2
                              .doc(id)
                              .collection('items')
                              .doc(filteredProducts[index]['productId'])
                              .delete();
                        } else {
                          favprovider.add(filteredProducts[index]['productId']);
                          db2
                              .doc(id)
                              .collection('items')
                              .doc(filteredProducts[index]['productId'])
                              .set({
                            'product id':
                                filteredProducts[index]['productId'].toString(),
                            'name': filteredProducts[index]['productname']
                                .toString(),
                            'subtitle':
                                filteredProducts[index]['title'].toString(),
                            'image':
                                filteredProducts[index]['imagelink'].toString(),
                            'price': filteredProducts[index]['productprice']
                                .toString(),
                            'description': filteredProducts[index]
                                    ['description']
                                .toString(),
                          });
                        }
                      },
                      icon: Icon(
                        favprovider.items
                                .contains(filteredProducts[index]['productId'])
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color: Colors.red,
                        size: 16,
                      ),
                    ),
                    onclick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => ProductDetails(
                            title: filteredProducts[index]['productname'],
                            price: filteredProducts[index]['productprice'],
                            productid: filteredProducts[index]['productId'],
                            unitprice: filteredProducts[index]['unitprice'],
                            image: filteredProducts[index]['imagelink'],
                            description: filteredProducts[index]['description'],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
