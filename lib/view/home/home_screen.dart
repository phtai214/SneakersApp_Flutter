import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/respository/app_bar.dart';
import 'package:ecommerce_app/respository/components/app_styles.dart';
import 'package:ecommerce_app/respository/components/brand_list.dart';
import 'package:ecommerce_app/respository/components/product_container.dart';
import 'package:ecommerce_app/respository/components/route_names.dart';
import 'package:ecommerce_app/utils/fav_provider.dart';
import 'package:ecommerce_app/utils/formatter.dart';
import 'package:ecommerce_app/view/home/product_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  PersistentShoppingCart cart = PersistentShoppingCart();
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  // Animation controllers
  late AnimationController _searchBarAnimationController;
  late AnimationController _categoryAnimationController;
  late AnimationController _popularProductsAnimationController;
  late AnimationController _newArrivalAnimationController;

  // Animations
  late Animation<Offset> _searchBarSlideAnimation;
  late Animation<double> _categoryFadeAnimation;
  late Animation<Offset> _categorySlideAnimation;
  late Animation<double> _popularTitleFadeAnimation;
  late Animation<double> _productsGridOpacityAnimation;
  late Animation<Offset> _newArrivalSlideAnimation;
  late Animation<double> _newArrivalOpacityAnimation;

  initData() async {
    setState(() {
      isLoading = true;
    });

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference productsCollection = firestore.collection('products');
    try {
      QuerySnapshot querySnapshot = await productsCollection.get();
      products = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (_) {
      // Handle error silently
    } finally {
      setState(() {
        isLoading = false;
      });
      // Start animations after data is loaded
      _startAnimations();

      // Show anniversary promotion after a short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        _showAnniversaryPromotion();
      });
    }
  }

  void _showAnniversaryPromotion() async {
    // Check if banner has been shown before
    final prefs = await SharedPreferences.getInstance();
    final hasShownBanner = prefs.getBool('has_shown_30_4_banner_2025') ?? false;
    
    if (hasShownBanner) return;

    // Mark banner as shown
    await prefs.setBool('has_shown_30_4_banner_2025', true);

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        // Auto dismiss after 8 seconds
        Future.delayed(const Duration(seconds: 8), () {
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        });

        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          backgroundColor: Colors.transparent,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.red.shade700, Colors.red.shade900],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'KỶ NIỆM 50 NĂM',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway-Bold',
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'GIẢI PHÓNG MIỀN NAM, THỐNG NHẤT ĐẤT NƯỚC',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway-Bold',
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '30/4/1975 - 30/4/2025',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 15),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://bcp.cdnchinhphu.vn/334894974524682240/2025/4/3/logo-17435855062691125426899-1743646954968104418962.png',
                    height: 192,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Container(
                        height: 170,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.error, color: Colors.red),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'GIẢM GIÁ 10%',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Khi mua từ 3 sản phẩm trở lên',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Raleway-Medium',
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, RouteNames.productsScreen);
                  },
                  child: const Text(
                    'MUA NGAY',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  void _startAnimations() {
    _searchBarAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _categoryAnimationController.forward();
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      _popularProductsAnimationController.forward();
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      _newArrivalAnimationController.forward();
    });
  }

  void _resetAnimations() {
    _searchBarAnimationController.reset();
    _categoryAnimationController.reset();
    _popularProductsAnimationController.reset();
    _newArrivalAnimationController.reset();
  }

  @override
  void initState() {
    super.initState();
    initData();

    // Initialize animation controllers
    _searchBarAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _categoryAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _popularProductsAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _newArrivalAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Setup animations
    _searchBarSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _searchBarAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _categoryFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _categoryAnimationController,
      curve: Curves.easeInOut,
    ));

    _categorySlideAnimation = Tween<Offset>(
      begin: const Offset(-0.2, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _categoryAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _popularTitleFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _popularProductsAnimationController,
      curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
    ));

    _productsGridOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _popularProductsAnimationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    _newArrivalSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _newArrivalAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _newArrivalOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _newArrivalAnimationController,
      curve: Curves.easeIn,
    ));
  }

  @override
  void dispose() {
    _searchBarAnimationController.dispose();
    _categoryAnimationController.dispose();
    _popularProductsAnimationController.dispose();
    _newArrivalAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    final db2 = FirebaseFirestore.instance.collection('Favourites');
    final id = FirebaseAuth.instance.currentUser!.uid.toString();

    final favprovider = Provider.of<FavouriteProvider>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xfff7f7f9),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBarComp(
            color: const Color(0xfff7f7f9),
            apptitle: 'Khám phá',
            appleading: IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Image(image: AssetImage('images/bar.png'))),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: cart.showCartItemCountWidget(
                  cartItemCountWidgetBuilder: ((int itemCount) {
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RouteNames.cartscreen);
                      },
                      child: Badge(
                        label: Text(itemCount.toString()),
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'images/cart.png',
                            color: Colors.black,
                            scale: 1.2,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(
                width: 16,
              )
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xffF7F7F9),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                _resetAnimations();
                await initData();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenwidth * 0.042,
                ),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screenheight * 0.018,
                      ),
                      SlideTransition(
                        position: _searchBarSlideAnimation,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.07),
                                blurRadius: 10,
                                spreadRadius: 0,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            readOnly: true,
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RouteNames.productsScreen);
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Color(0xff6A6A6A),
                                size: 22,
                              ),
                              hintText: 'Tìm giày theo phong cách của bạn',
                              hintStyle: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                color: Color.fromARGB(255, 191, 191, 191),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenheight * 0.022,
                      ),
                      FadeTransition(
                        opacity: _categoryFadeAnimation,
                        child: SlideTransition(
                          position: _categorySlideAnimation,
                          child: Row(
                            children: [
                              const Text(
                                'Chọn danh mục',
                                style: TextStyle(
                                  fontFamily: 'Raleway-SemiBold',
                                  color: Colors.black,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              // TextButton(
                              //   onPressed: () {
                              //     // Navigate to categories view
                              //   },
                              //   style: TextButton.styleFrom(
                              //     padding: EdgeInsets.zero,
                              //     minimumSize: const Size(30, 30),
                              //     tapTargetSize:
                              //         MaterialTapTargetSize.shrinkWrap,
                              //   ),
                              //   child: Text(
                              //     'Xem tất cả',
                              //     style: TextStyle(
                              //       color: AppColor.backgroundColor,
                              //       fontSize: 14,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenheight * 0.00001, 
                      ),
                      FadeTransition(
                        opacity: _categoryFadeAnimation,
                        child: SizedBox(
                          height: 100,
                          child: BrandList(),
                        ),
                      ),
                      SizedBox(
                        height: screenheight * 0.0010,
                      ),
                      FadeTransition(
                        opacity: _popularTitleFadeAnimation,
                        child: Row(
                          children: [
                            const Text(
                              'Giày phổ biến',
                              style: TextStyle(
                                fontFamily: 'Raleway-SemiBold',
                                color: Colors.black,
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, RouteNames.productsScreen);
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(30, 30),
                                tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Xem tất cả',
                                style: TextStyle(
                                  color: AppColor.backgroundColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenheight * 0.01,
                      ),
                      FadeTransition(
                        opacity: _productsGridOpacityAnimation,
                        child: products.isEmpty
                            ? Container(
                                height: 200,
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.inventory_2_outlined,
                                        size: 60, color: Colors.grey[400]),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Không tìm thấy sản phẩm',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : products.length >= 8
                                ? GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: 8,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 15,
                                            crossAxisSpacing: 15,
                                            childAspectRatio: 0.8),
                                    itemBuilder: (context, index) {
                                      return AnimatedBuilder(
                                        animation:
                                            _popularProductsAnimationController,
                                        builder: (context, child) {
                                          final delay = (index / 8) * 0.5;
                                          final value = max(
                                              0.0,
                                              min(
                                                  1.0,
                                                  (_popularProductsAnimationController
                                                              .value -
                                                          delay) *
                                                      2.0));

                                          return Transform.scale(
                                            scale: value,
                                            child: Opacity(
                                              opacity: value,
                                              child: child,
                                            ),
                                          );
                                        },
                                        child: buildProductItem(context, index,
                                            favprovider, db2, id),
                                      );
                                    },
                                  )
                                : const SizedBox(),
                      ),
                      SizedBox(
                        height: screenheight * 0.022,
                      ),
                      FadeTransition(
                        opacity: _newArrivalOpacityAnimation,
                        child: SlideTransition(
                          position: _newArrivalSlideAnimation,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Hàng mới',
                                    style: TextStyle(
                                      fontFamily: 'Raleway-SemiBold',
                                      color: Colors.black,
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, RouteNames.productsScreen);
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(30, 30),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      'Xem tất cả',
                                      style: TextStyle(
                                        color: AppColor.backgroundColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: screenheight * 0.01,
                              ),
                              Container(
                                height: screenheight * 0.17,
                                width: screenwidth,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white,
                                      const Color(0xFFF2F0FF)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.07),
                                      blurRadius: 12,
                                      spreadRadius: 0,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      right: -5,
                                      bottom: 5,
                                      child: Image.asset(
                                        'images/products/shoe3.png',
                                        height: 120,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 14, 20, 14),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Sự lựa chọn hoàn hảo',
                                            style: TextStyle(
                                              fontFamily: 'Raleway-SemiBold',
                                              color: Colors.black
                                                  .withOpacity(0.8),
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '15% OFF',
                                            style: TextStyle(
                                              fontFamily: 'Poppins-Bold',
                                              color:
                                                  AppColor.backgroundColor,
                                              fontSize: 25,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 14, vertical: 7),
                                            decoration: BoxDecoration(
                                              color:
                                                  AppColor.backgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(22),
                                            ),
                                            child: const Text(
                                              'Mua ngay',
                                              style: TextStyle(
                                                fontFamily: 'Poppins-Medium',
                                                color: Colors.white,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenheight * 0.04,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  double max(double a, double b) => a > b ? a : b;
  double min(double a, double b) => a < b ? a : b;

  Widget buildProductItem(BuildContext context, int index,
      FavouriteProvider favprovider, CollectionReference db2, String id) {
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
              builder: (BuildContext context) => ProductDetails(
                title: products[index]['productname'],
                price: products[index]['productprice'],
                productid: products[index]['productId'],
                unitprice: products[index]['unitprice'],
                image: products[index]['imagelink'].toString(),
                description: products[index]['description'],
                brandId: products[index]['brandId'] ?? '', // Pass the brandId
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
                          products[index]['imagelink'],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 7,
                    right: 7,
                    child: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.07),
                            blurRadius: 6,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () async {
                          if (favprovider.items
                              .contains(products[index]['productId'])) {
                            favprovider.remove(products[index]['productId']);
                            db2
                                .doc(id)
                                .collection('items')
                                .doc(products[index]['productId'])
                                .delete();
                          } else {
                            favprovider.add(products[index]['productId']);
                            db2
                                .doc(id)
                                .collection('items')
                                .doc(products[index]['productId'])
                                .set(
                              {
                                'product id': products[index]['productId']
                                    .toString(),
                                'name': products[index]['productname']
                                    .toString(),
                                'subtitle': products[index]['title']
                                    .toString(),
                                'image': products[index]['imagelink']
                                    .toString(),
                                'price': products[index]['productprice']
                                    .toString(),
                                'description': products[index]['description']
                                    .toString(),
                              },
                            );
                          }
                        },
                        icon: Icon(
                          favprovider.items
                                  .contains(products[index]['productId'])
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          color: Colors.red,
                          size: 16,
                        ),
                        padding: EdgeInsets.zero,
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
                            products[index]['productname'] ?? 'Product Name',
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
                            products[index]['title'] ?? 'Brand',
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Formatter.formatCurrency(double.parse(
                                    products[index]['productprice'])
                                .toInt()),
                            style: TextStyle(
                              fontFamily: 'Poppins-SemiBold',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColor.backgroundColor,
                            ),
                          ),
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColor.backgroundColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 18,
                            ),
                          )
                        ],
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
  }
}
