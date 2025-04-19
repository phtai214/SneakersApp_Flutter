import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce_app/respository/components/app_styles.dart';
import 'package:ecommerce_app/respository/components/round_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProductScreen extends StatefulWidget {
  final String? productId;
  final Map<String, dynamic>? productData;

  const EditProductScreen({super.key, this.productId, this.productData});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  String? selectedImageUrl;
  String? selectedBrandId;
  List<Map<String, String>> brands = [];

  @override
  void initState() {
    super.initState();
    fetchBrands().then((data) {
      setState(() {
        brands = data;
      });
    });

    if (widget.productData != null) {
      nameController.text = widget.productData!['productname'] ?? '';
      priceController.text = widget.productData!['productprice'] ?? '';
      descController.text = widget.productData!['description'] ?? '';
      selectedImageUrl = widget.productData!['imagelink'];
    }
  }

  Future<String?> uploadImageToCloudinary(String imagePath) async {
    const String cloudName = "dgfmiwien";
    const String apiKey = "BvZZdKGI6pq4C8QrALmkZWt2MnY";
    const String uploadPreset = "sneakers";

    try {
      File file = File(imagePath);
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path),
        "upload_preset": uploadPreset,
        "api_key": apiKey,
      });

      Response response = await Dio().post(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
        data: formData,
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data["secure_url"] as String?;
      }
    } catch (_) {}

    return null;
  }

  Future<List<Map<String, String>>> fetchBrands() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('brands').get();
    return snapshot.docs
        .map((doc) => {"id": doc.id, "name": doc["name"].toString()})
        .toList();
  }

  Future<void> saveProduct() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        selectedImageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin!")),
      );
      return;
    }

    Map<String, dynamic> productData = {
      "brandId": selectedBrandId,
      "productname": nameController.text,
      "productprice": priceController.text,
      "unitprice": priceController.text,
      "description": descController.text,
      "imagelink": selectedImageUrl,
      "title": "Bán chạy"
    };

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      if (widget.productId == null) {
        DocumentReference newProduct =
            await firestore.collection('products').add(productData);
        await newProduct.update({"productId": newProduct.id});
        _showModernSnackBar("Thêm sản phẩm thành công!", context);
      } else {
        await firestore
            .collection('products')
            .doc(widget.productId)
            .update(productData);
        _showModernSnackBar("Cập nhật sản phẩm thành công!", context);
      }

      await Future.delayed(Duration(seconds: 1));
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đã xảy ra lỗi, vui lòng thử lại!")),
      );
    }
  }

  void _showModernSnackBar(String message, BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Thành công',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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

    // Auto dismiss after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
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

  Widget _buildBrandSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            "Thương hiệu",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
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
          child: DropdownButtonFormField<String>(
            value: selectedBrandId,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            hint: const Row(
              children: [
                Icon(Icons.branding_watermark_outlined, 
                     color: Colors.grey,
                     size: 20),
                SizedBox(width: 10),
                Text("Chọn thương hiệu",
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
            items: brands.map((brand) {
              return DropdownMenuItem<String>(
                value: brand["id"],
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.network(
                        brand["logo"] ?? 
                        'https://logo.clearbit.com/${brand["name"]?.toLowerCase()}.com',
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              brand["name"]?[0] ?? '?',
                              style: TextStyle(
                                color: AppColor.backgroundColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      brand["name"] ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedBrandId = value;
              });
            },
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            isExpanded: true,
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          widget.productId == null ? "Thêm sản phẩm" : "Cập nhật sản phẩm",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () async {
                    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      // Show loading indicator
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                      
                      String? uploadedUrl = await uploadImageToCloudinary(image.path);
                      Navigator.pop(context); // Hide loading indicator
                      
                      if (uploadedUrl != null) {
                        setState(() {
                          selectedImageUrl = uploadedUrl;
                        });
                      }
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: selectedImageUrl != null
                        ? Stack(
                            children: [
                              Image.network(
                                selectedImageUrl!,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                              Container(
                                color: Colors.black.withOpacity(0.3),
                                child: const Center(
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(
                            color: Colors.grey[100],
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cloud_upload_outlined,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Chọn ảnh sản phẩm",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Form Fields
              _buildTextField(nameController, "Tên sản phẩm"),
              _buildTextField(priceController, "Giá sản phẩm"),
              _buildTextField(descController, "Mô tả sản phẩm", maxLines: 4),

              // Brand Selector
              _buildBrandSelector(),

              // Save Button
              Container(
                width: double.infinity,
                height: 56,
                margin: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: saveProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    widget.productId == null ? "Thêm sản phẩm" : "Cập nhật",
                    style: const TextStyle(
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
      ),
    );
  }
}
