import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/respository/components/product_container.dart';
import 'package:ecommerce_app/respository/components/route_names.dart';
import 'package:ecommerce_app/utils/fav_provider.dart';
import 'package:ecommerce_app/utils/formatter.dart';
import 'package:ecommerce_app/view/home/product_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductByBrandScreen extends StatefulWidget {
  const ProductByBrandScreen({
    super.key,
    required this.brandId,
    required this.brandName,
  });

  final String brandId;
  final String brandName;

  @override
  State<ProductByBrandScreen> createState() => _ProductByBrandScreenState();
}

class _ProductByBrandScreenState extends State<ProductByBrandScreen> {
  final db2 = FirebaseFirestore.instance.collection('Favourites');
  final id = FirebaseAuth.instance.currentUser!.uid.toString();

  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
  String? brandDescription;
  String? brandSlogan;
  String? brandLogoUrl;
  bool isLoading = true;

  // Filter variables
  double minPrice = 1000000;
  double maxPrice = 10000000;
  String selectedSort = 'Tất cả';

  // Define brand logos and slogans mapping
  final Map<String, Map<String, String>> brandInfo = {
    'nike': {
      'logo': 'https://static.vecteezy.com/system/resources/previews/010/994/412/original/nike-logo-black-with-name-clothes-design-icon-abstract-football-illustration-with-white-background-free-vector.jpg',
      'slogan': 'Just Do It'
    },
    'adidas': {
      'logo': 'https://1000logos.net/wp-content/uploads/2019/06/Adidas-Logo-1991.jpg',
      'slogan': 'Impossible Is Nothing'
    },
    'puma': {
      'logo': 'https://logos-world.net/wp-content/uploads/2020/04/Puma-Logo-1970-present.jpg',
      'slogan': 'Forever Faster'
    },
    'reebok': {
      'logo': 'https://1000logos.net/wp-content/uploads/2017/05/Reebok-logo.png',
      'slogan': 'Be More Human'
    },
    'new balance': {
      'logo': 'https://1000logos.net/wp-content/uploads/2018/10/New-Balance-logo.jpg',
      'slogan': 'Fearlessly Independent'
    },
    'under armour': {
      'logo': 'https://logos-world.net/wp-content/uploads/2020/04/Under-Armour-Logo-700x394.png',
      'slogan': 'I Will'
    },
    'converse': {
      'logo': 'https://logos-world.net/wp-content/uploads/2020/04/Converse-Logo-2011-2017.png',
      'slogan': 'Shoes are boring. Wear sneakers.'
    },
    'vans': {
      'logo': 'https://logos-world.net/wp-content/uploads/2020/04/Vans-Logo.png',
      'slogan': 'Off The Wall'
    },
  };

  initData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference productsCollection = firestore.collection('products');
    try {
      // Get brand description if available
      try {
        DocumentSnapshot brandDoc = await firestore.collection('brands').doc(widget.brandId).get();
        if (brandDoc.exists) {
          var data = brandDoc.data() as Map<String, dynamic>?;
          if (data != null) {
            if (data.containsKey('description')) {
              brandDescription = data['description'];
            }
            if (data.containsKey('slogan')) {
              brandSlogan = data['slogan'];
            }
            if (data.containsKey('logoUrl')) {
              brandLogoUrl = data['logoUrl'];
            }
          }
        }
      } catch (e) {
        // Silently handle error for brand description
      }

      // Set default brand info from our mapping if not found in database
      String brandNameLower = widget.brandName.toLowerCase();
      if (brandSlogan == null && brandInfo.containsKey(brandNameLower)) {
        brandSlogan = brandInfo[brandNameLower]?['slogan'];
      }

      if (brandLogoUrl == null && brandInfo.containsKey(brandNameLower)) {
        brandLogoUrl = brandInfo[brandNameLower]?['logo'];
      }

      QuerySnapshot querySnapshot = await productsCollection
          .where('brandId', isEqualTo: widget.brandId)
          .get();
      products = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Initialize filtered products
      filteredProducts = List.from(products);

      setState(() {
        isLoading = false;
      });
    } catch (_) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  String formatBrandName(String name) {
    // Format brand name to be more presentable (all caps for well-known brands)
    List<String> premiumBrands = ['nike', 'adidas', 'puma', 'reebok', 'new balance', 'under armour'];

    if (premiumBrands.contains(name.toLowerCase())) {
      return name.toUpperCase();
    }

    // Capitalize first letter of each word for other brands
    return name.split(' ').map((word) =>
      word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : ''
    ).join(' ');
  }

