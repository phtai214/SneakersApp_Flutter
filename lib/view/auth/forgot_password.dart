import 'package:ecommerce_app/respository/components/app_styles.dart';
import 'package:ecommerce_app/respository/components/route_names.dart';
import 'package:ecommerce_app/utils/general_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> with SingleTickerProviderStateMixin {
  final forgotpasswordcontroller = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _imageAnimation;
  late Animation<double> _titleAnimation;
  late Animation<double> _subtitleAnimation;
  late Animation<double> _fieldAnimation;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _imageAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _titleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
      ),
    );

    _subtitleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );

    _fieldAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
      ),
    );

    _buttonAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    // Start the animation when the screen loads
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    forgotpasswordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    final auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pushNamed(context, RouteNames.pageViewScreen);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColor.backgroundColor,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenwidth * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenheight * 0.03),
              // Image with animation
              FadeTransition(
                opacity: _imageAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(_imageAnimation),
                  child: Center(
                    child: Container(
                      height: screenheight * 0.2,
                      width: screenwidth * 0.5,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/forgot_password.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenheight * 0.03),
              // Heading with animation
              FadeTransition(
                opacity: _titleAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(_titleAnimation),
                  child: const Center(
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                        fontFamily: 'Raleway-Bold',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff2B2B2B),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenheight * 0.02),
              // Subheading with animation
              FadeTransition(
                opacity: _subtitleAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(_subtitleAnimation),
                  child: const Center(
                    child: Text(
                      'Enter your email address to reset your password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Color(0xff707B81),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenheight * 0.05),
              // Input field with animation
              FadeTransition(
                opacity: _fieldAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(_fieldAnimation),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffF7F7F9),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: forgotpasswordcontroller,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email Address',
                        hintStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Color(0xff6A6A6A),
                        ),
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: AppColor.backgroundColor,
                        ),
                        filled: true,
                        fillColor: const Color(0xffF7F7F9),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Consumer<GeneralUtils>(builder: ((context, value1, child) {
                return FadeTransition(
                  opacity: _buttonAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(_buttonAnimation),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: screenheight * 0.08),
                        child: Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.backgroundColor.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.backgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 0,
                            ),
                            onPressed: value1.load
                                ? null
                                : () async {
                                    if (forgotpasswordcontroller.text.trim().isEmpty) {
                                      value1.showerrorflushbar('Please enter your email address', context);
                                      return;
                                    }

                                    value1.showloading(true);
                                    await auth
                                        .sendPasswordResetEmail(
                                            email: forgotpasswordcontroller.text.toString())
                                        .then((value) {
                                      value1.showloading(false);

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            elevation: 0,
                                            backgroundColor: Colors.transparent,
                                            child: Container(
                                              padding: const EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.1),
                                                    blurRadius: 10,
                                                    offset: const Offset(0, 10),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    height: 70,
                                                    width: 70,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: AppColor.backgroundColor.withOpacity(0.1),
                                                    ),
                                                    child: Center(
                                                      child: Container(
                                                        height: 50,
                                                        width: 50,
                                                        decoration: const BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: AppColor.backgroundColor,
                                                        ),
                                                        child: const Icon(
                                                          Icons.email_outlined,
                                                          color: Colors.white,
                                                          size: 25,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  const Text(
                                                    'Check Your Email',
                                                    style: TextStyle(
                                                      fontFamily: 'Raleway-Bold',
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xff2B2B2B),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 15),
                                                  const Text(
                                                    'We have sent a password recovery link to your email address',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 14,
                                                      color: Color(0xff707B81),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: AppColor.backgroundColor,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(30),
                                                      ),
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 30,
                                                        vertical: 10,
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      'OK',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontFamily: 'Raleway-SemiBold',
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }).onError((error, stackTrace) {
                                      value1.showloading(false);
                                      value1.showerrorflushbar(error.toString(), context);
                                    });
                                  },
                            child: value1.load
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    'Reset Password',
                                    style: TextStyle(
                                      fontFamily: 'Raleway-SemiBold',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              })),
              SizedBox(height: screenheight * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
