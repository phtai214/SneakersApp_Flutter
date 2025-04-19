import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/respository/components/app_styles.dart';
import 'package:ecommerce_app/respository/components/round_button.dart';
import 'package:ecommerce_app/respository/components/route_names.dart';
import 'package:ecommerce_app/utils/formatter.dart';
import 'package:ecommerce_app/utils/general_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:provider/provider.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final auth = FirebaseAuth.instance;

  void _showEditDialog(String title, TextEditingController controller, String field) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Chỉnh sửa $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Nhập $title mới'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (field == 'email') {
                    email = controller.text;
                  } else if (field == 'phone') {
                    phone = controller.text;
                  } else if (field == 'address') {
                    address = controller.text;
                  }
                });
                Navigator.pop(context);
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }
  var userdata;
  var phone = '';
  var email = '';
  String address = '';
  PersistentShoppingCart cart = PersistentShoppingCart();
  String selectedPaymentMethod = 'COD';

  final db = FirebaseFirestore.instance.collection('User Data');
  final TextEditingController phonecontroller = TextEditingController();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController addresscontroller = TextEditingController();

  @override
  void initState() {
    fetchdata();
    super.initState();
  }

  Future fetchdata() async {
    try {
      DocumentSnapshot db2 = await db.doc(auth.currentUser!.uid).get();
      userdata = db2.data();
      setState(() {
        email = userdata['Email'];
      });
      phone = userdata['phone'];
      address = userdata['address'] ?? '';
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _showOrderSuccessDialog() {
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
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 15,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Đặt hàng thành công!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Cảm ơn bạn đã mua hàng',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          RouteNames.navbarscreen,
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Tiếp tục mua sắm'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RouteNames.orderSreen);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.backgroundColor,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                      'Xem đơn hàng',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
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
          ),
          child: FadeTransition(
            opacity: anim1,
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildContactInfoSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Thông tin liên hệ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          _buildContactItem(
            'images/email.png',
            'Email',
            email,
            () => _showEditDialog('Email', emailcontroller, 'email'),
          ),
          _buildContactItem(
            'images/phone.png',
            'Số điện thoại',
            phone,
            () => _showEditDialog('Số điện thoại', phonecontroller, 'phone'),
          ),
          _buildContactItem(
            'icons/location.png',
            'Địa chỉ',
            address,
            () => _showEditDialog('Địa chỉ', addresscontroller, 'address'),
            isIcon: true,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildContactItem(String icon, String label, String value, VoidCallback onEdit, {bool isIcon = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColor.backgroundColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: isIcon 
              ? Icon(Icons.location_on_outlined, color: AppColor.backgroundColor)
              : Image.asset(icon, height: 20, width: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value.isEmpty ? 'Chưa cập nhật' : value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColor.backgroundColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.edit_outlined,
                size: 16,
                color: AppColor.backgroundColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Phương thức thanh toán',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const Divider(height: 1),
          _buildPaymentOption(
            'COD',
            'Thanh toán khi nhận hàng',
            Icons.local_shipping_outlined,
          ),
          _buildPaymentOption(
            'VISA',
            'Thanh toán thẻ ngân hàng',
            Icons.credit_card_outlined,
            enabled: false,
            showDivider: false,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String value, String title, IconData icon, 
      {bool enabled = true, bool showDivider = true}) {
    return Column(
      children: [
        RadioListTile<String>(
          value: value,
          groupValue: selectedPaymentMethod,
          onChanged: enabled ? (String? value) {
            setState(() {
              selectedPaymentMethod = value!;
            });
          } : null,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColor.backgroundColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: enabled ? AppColor.backgroundColor : Colors.grey,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: enabled ? Colors.black87 : Colors.grey,
                      ),
                    ),
                    if (!enabled)
                      Text(
                        'Sắp ra mắt',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          activeColor: AppColor.backgroundColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: Colors.grey.withOpacity(0.2),
          ),
      ],
    );
  }

  Widget _buildOrderSummary() {
    // Calculate discount - 10% off if total quantity is more than 3
    int totalQuantity = 0;
    
    // Fix: Use cart.getCartData() to get cart items instead of getCartItems()
    Map<String, dynamic> cartData = cart.getCartData();
    List<PersistentShoppingCartItem> cartItems = 
        List<PersistentShoppingCartItem>.from(cartData['cartItems'] ?? []);
    
    cartItems.forEach((item) => totalQuantity += item.quantity);
    double totalAmount = cart.calculateTotalPrice();
    double discountAmount = 0;
    if (totalQuantity > 3) {
      discountAmount = totalAmount * 0.1; // 10% discount
    }
    double finalAmount = totalAmount - discountAmount;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tổng quan đơn hàng',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildPriceRow('Thành tiền', totalAmount),
            _buildPriceRow('Giảm giá', discountAmount, isDiscount: true),
            if (discountAmount > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.discount_outlined, size: 16, color: Colors.green),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Bạn được giảm 10% khi mua trên 3 sản phẩm!',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1),
            ),
            _buildPriceRow('Tổng cộng', finalAmount, isTotal: true),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => placeOrder(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Xác nhận đặt hàng',
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
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? Colors.black87 : Colors.grey[600],
            ),
          ),
          Text(
            isDiscount && amount > 0 ? "- ${Formatter.formatCurrency(amount.toInt())}" : Formatter.formatCurrency(amount.toInt()),
            style: TextStyle(
              fontSize: isTotal ? 18 : 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isDiscount ? Colors.green : (isTotal ? AppColor.backgroundColor : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> placeOrder() async {
    final orderDb = FirebaseFirestore.instance.collection('Orders');

    try {
      String orderId = DateTime.now().millisecondsSinceEpoch.toString();
      Map<String, dynamic> cartData = cart.getCartData();
      List<PersistentShoppingCartItem> cartItems =
          List<PersistentShoppingCartItem>.from(cartData['cartItems'] ?? []);

      List<Map<String, dynamic>> items =
          cartItems.map((item) => item.toJson()).toList();
          
      // Calculate discount
      int totalQuantity = 0;
      cartItems.forEach((item) => totalQuantity += item.quantity);
      double totalAmount = cartData['totalPrice'] ?? 0;
      double discountAmount = 0;
      if (totalQuantity > 3) {
        discountAmount = totalAmount * 0.1; // 10% discount
      }
      double finalAmount = totalAmount - discountAmount;

      await orderDb.doc(orderId).set({
        'orderId': orderId,
        'userId': auth.currentUser!.uid,
        'email': email,
        'phone': phone,
        'address': address,
        'subtotalPrice': totalAmount,
        'discountAmount': discountAmount,
        'totalPrice': finalAmount,
        'items': items,
        'status': 'pending',
        'paymentMethod': selectedPaymentMethod,
        'timestamp': FieldValue.serverTimestamp(),
      });

      cart.clearCart();
      _showOrderSuccessDialog();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Có lỗi xảy ra, vui lòng thử lại!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pushNamed(context, RouteNames.cartscreen);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
        backgroundColor: const Color(0xfff7f7f9),
        title: const Text('Thanh toán'),
        centerTitle: true,
        titleTextStyle: TextStyling.apptitle,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildContactInfoSection(),
            _buildPaymentMethodSelector(),
            _buildOrderSummary(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
