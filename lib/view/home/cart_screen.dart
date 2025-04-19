import 'package:ecommerce_app/respository/components/app_styles.dart';
import 'package:ecommerce_app/respository/components/round_button.dart';
import 'package:ecommerce_app/respository/components/route_names.dart';
import 'package:ecommerce_app/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  PersistentShoppingCart cart = PersistentShoppingCart();

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: AppColor.backgroundColor,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Giỏ hàng của bạn đang trống',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Hãy thêm một vài sản phẩm và quay lại nhé!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteNames.navbarscreen,
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.backgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Tiếp tục mua sắm',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Row(
        children: [
          cart.showCartItemCountWidget(
            cartItemCountWidgetBuilder: (count) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColor.backgroundColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$count sản phẩm',
                style: TextStyle(
                  color: AppColor.backgroundColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () => cart.clearCart(),
            icon: Icon(
              Icons.delete_outline,
              color: Colors.red.withOpacity(0.8),
              size: 20,
            ),
            label: Text(
              'Xóa tất cả',
              style: TextStyle(
                color: Colors.red.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
          ),
        ],
      ),
    );
  }

  Widget _buildCartList(List<PersistentShoppingCartItem> items) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildCartItem(items[index]),
    );
  }

  Widget _buildCartItem(PersistentShoppingCartItem item) {
    return Dismissible(
      key: Key(item.productId),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline, color: Colors.red.shade300, size: 24),
            const SizedBox(height: 4),
            Text(
              'Xóa',
              style: TextStyle(
                color: Colors.red.shade300,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (_) => cart.removeFromCart(item.productId),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image with Gradient Overlay
                  Container(
                    width: 88,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          Colors.grey.shade50,
                        ],
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Hero(
                        tag: 'cart_${item.productId}',
                        child: Image.network(
                          item.productThumbnail.toString(),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name
                        Text(
                          item.productName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Product Variants
                        Wrap(
                          spacing: 8,
                          children: [
                            _buildVariantTag(
                              'Size ${item.productDetails!['size']}',
                              Icons.straighten_rounded,
                            ),
                            _buildVariantTag(
                              item.productDetails!['color'],
                              Icons.color_lens_outlined,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Price and Quantity Controls
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(
                                //   'Đơn giá',
                                //   style: TextStyle(
                                //     color: Colors.grey[600],
                                //     fontSize: 12,
                                //   ),
                                // ),
                                const SizedBox(height: 1),
                                Text(
                                  Formatter.formatCurrency(item.unitPrice.toInt()),
                                  style: TextStyle(
                                    color: AppColor.backgroundColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            _buildQuantityControls(item),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Replace total price chip with delete button
            Positioned(
              right: 8,
              top: 8,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => cart.removeFromCart(item.productId),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.red.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVariantTag(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityControls(PersistentShoppingCartItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuantityButton(
            Icons.remove,
            () => cart.decrementCartItemQuantity(item.productId),
          ),
          Container(
            width: 40,
            alignment: Alignment.center,
            child: Text(
              item.quantity.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          _buildQuantityButton(
            Icons.add,
            () => cart.incrementCartItemQuantity(item.productId),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 18,
            color: AppColor.backgroundColor,
          ),
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(double totalAmount) {
    // Calculate discount - 10% off if total quantity is more than 3
    int totalQuantity = 0;

    // Fix: Use cart.getCartData() to get cart items instead of getCartItems()
    Map<String, dynamic> cartData = cart.getCartData();
    List<PersistentShoppingCartItem> cartItems =
        List<PersistentShoppingCartItem>.from(cartData['cartItems'] ?? []);

    cartItems.forEach((item) => totalQuantity += item.quantity);
    double discountAmount = 0;
    if (totalQuantity > 3) {
      discountAmount = totalAmount * 0.1; // 10% discount
    }
    double finalAmount = totalAmount - discountAmount;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPriceRow('Tạm tính', totalAmount),
          _buildPriceRow('Giảm giá', discountAmount, isDiscount: true),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          _buildPriceRow('Tổng cộng', finalAmount, isTotal: true),
          if (discountAmount > 0)
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.discount_outlined, size: 16, color: Colors.green),
                    const SizedBox(width: 6),
                    Text(
                      'Bạn được giảm 10% khi mua trên 3 sản phẩm!',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                RouteNames.checkOutScreen,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.backgroundColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Tiến hành thanh toán',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? Colors.black87 : Colors.grey[600],
            ),
          ),
          const Spacer(),
          Text(
            isDiscount && amount > 0 ? "- ${Formatter.formatCurrency(amount.toInt())}" : Formatter.formatCurrency(amount.toInt()),
            style: TextStyle(
              fontSize: isTotal ? 20 : 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isDiscount ? Colors.green : (isTotal ? AppColor.backgroundColor : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  void showAddToCartSuccess(BuildContext context, {String? productName, String? imagePath}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColor.backgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Success icon with animation
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              // Notification text
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thêm vào giỏ hàng thành công!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    if (productName != null)
                      Text(
                        productName,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              // View cart button
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  // If already on cart screen, just refresh
                  // Navigator logic is handled elsewhere
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Xem giỏ hàng',
                  style: TextStyle(
                    color: AppColor.backgroundColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pushNamed(context, RouteNames.navbarscreen),
        ),
        title: const Text(
          'Giỏ hàng',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: cart.showCartItems(
        cartItemsBuilder: (context, items) {
          if (items.isEmpty) {
            return _buildEmptyCart();
          }
          return Column(
            children: [
              _buildCartHeader(),
              Expanded(child: _buildCartList(items)),
              _buildCheckoutSection(cart.calculateTotalPrice()),
            ],
          );
        },
      ),
    );
  }
}
