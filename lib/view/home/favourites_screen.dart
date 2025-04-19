import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/respository/app_bar.dart';
import 'package:ecommerce_app/respository/components/product_container.dart';
import 'package:ecommerce_app/respository/components/route_names.dart';
import 'package:ecommerce_app/utils/formatter.dart';
import 'package:ecommerce_app/view/home/product_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final id = FirebaseAuth.instance.currentUser!.uid.toString();
  final firebase = FirebaseFirestore.instance.collection("Favourites").doc(
        FirebaseAuth.instance.currentUser!.uid.toString(),
      );

  PersistentShoppingCart cart = PersistentShoppingCart();
  final db2 = FirebaseFirestore.instance.collection('Favourites');
  
  // Method to remove item from favorites
  Future<void> removeFromFavorites(String productId) async {
    try {
      await firebase.collection('items').doc(productId).delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã gỡ khỏi danh sách yêu thích', 
              style: TextStyle(color: Colors.black87),
            ),
            backgroundColor: Colors.white,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // Show confirmation dialog
  void _showRemoveConfirmation(String productId, String productName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận'),
        content: Text('Bạn có muốn xóa "$productName" khỏi danh sách yêu thích?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              removeFromFavorites(productId);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F9),
      appBar: AppBarComp(
        apptitle: 'Danh sách yêu thích',
        appleading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, RouteNames.navbarscreen);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: firebase.collection('items').snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.blue,
            ));
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Đã xảy ra lỗi"),
            );
          } else if (snapshot.data == null || snapshot.data!.size == 0) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    "Danh sách yêu thích trống",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Bạn chưa thêm sản phẩm nào vào danh sách yêu thích",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: GridView.count(
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              children: List.generate(snapshot.data!.size, (index) {
                final item = snapshot.data!.docs[index];
                final productId = item.id;
                final productName = item['name']?.toString() ?? "Unknown Product";
                
                // Safely extract fields with fallback values
                final productPrice = item['price']?.toString() ?? "0";
                final productImage = item['image']?.toString() ?? "";
                final productSubtitle = item['subtitle']?.toString() ?? "";
                final productDesc = item['description']?.toString() ?? "";
                
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 0,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetails(
                            title: productName,
                            price: productPrice,
                            productid: productId,
                            unitprice: productPrice,
                            image: productImage,
                            description: productDesc,
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height * 0.14,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      const Color(0xFFF5F5F5),
                                      Colors.grey.shade50,
                                    ],
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(18),
                                    topRight: Radius.circular(18),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Image.network(
                                      productImage,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[200],
                                          child: const Icon(Icons.error),
                                        );
                                      },
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded /
                                                    loadingProgress.expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 7,
                                right: 7,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white.withOpacity(0.8),
                                  radius: 16,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(Icons.favorite, color: Colors.red, size: 18),
                                    onPressed: () {
                                      _showRemoveConfirmation(productId, productName);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(18),
                                  bottomRight: Radius.circular(18),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        productName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontFamily: 'Raleway-SemiBold',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        productSubtitle,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    Formatter.formatCurrency(
                                      double.tryParse(productPrice)?.toInt() ?? 0,
                                    ),
                                    style: const TextStyle(
                                      fontFamily: 'Poppins-SemiBold',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