  void applyFilters({String? sortOption, double? newMinPrice, double? newMaxPrice}) {
    if (sortOption != null) {
      selectedSort = sortOption;
    }

    if (newMinPrice != null) {
      minPrice = newMinPrice;
    }

    if (newMaxPrice != null) {
      maxPrice = newMaxPrice;
    }

    // Filter products by price
    List<Map<String, dynamic>> tempList = products.where((product) {
      double price = double.tryParse(product['productprice'].toString()) ?? 0;
      return price >= minPrice && price <= maxPrice;
    }).toList();

    // Sort products based on selected option
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

  void showFilterDialog() {
    double dialogMinPrice = minPrice;
    double dialogMaxPrice = maxPrice;
    String dialogSelectedSort = selectedSort;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.filter_list, color: Colors.blue),
              SizedBox(width: 10),
              Text('Bộ lọc sản phẩm'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price range section
                  Text(
                    "Lọc theo giá:",
                    style: TextStyle(
                      fontWeight: FontWeight.w600, 
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Price labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Formatter.formatCurrency(dialogMinPrice.toInt()),
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        Formatter.formatCurrency(dialogMaxPrice.toInt()),
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),

                  // Price range slider
                  SliderTheme(
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
                      values: RangeValues(dialogMinPrice, dialogMaxPrice),
                      min: 1000000,
                      max: 10000000,
                      divisions: 20,
                      onChanged: (values) {
                        setDialogState(() {
                          dialogMinPrice = values.start;
                          dialogMaxPrice = values.end;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),

                  // Sort options
                  Text(
                    "Sắp xếp:",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 12),

                  // Sort radio buttons
                  Wrap(
                    spacing: 8,
                    children: ['Tất cả', 'A-Z', 'Z-A', 'Giá cao - thấp', 'Giá thấp - cao']
                        .map((sortOption) => ChoiceChip(
                              label: Text(
                                sortOption,
                                style: TextStyle(
                                  color: dialogSelectedSort == sortOption
                                      ? Colors.white
                                      : Colors.black87,
                                  fontSize: 13,
                                ),
                              ),
                              selected: dialogSelectedSort == sortOption,
                              selectedColor: Colors.blue,
                              backgroundColor: const Color(0xFFF5F7FA),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              onSelected: (bool selected) {
                                if (selected) {
                                  setDialogState(() {
                                    dialogSelectedSort = sortOption;
                                  });
                                }
                              },
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('HỦY'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                applyFilters(
                  sortOption: dialogSelectedSort,
                  newMinPrice: dialogMinPrice,
                  newMaxPrice: dialogMaxPrice,
                );
              },
              child: Text('ÁP DỤNG'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favprovider = Provider.of<FavouriteProvider>(context);
    return Scaffold(
      backgroundColor: Color(0xfff7f7f9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pushNamed(context, RouteNames.navbarscreen);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Brand logo
            if (brandLogoUrl != null)
              Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(brandLogoUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            // Brand name and slogan
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatBrandName(widget.brandName),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                      letterSpacing: 0.5,
                    ),
                  ),
                  if (brandSlogan != null)
                    Text(
                      '"$brandSlogan"',
                      style: TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.black87),
            onPressed: showFilterDialog,
            tooltip: 'Bộ lọc',
          ),
        ],
      ),
      body: isLoading 
          ? Center(child: CircularProgressIndicator())
          : filteredProducts.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/empty_products.png', // Add this image to your assets
                      width: 120,
                      height: 120,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey.shade400);
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Sắp ra mắt!',
                      style: TextStyle(
                        fontSize: 22, 
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'Chúng tôi đang cập nhật bộ sưu tập mới từ ${formatBrandName(widget.brandName)}. Hãy quay lại sau nhé!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, RouteNames.navbarscreen);
                      },
                      icon: Icon(Icons.shopping_bag),
                      label: Text('Khám phá các sản phẩm khác'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    )
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand description when available
                  if (brandDescription != null)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        brandDescription!,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 13,
                        ),
                      ),
                    ),

                  // Active filters chips
                  if (selectedSort != 'Tất cả' || minPrice > 1000000 || maxPrice < 10000000)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Wrap(
                        spacing: 8,
                        children: [
                          if (selectedSort != 'Tất cả')
                            Chip(
                              label: Text(selectedSort, style: TextStyle(fontSize: 12)),
                              backgroundColor: Colors.blue.withOpacity(0.1),
                              deleteIconColor: Colors.blue,
                              onDeleted: () {
                                applyFilters(sortOption: 'Tất cả');
                              },
                            ),
                          if (minPrice > 1000000 || maxPrice < 10000000)
                            Chip(
                              label: Text(
                                'Giá: ${Formatter.formatCurrency(minPrice.toInt())} - ${Formatter.formatCurrency(maxPrice.toInt())}',
                                style: TextStyle(fontSize: 12),
                              ),
                              backgroundColor: Colors.blue.withOpacity(0.1),
                              deleteIconColor: Colors.blue,
                              onDeleted: () {
                                applyFilters(newMinPrice: 1000000, newMaxPrice: 10000000);
                              },
                            ),
                        ],
                      ),
                    ),

                  // Enhanced Products count
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade600, Colors.blue.shade400],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            filteredProducts.length.toString(),
                            style: TextStyle(
                              color: Colors.blue.shade600,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "sản phẩm ${formatBrandName(widget.brandName)} có sẵn",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Product grid
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
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
                                double.parse(filteredProducts[index]['productprice']).toInt()),
                            quantity: 0,
                            title: formatBrandName(widget.brandName), // This correctly passes the brand name
                            fav: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () async {
                                  if (favprovider.items
                                      .contains(filteredProducts[index]['productId'])) {
                                    favprovider.remove(filteredProducts[index]['productId']);

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
                                      'product id': filteredProducts[index]['productId'].toString(),
                                      'name': filteredProducts[index]['productname'].toString(),
                                      'subtitle': filteredProducts[index]['title'].toString(),
                                      'image': filteredProducts[index]['imagelink'].toString(),
                                      'price': filteredProducts[index]['productprice'].toString(),
                                      'description':
                                          filteredProducts[index]['description'].toString(),
                                    });
                                  }
                                },
                                icon: Icon(
                                  favprovider.items.contains(filteredProducts[index]['productId'])
                                      ? Icons.favorite
                                      : Icons.favorite_border_outlined,
                                  color: Colors.red,
                                  size: 16,
                                )),
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
                                    // brandId: widget.brandId, // Pass the brandId
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
