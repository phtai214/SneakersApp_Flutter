import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/respository/components/app_styles.dart';
import 'package:ecommerce_app/respository/components/route_names.dart';
import 'package:ecommerce_app/utils/formatter.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  void initData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference productsCollection = firestore.collection('products');
    
    try {
      setState(() {
        isLoading = true;
        hasError = false;
      });
      
      QuerySnapshot querySnapshot = await productsCollection.get();
      products = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
          
      // Sort products by newest (assuming there's a timestamp field)
      // If there's no timestamp, you can remove this sorting
      products.sort((a, b) {
        // Adjust the field name if you have a timestamp field
        // Or implement your own sorting logic
        return 0; // Default no sorting
      });
      
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = e.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    
    _animationController.forward();
    initData();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f7f9),
      appBar: AppBar(
        backgroundColor: const Color(0xfff7f7f9),
        elevation: 0,
        title: const Text('Thông báo'),
        titleTextStyle: TextStyling.apptitle,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pushNamed(context, RouteNames.navbarscreen);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColor.backgroundColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh_rounded,
              color: AppColor.backgroundColor,
            ),
            onPressed: () {
              initData();
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _buildBody(),
      ),
    );
  }
  
  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColor.backgroundColor,
        ),
      );
    }
    
    if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.red,
              size: 60,
            ),
            const SizedBox(height: 16),
            const Text(
              'Đã xảy ra lỗi',
              style: TextStyle(
                fontFamily: 'Raleway-Bold',
                fontSize: 18,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: initData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Thử lại',
                style: TextStyle(
                  fontFamily: 'Raleway-SemiBold',
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );
    }
    
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_off_outlined,
                size: 60,
                color: Colors.grey.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Không có thông báo',
              style: TextStyle(
                fontFamily: 'Raleway-Bold',
                fontSize: 20,
                color: Color(0xff2B2B2B),
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Chúng tôi sẽ thông báo cho bạn khi có sản phẩm mới hoặc ưu đãi đặc biệt',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Color(0xff707B81),
                ),
              ),
            ),
          ],
        ),
      );
    }
    
    // Display notifications
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      itemCount: products.length > 10 ? 10 : products.length, // Limit to 10 notifications
      itemBuilder: (context, index) {
        final product = products[index];
        
        // Generate a random date within the last 7 days for demo purposes
        // In a real app, you'd use an actual timestamp from your data
        final random = DateTime.now().subtract(
          Duration(
            days: index % 7,
            hours: (index * 3) % 24,
            minutes: (index * 7) % 60,
          ),
        );
        
        return _buildNotificationCard(product, random, index);
      },
    );
  }
  
  Widget _buildNotificationCard(Map<String, dynamic> product, DateTime timestamp, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: 1),
        duration: Duration(milliseconds: 500 + (index * 100)),
        curve: Curves.easeOutQuint,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: Opacity(
              opacity: value,
              child: child,
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                // Navigate to product details or handle notification tap
                // For example: Navigator.pushNamed(context, RouteNames.productDetailsScreen, arguments: product['id']);
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Product image with shadow and white background
                        Container(
                          height: 70,
                          width: 70,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xffF7F7F9),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              product['imagelink'] ?? 'https://via.placeholder.com/150',
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: AppColor.backgroundColor,
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.broken_image_rounded,
                                  color: Colors.grey.withOpacity(0.7),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Sản phẩm mới',
                                    style: const TextStyle(
                                      fontFamily: 'Raleway-Bold',
                                      fontSize: 16,
                                      color: AppColor.backgroundColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColor.backgroundColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      'Mới',
                                      style: TextStyle(
                                        fontFamily: 'Raleway-Medium',
                                        fontSize: 11,
                                        color: AppColor.backgroundColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product['name'] ?? 'Sản phẩm',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                Formatter.formatCurrency(double.parse(product['unitprice'] ?? '0').toInt()),
                                style: const TextStyle(
                                  fontFamily: 'Poppins Medium',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.backgroundColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Divider(
                      color: Colors.grey.withOpacity(0.2),
                      thickness: 1,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nhận ưu đãi đặc biệt hôm nay',
                          style: TextStyle(
                            fontFamily: 'Raleway-Medium',
                            fontSize: 12,
                            color: Color(0xff707B81),
                          ),
                        ),
                        Text(
                          _formatTimeAgo(timestamp),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  // Helper method to format time in a relative way
  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }
}
