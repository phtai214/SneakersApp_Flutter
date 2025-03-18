import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/respository/components/product_container.dart';
import 'package:ecommerce_app/respository/components/route_names.dart';
import 'package:ecommerce_app/utils/fav_provider.dart';
import 'package:ecommerce_app/view/home/product_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowProducts extends StatefulWidget {
  const ShowProducts({super.key});

  @override
  State<ShowProducts> createState() => _ShowProductsState();
}

class _ShowProductsState extends State<ShowProducts> {
  final db2 = FirebaseFirestore.instance.collection('Favourites');
  final id = FirebaseAuth.instance.currentUser!.uid.toString();

  List<Map<String, dynamic>> products = [];

  initData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference productsCollection = firestore.collection('products');
    try {
      QuerySnapshot querySnapshot = await productsCollection.get();
      products = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      setState(() {});
    } catch (e) {
      print("Error fetching products: \$e");
    }
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final favprovider = Provider.of<FavouriteProvider>(context);
    return Scaffold(
      backgroundColor: Color(0xfff7f7f9),
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pushNamed(context, RouteNames.navbarscreen);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
        title: const Text('Tất cả sản phẩm'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ShowProductContainer(
              subtitle: products[index]['productname'],
              imagelink: products[index]['imagelink'],
              price: r'$' + products[index]['productprice'],
              id: products[index]['productId'],
              quantity: 0,
              fav: IconButton(
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
                          .set({
                        'product id': products[index]['productId'].toString(),
                        'name': products[index]['productname'].toString(),
                        'subtitle': products[index]['title'].toString(),
                        'image': products[index]['imagelink'].toString(),
                        'price': products[index]['productprice'].toString(),
                        'description':
                            products[index]['description'].toString(),
                      });
                    }
                  },
                  icon: Icon(
                    favprovider.items.contains(products[index]['productId'])
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                    color: Colors.red,
                  )),
              onclick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ProductDetails(
                      title: products[index]['productname'],
                      price: products[index]['productprice'],
                      productid: products[index]['productId'],
                      unitprice: products[index]['unitprice'],
                      image: products[index]['imagelink'],
                      description: products[index]['description'],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
