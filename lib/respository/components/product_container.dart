import 'package:ecommerce_app/respository/components/app_styles.dart';
import 'package:flutter/material.dart';

class ProductContainer extends StatelessWidget {
  final String title, subtitle, price;
  final String id;
  final String imagelink;
  final IconButton fav;
  final int quantity;
  const ProductContainer({
    super.key,
    this.title = 'Bán chạy ',
    required this.subtitle,
    required this.imagelink,
    required this.price,
    required this.id,
    required this.quantity,
    required this.fav,
  });

  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    final screenwidht = MediaQuery.of(context).size.width;

    return Container(
      height: screenheight * 0.25,
      width: screenwidht * 0.4,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.all(Radius.circular(16))),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 12,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            fav,
            Image.network(
              imagelink,
              height: 70,
            ),
            Text(
              title,
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: AppColor.backgroundColor),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                  fontFamily: 'Raleway-Medium',
                  fontSize: 15,
                  color: Colors.black),
            ),
            Text(
              price,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.blue,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///
class CartContainer extends StatelessWidget {
  final String imagelink;
  final String title;
  final String subtitle;
  final String price;

  const CartContainer({
    super.key,
    required this.imagelink,
    required this.price,
    required this.subtitle,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;

    return Container(
      height: 330,
      width: screenwidth * 0.1,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.all(Radius.circular(16))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imagelink,
              height: 90,
            ),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: AppColor.backgroundColor,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontFamily: 'Raleway-Medium',
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            Text(
              price,
              style: const TextStyle(
                  fontFamily: 'Poppins', fontSize: 12, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class ShowProductContainer extends StatelessWidget {
  final String title, subtitle, price;
  final String imagelink;
  final IconButton fav;
  final int quantity;
  final VoidCallback onclick;

  const ShowProductContainer(
      {super.key,
      this.title = 'Bán chạy ',
      required this.subtitle,
      required this.imagelink,
      required this.price,
      required this.quantity,
      required this.fav,
      required this.onclick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onclick,
      child: Container(
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
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Image.network(
                              imagelink,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
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
                      child: fav,
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
                            subtitle,
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
                            title,
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
                            price,
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
