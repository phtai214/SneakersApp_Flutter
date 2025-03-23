import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

Future<void> addBrands() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference brandsCollection = firestore.collection('brands');

  List<Map<String, dynamic>> brands = [
    {"name": "Nike"},
    {"name": "Adidas"},
    {"name": "Puma"},
    {"name": "Reebok"},
  ];

  for (var brand in brands) {
    await brandsCollection.add(brand);
  }
}

Future<String?> uploadImageToCloudinary(String assetPath) async {
  const String cloudName = "dgfmiwien";
  const String apiKey = "BvZZdKGI6pq4C8QrALmkZWt2MnY";
  const String uploadPreset = "sneakers";

  try {
    XFile image = XFile(assetPath);
    File file = File(image.path);

    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path),
      "upload_preset": uploadPreset,
      "api_key": apiKey,
    });

    Response response = await Dio().post(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
      data: formData,
      options: Options(headers: {"Content-Type": "multipart/form-data"}),
    );

    if (response.statusCode == 200 && response.data != null) {
      return response.data["secure_url"] as String?;
    }
  } catch (_) {}

  return null;
}

class ProductList {
  ProductList() {
    fetchProducts();
  }

  static Future<void> uploadProductsWithImages() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference productsCollection = firestore.collection('products');

    try {
      for (var product in items) {
        await productsCollection.doc().set(product);
      }
    } catch (_) {}
  }

  Future<void> fetchProducts() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference productsCollection = firestore.collection('products');
    try {
      QuerySnapshot querySnapshot = await productsCollection.get();
      itemlist = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (_) {}
  }

  List<Map<String, dynamic>> itemlist = [];

  static List<Map<String, dynamic>> items = [
    {
      'productId': '0',
      'title': 'Best Seller',
      'productname': 'Nike Jordan',
      'imagelink':
          'https://res.cloudinary.com/dgfmiwien/image/upload/v1742225351/sneakers/shoe1_mcdii1.png',
      'productprice': '350',
      'unitprice': '350',
      'brandId': 's17AsqoNOREUMOKnD73E',
      'description':
          'Nike Jordan sneakers offer a stylish look, durable materials, and exceptional comfort for all-day wear.'
    },
    {
      'productId': '1',
      'title': 'Best Seller',
      'productname': 'Nike Air Max',
      'imagelink':
          'https://res.cloudinary.com/dgfmiwien/image/upload/v1742225351/sneakers/shoe2_tut1d1.png',
      'productprice': '752',
      'unitprice': '752',
      'brandId': 's17AsqoNOREUMOKnD73E',
      'description':
          'Nike Air Max features advanced cushioning, breathable mesh, and a sleek design for superior everyday performance.'
    },
    {
      'productId': '2',
      'title': 'Best Seller',
      'productname': 'Nike Air Force',
      'imagelink':
          'https://res.cloudinary.com/dgfmiwien/image/upload/v1742225351/sneakers/shoe3_y1qwvq.png',
      'productprice': '799',
      'unitprice': '799',
      'brandId': 's17AsqoNOREUMOKnD73E',
      'description':
          'Classic Nike Air Force sneakers with high-quality leather, durable sole, and timeless design for any outfit.'
    },
    {
      'productId': '3',
      'title': 'Best Seller',
      'productname': 'Nike Blazer',
      'imagelink':
          'https://res.cloudinary.com/dgfmiwien/image/upload/v1742225352/sneakers/shoe4_xhx05u.png',
      'productprice': '350',
      'unitprice': '350',
      'brandId': 's17AsqoNOREUMOKnD73E',
      'description':
          'Nike Blazer provides a retro-inspired look, lightweight comfort, and excellent support for casual or active wear.'
    },
    {
      'productId': '4',
      'title': 'Best Seller',
      'productname': 'Nike Air Jordan 4',
      'imagelink':
          'https://res.cloudinary.com/dgfmiwien/image/upload/v1742225352/sneakers/shoe5_qwqghr.png',
      'productprice': '804',
      'unitprice': '804',
      'brandId': 's17AsqoNOREUMOKnD73E',
      'description':
          'Nike Air Jordan 4 combines premium materials, bold design, and superior comfort for an outstanding sneaker experience.'
    },
    {
      'productId': '5',
      'title': 'Best Seller',
      'productname': 'Nike Air Waffle',
      'imagelink':
          'https://res.cloudinary.com/dgfmiwien/image/upload/v1742225352/sneakers/shoe6_nrd6ps.png',
      'productprice': '420',
      'unitprice': '420',
      'brandId': 's17AsqoNOREUMOKnD73E',
      'description':
          'Nike Air Waffle features a breathable upper, cushioned midsole, and durable outsole for all-day walking comfort.'
    },
    {
      'productId': '6',
      'title': 'Best Seller',
      'productname': 'Nike Air Jordan',
      'imagelink':
          'https://res.cloudinary.com/dgfmiwien/image/upload/v1742225352/sneakers/shoe7_p87j0h.png',
      'productprice': '210',
      'unitprice': '210',
      'brandId': 's17AsqoNOREUMOKnD73E',
      'description':
          'Nike Air Jordan sneakers bring sporty elegance, superior comfort, and top-notch performance for basketball enthusiasts.'
    },
    {
      'productId': '7',
      'title': 'Best Seller',
      'productname': 'Nike Blazer Mid',
      'imagelink':
          'https://res.cloudinary.com/dgfmiwien/image/upload/v1742225352/sneakers/shoe8_alookg.png',
      'productprice': '304',
      'unitprice': '304',
      'brandId': 's17AsqoNOREUMOKnD73E',
      'description':
          'Nike Blazer Mid combines vintage design, excellent ankle support, and durable materials for a stylish urban look.'
    },
    {
      'productId': '8',
      'title': 'Best Seller',
      'productname': 'Nike Dunk Low',
      'imagelink':
          'https://res.cloudinary.com/dgfmiwien/image/upload/v1742225353/sneakers/shoe9_geolqw.png',
      'productprice': '804',
      'unitprice': '804',
      'brandId': 's17AsqoNOREUMOKnD73E',
      'description':
          'Nike Dunk Low delivers a fashionable silhouette, premium leather upper, and soft cushioning for ultimate comfort.'
    },
    {
      'productId': '9',
      'title': 'Best Seller',
      'productname': 'Nike 804',
      'imagelink':
          'https://res.cloudinary.com/dgfmiwien/image/upload/v1742225353/sneakers/shoe10_mjqgj5.png',
      'productprice': '820',
      'unitprice': '820',
      'brandId': 's17AsqoNOREUMOKnD73E',
      'description':
          'Nike 804 sneakers offer a lightweight feel, modern design, and superior grip for an enhanced walking experience.'
    },
  ];
}
