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
      'title': 'Bán chạy',
      'productname': 'Nike Jordan',
      'imagelink':
          'https://res.cloudinary.com/dgfmiwien/image/upload/v1742225351/sneakers/shoe1_mcdii1.png',
      'productprice': '350',
      'unitprice': '350',
      'brandId': 's17AsqoNOREUMOKnD73E',
      'description':
          'Giày thể thao Nike Jordan có kiểu dáng thời trang, chất liệu bền và cực kỳ thoải mái khi mang cả ngày.'
    },
    {
      'productId': '1',
      'title': 'Bán chạy',
      'productname': 'Nike Air Max',
      'imagelink':
          'https://res.cloudinary.com/dgfmiwien/image/upload/v1742225351/sneakers/shoe2_tut1d1.png',
      'productprice': '752',
      'unitprice': '752',
      'brandId': 's17AsqoNOREUMOKnD73E',
      'description':
          'Nike Air Max có đệm tiên tiến, lưới thoáng khí và thiết kế đẹp mắt mang lại hiệu suất vượt trội hàng ngày.'
    },
    {
      'productId': '2',
      'title': 'Bán chạy',
      'productname': 'Nike Air Force',
      'imagelink':
          'https://res.cloudinary.com/dgfmiwien/image/upload/v1742225351/sneakers/shoe3_y1qwvq.png',
      'productprice': '799',
      'unitprice': '799',
      'brandId': 's17AsqoNOREUMOKnD73E',
      'description':
          'Giày thể thao Nike Air Force cổ điển với chất liệu da cao cấp, đế bền và thiết kế vượt thời gian phù hợp với mọi trang phục.'
    },
    {
      'productId': '3',
      'title': 'Bán chạy',
      'productname': 'Nike Blazer',
      'imagelink':
          'https://res.cloudinary.com/dgfmiwien/image/upload/v1742225352/sneakers/shoe4_xhx05u.png',
      'productprice': '350',
      'unitprice': '350',
      'brandId': 's17AsqoNOREUMOKnD73E',
      'description':
          'Nike Blazer mang đến vẻ ngoài lấy cảm hứng từ phong cách cổ điển, thoải mái, nhẹ nhàng và hỗ trợ tuyệt vời cho trang phục thường ngày hoặc trang phục năng động.'
    },
    {
      'productId': '4',
      'title': 'Bán chạy',
      'productname': 'Nike Air Jordan 4',
      'imagelink':
          'https://res.cloudinary.com/dgfmiwien/image/upload/v1742225352/sneakers/shoe5_qwqghr.png',
      'productprice': '804',
      'unitprice': '804',
      'brandId': 's17AsqoNOREUMOKnD73E',
      'description':
          'Nike Air Jordan 4 kết hợp giữa chất liệu cao cấp, thiết kế táo bạo và sự thoải mái vượt trội để mang đến trải nghiệm giày thể thao tuyệt vời.'
    },
    {
      'productId': '5',
      'title': 'Bán chạy',
      'productname': 'Nike Air Waffle',
      'imagelink':
          'https://res.cloudinary.com/dgfmiwien/image/upload/v1742225352/sneakers/shoe6_nrd6ps.png',
      'productprice': '420',
      'unitprice': '420',
      'brandId': 's17AsqoNOREUMOKnD73E',
      'description':
          'Nike Air Waffle có phần trên thoáng khí, đế giữa có đệm và đế ngoài bền bỉ mang lại sự thoải mái khi đi bộ cả ngày.'
    },
    {
      'productId': '6',
      'title': 'Bán chạy',
      'productname': 'Nike Air Jordan',
      'imagelink':
          'https://res.cloudinary.com/dgfmiwien/image/upload/v1742225352/sneakers/shoe7_p87j0h.png',
      'productprice': '210',
      'unitprice': '210',
      'brandId': 's17AsqoNOREUMOKnD73E',
      'description':
          'Giày thể thao Nike Air Jordan mang đến sự thanh lịch thể thao, sự thoải mái vượt trội và hiệu suất hàng đầu cho những người đam mê bóng rổ.'
    },
    {
      'productId': '7',
      'title': 'Bán chạy',
      'productname': 'Nike Blazer Mid',
      'imagelink':
          'https://res.cloudinary.com/dgfmiwien/image/upload/v1742225352/sneakers/shoe8_alookg.png',
      'productprice': '304',
      'unitprice': '304',
      'brandId': 's17AsqoNOREUMOKnD73E',
      'description':
          'Nike Blazer Mid kết hợp thiết kế cổ điển, khả năng hỗ trợ mắt cá chân tuyệt vời và chất liệu bền bỉ để mang đến vẻ ngoài thành thị sành điệu.'
    },
    {
      'productId': '8',
      'title': 'Bán chạy',
      'productname': 'Nike Dunk Low',
      'imagelink':
          'https://res.cloudinary.com/dgfmiwien/image/upload/v1742225353/sneakers/shoe9_geolqw.png',
      'productprice': '804',
      'unitprice': '804',
      'brandId': 's17AsqoNOREUMOKnD73E',
      'description':
          'Nike Dunk Low mang đến kiểu dáng thời trang, phần trên bằng da cao cấp và đệm mềm mại mang lại sự thoải mái tối ưu.'
    },
    {
      'productId': '9',
      'title': 'Bán chạy',
      'productname': 'Nike 804',
      'imagelink':
          'https://res.cloudinary.com/dgfmiwien/image/upload/v1742225353/sneakers/shoe10_mjqgj5.png',
      'productprice': '820',
      'unitprice': '820',
      'brandId': 's17AsqoNOREUMOKnD73E',
      'description':
          'Giày thể thao Nike 804 mang lại cảm giác nhẹ, thiết kế hiện đại và độ bám tuyệt vời giúp nâng cao trải nghiệm đi bộ.'
    },
  ];
}
