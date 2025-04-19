import 'package:ecommerce_app/respository/components/app_styles.dart';
import 'package:ecommerce_app/respository/components/round_button.dart';
import 'package:ecommerce_app/respository/components/route_names.dart';
import 'package:flutter/material.dart';

class ScreenFour extends StatelessWidget {
  const ScreenFour({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      child: Scaffold(
          backgroundColor: AppColor.backgroundColor,
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: EdgeInsets.only(top: screenHeight * .56),
                child: const Column(
                  children: [
                    Center(
                        child: Text(
                      "Bắt kịp xu hướng",
                      style: TextStyle(
                          fontFamily: 'Raleway-Bold',
                          fontSize: 34,
                          color: Color(
                            0xffECECEC,
                          ),
                          fontWeight: FontWeight.bold),
                    )),
                    Center(
                        child: Text(
                      "giày mới nhất",
                      style: TextStyle(
                          fontFamily: 'Raleway-Bold',
                          fontSize: 34,
                          color: Color(
                            0xffECECEC,
                          ),
                          fontWeight: FontWeight.bold),
                    )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: screenHeight * .70),
                child: const Column(
                  children: [
                    Center(
                        child: Text(
                      "Nhiều mẫu giày đẹp và cuốn hút",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Color(
                          0xffECECEC,
                        ),
                      ),
                    )),
                    Center(
                        child: Text(
                      " cho bạn tha hồ chọn lựa 👟🔥",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Color(
                          0xffECECEC,
                        ),
                      ),
                    )),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * .55, right: screenWidth * .1),
                  child: const Align(
                      alignment: Alignment.topRight,
                      child: Image(
                          image: AssetImage(
                        'images/Vector2.png',
                      )))),
              Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.34),
                child: const Align(
                  alignment: Alignment.center,
                  child: Image(
                    image: AssetImage(
                      'images/sneakers2.png',
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: screenHeight * .78),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 42, height: 5, color: const Color(0xffFFB21A)),
                      const SizedBox(
                        width: 7,
                      ),
                      Container(
                          width: 28, height: 5, color: const Color(0xffFFB21A)),
                      const SizedBox(
                        width: 7,
                      ),
                      Container(
                        width: 28,
                        height: 5,
                        color: const Color(0xffFFB21A),
                      ),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * .15, right: screenWidth * .7),
                  child: const Align(
                      alignment: Alignment.topRight,
                      child: Image(
                          image: AssetImage(
                        'images/smiley2.png',
                      )))),
              Padding(
                padding: EdgeInsets.only(top: screenHeight * .90),
                child: RoundButtonOne(
                    onpress: () {
                      Navigator.pushNamed(context, RouteNames.loginScreen);
                    },
                    title: 'Tiếp theo'),
              ),
            ],
          )),
    );
  }
}
