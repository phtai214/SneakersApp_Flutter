import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/respository/components/app_styles.dart';
import 'package:ecommerce_app/respository/components/route_names.dart';
import 'package:ecommerce_app/utils/fav_provider.dart';
import 'package:ecommerce_app/utils/formatter.dart';
import 'package:ecommerce_app/utils/general_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:provider/provider.dart';
import 'package:flutter/animation.dart';

class ProductDetails extends StatefulWidget {
  final String title;
  final String price;
  final String image;
  final String unitprice;
  final String productid;
  final String description;
  final String? brandId;

  const ProductDetails({
    super.key,
    required this.title,
    required this.price,
    required this.image,
    required this.unitprice,
    required this.productid,
    required this.description,
    this.brandId,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> with SingleTickerProviderStateMixin {
  final db2 = FirebaseFirestore.instance.collection('Favourites');
  final id = FirebaseAuth.instance.currentUser!.uid.toString();
  final PersistentShoppingCart cart = PersistentShoppingCart();

  String sizePicker = '38';
  Color colorPicker = Colors.blue;
  late AnimationController _controller;
  late Animation<double> _animation;
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _getBrandName() {
    // Comprehensive mapping of brand IDs to brand names
    Map<String, String> brandMap = {
      's17AsqoNOREUMOKnD73E': 'NIKE',
      'adi123456789': 'ADIDAS',
      'puma987654321': 'PUMA',
      'rb456789123': 'REEBOK',
      'nb789123456': 'NB',
      'ua321654987': 'UA',
      'cv654987321': 'CONVERSE',
      'vn987321654': 'VANS',
      'j123456789': 'JORDAN',
      'as123456789': 'ASICS',
      'fl123456789': 'FILA',
    };
    
    // If brandId is provided and exists in our mapping, use that
    if (widget.brandId != null && widget.brandId!.isNotEmpty) {
      if (brandMap.containsKey(widget.brandId)) {
        return brandMap[widget.brandId]!;
      }
    }
    
    // Otherwise try to detect the brand from product title
    String title = widget.title.toLowerCase();
    
    if (title.contains('nike') || title.contains('air max') || title.contains('air force')) {
      return 'NIKE';
    } else if (title.contains('adidas') || title.contains('yeezy') || title.contains('ultraboost')) {
      return 'ADIDAS';
    } else if (title.contains('puma')) {
      return 'PUMA';
    } else if (title.contains('reebok')) {
      return 'REEBOK';
    } else if (title.contains('new balance') || title.contains(' nb ')) {
      return 'NB';
    } else if (title.contains('under armour') || title.contains(' ua ')) {
      return 'UA';
    } else if (title.contains('converse') || title.contains('chuck taylor')) {
      return 'CONVERSE';
    } else if (title.contains('vans')) {
      return 'VANS';
    } else if (title.contains('jordan') || title.contains('air jordan')) {
      return 'JORDAN';
    } else if (title.contains('asics')) {
      return 'ASICS';
    } else if (title.contains('saucony')) {
      return 'SAUCONY';
    } else if (title.contains('fila')) {
      return 'FILA';
    }
    
    // If we still don't have a match, try to extract the first word as the brand
    if (title.contains(' ')) {
      String firstWord = title.split(' ')[0];
      if (firstWord.length > 1) {
        return firstWord.toUpperCase();
      }
    }
    
    // Default fallback
    return 'BRAND';
  }

  buildButtonColor(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          colorPicker = color;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          border: Border.all(
            color: colorPicker == color ? Colors.black : Colors.transparent,
            width: 2,
          ),
          shape: BoxShape.circle,
          boxShadow: colorPicker == color
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Container(
          height: 38,
          width: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ),
    );
  }

  buildButtonSize(String size) {
    final bool isSelected = sizePicker == size;
    return GestureDetector(
      onTap: () {
        setState(() {
          sizePicker = size;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 12),
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? AppColor.backgroundColor : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.2 : 0.1),
              blurRadius: 6,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderActions() {
    final favprovider = Provider.of<FavouriteProvider>(context);
    final bool isFavorite = favprovider.items.contains(widget.productid);

    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.9),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
              color: isFavorite ? Colors.red : Colors.grey[600],
              size: 20,
            ),
            onPressed: () async {
              if (isFavorite) {
                favprovider.remove(widget.productid);
                await db2.doc(id).collection('items').doc(widget.productid).delete();
              } else {
                favprovider.add(widget.productid);
                await db2.doc(id).collection('items').doc(widget.productid).set({
                  'name': widget.title,
                  'subtitle': 'Bán chạy ',
                  'image': widget.image,
                  'price': widget.price,
                  'description': widget.description,
                });
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: cart.showCartItemCountWidget(
            cartItemCountWidgetBuilder: ((int itemCount) {
              return InkWell(
                onTap: () => Navigator.pushNamed(context, RouteNames.cartscreen),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: Icon(
                          Icons.shopping_bag_rounded,
                          color: Colors.black87,
                          size: 22,
                        ),
                      ),
                      if (itemCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColor.backgroundColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1.5),
                            ),
                            child: Text(
                              itemCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildAddToCartButton(String colorName) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            cart.addToCart(
              PersistentShoppingCartItem(
                productThumbnail: widget.image,
                productId: widget.productid,
                productName: widget.title,
                unitPrice: double.parse(widget.unitprice),
                quantity: 1,
                productDetails: {
                  "size": sizePicker,
                  "color": colorName,
                },
              ),
            ).then((_) {
              showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel: '',
                barrierColor: Colors.black.withOpacity(0.5),
                transitionDuration: const Duration(milliseconds: 400),
                pageBuilder: (context, anim1, anim2) {
                  return Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            spreadRadius: 6,
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.green.shade400,
                                  Colors.green.shade600,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 48,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Thành Công!',
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'Raleway-Bold',
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              color: Colors.green.shade700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Sản phẩm đã được thêm vào giỏ hàng',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 40,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: NetworkImage(widget.image),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Size: $sizePicker, Màu: $colorName',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Roboto',
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        Formatter.formatCurrency(double.parse(widget.price).toInt()),
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Bold',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.backgroundColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(color: AppColor.backgroundColor),
                                    ),
                                  ),
                                  child: Text(
                                    'Tiếp Tục Mua',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Raleway-Bold',
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.backgroundColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.pushNamed(context, RouteNames.cartscreen);
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: AppColor.backgroundColor,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Xem Giỏ Hàng',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Raleway-Bold',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                transitionBuilder: (context, anim1, anim2, child) {
                  return ScaleTransition(
                    scale: CurvedAnimation(
                      parent: anim1,
                      curve: Curves.elasticOut,
                      reverseCurve: Curves.easeOutCubic,
                    ),
                    child: FadeTransition(
                      opacity: anim1,
                      child: child,
                    ),
                  );
                },
              );
              // Auto close after 3 seconds if user doesn't interact
              Future.delayed(const Duration(seconds: 3), () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              });
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.backgroundColor,
                  AppColor.backgroundColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColor.backgroundColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.shopping_bag_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Thêm vào giỏ hàng',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductHeader() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Title
          Text(
            widget.title,
            style: const TextStyle(
              fontFamily: 'Raleway-Bold',
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          
          // Price with currency icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColor.backgroundColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon(
                    //   Icons.attach_money_rounded,
                    //   color: AppColor.backgroundColor,
                    //   size: 24,
                    // ),
                    Text(
                      Formatter.formatCurrency(double.parse(widget.price).toInt()),
                      style: TextStyle(
                        fontFamily: 'Poppins-Bold',
                        fontSize: 22,
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
          
          // Tags row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColor.backgroundColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.category_outlined,
                      size: 16,
                      color: AppColor.backgroundColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Giày Nam',
                      style: TextStyle(
                        color: AppColor.backgroundColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 16,
                      color: Colors.green,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Còn hàng',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    final String colorName = colorPicker == Colors.red
        ? 'Red'
        : colorPicker == Colors.blue
            ? 'Blue'
            : 'Grey';

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, RouteNames.navbarscreen);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 16),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.9),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black87,
              size: 18,
            ),
          ),
        ),
        actions: [_buildHeaderActions()],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: screenheight * 0.35,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFFF5F5F5),
                        const Color.fromARGB(255, 234, 234, 234),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Hero(
                          tag: widget.productid,
                          child: FadeTransition(
                            opacity: _animation,
                            child: Transform.scale(
                              scale: 1.2,
                              child: Image.network(
                                widget.image,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 22),
                  _buildProductHeader(),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mô tả sản phẩm',
                          style: TextStyle(
                            fontFamily: 'Raleway-Bold',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.description,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            height: 1.5,
                            color: Color(0xff707B81),
                            locale: Locale('vi', 'VN'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Màu sắc',
                    style: TextStyle(
                      fontFamily: 'Raleway-Bold',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      buildButtonColor(Colors.blue),
                      buildButtonColor(Colors.red),
                      buildButtonColor(Colors.grey),
                      buildButtonColor(Colors.black),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Kích thước',
                    style: TextStyle(
                      fontFamily: 'Raleway-Bold',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        buildButtonSize('38'),
                        buildButtonSize('39'),
                        buildButtonSize('40'),
                        buildButtonSize('41'),
                        buildButtonSize('42'),
                        buildButtonSize('43'),
                        buildButtonSize('44'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                  _buildAddToCartButton(colorName),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
