import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/respository/components/app_styles.dart';
import 'package:ecommerce_app/respository/components/round_button.dart';
import 'package:ecommerce_app/respository/components/route_names.dart';
import 'package:ecommerce_app/utils/general_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({
    super.key,
    required this.name,
    required this.email,
  });

  final String name;
  final String email;

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> with SingleTickerProviderStateMixin {
  late TextEditingController emailcontroller;
  late TextEditingController nameController;
  final db = FirebaseFirestore.instance.collection("User Data");
  final id = FirebaseAuth.instance.currentUser!.uid;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    emailcontroller = TextEditingController(text: widget.email);
    nameController = TextEditingController(text: widget.name);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  void _showSuccessDialog() {
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
                  'Cập nhật thành công!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Thông tin của bạn đã được cập nhật',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
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

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, RouteNames.navbarscreen);
    });
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool enabled = true}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: const EdgeInsets.all(20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final utilsProvider = Provider.of<GeneralUtils>(context, listen: true);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Cập nhật hồ sơ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: db.doc(id).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          dynamic userData = snapshot.data?.data();

          return SingleChildScrollView(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Stack(
                          children: [
                            Hero(
                              tag: 'profile_image',
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColor.backgroundColor,
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.grey[200],
                                  backgroundImage: userData?['image']?.toString().isNotEmpty == true
                                      ? NetworkImage(userData['image'])
                                      : const AssetImage('images/profile.png') as ImageProvider,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () async {
                                  await utilsProvider.getgalleryimage();
                                  await utilsProvider.uploadimage();
                                  await utilsProvider.uploadtoFirestore();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColor.backgroundColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Cập nhật ảnh đại diện',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColor.backgroundColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildTextField('Họ và tên', nameController),
                  _buildTextField('Email', emailcontroller),
                  _buildTextField('Mật khẩu', TextEditingController(text: '********'), enabled: false),
                  const SizedBox(height: 30),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (emailcontroller.text.isNotEmpty && nameController.text.isNotEmpty) {
                          utilsProvider.showloading(true);
                          await db.doc(id).update({
                            'Email': emailcontroller.text,
                            'Full name': nameController.text
                          });
                          utilsProvider.showloading(false);
                          _showSuccessDialog();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      child: utilsProvider.load
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Cập nhật',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailcontroller.dispose();
    nameController.dispose();
    super.dispose();
  }
}
