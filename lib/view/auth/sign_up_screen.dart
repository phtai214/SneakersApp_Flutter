import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/respository/components/app_styles.dart';
import 'package:ecommerce_app/respository/components/route_names.dart';
import 'package:ecommerce_app/utils/general_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with SingleTickerProviderStateMixin {
  final emailcontroller = TextEditingController();
  final namecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final ValueNotifier<bool> _obsecurepassword = ValueNotifier<bool>(true);

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimationLogo;
  late Animation<double> _fadeAnimationTitle;
  late Animation<double> _fadeAnimationSubtitle;
  late Animation<double> _fadeAnimationName;
  late Animation<double> _fadeAnimationEmail;
  late Animation<double> _fadeAnimationPassword;
  late Animation<double> _fadeAnimationButton;

  FirebaseAuth authenticate = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance.collection('User Data');

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _fadeAnimationLogo = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _fadeAnimationTitle = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.4, curve: Curves.easeIn),
      ),
    );

    _fadeAnimationSubtitle = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.5, curve: Curves.easeIn),
      ),
    );

    _fadeAnimationName = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 0.6, curve: Curves.easeIn),
      ),
    );

    _fadeAnimationEmail = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 0.7, curve: Curves.easeIn),
      ),
    );

    _fadeAnimationPassword = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.6, 0.8, curve: Curves.easeIn),
      ),
    );

    _fadeAnimationButton = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.7, 0.9, curve: Curves.easeIn),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailcontroller.dispose();
    namecontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pushNamed(context, RouteNames.loginScreen);
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
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: FadeTransition(
                      opacity: _fadeAnimationLogo,
                      child: Container(
                        height: screenheight * 0.12,
                        width: screenwidth * 0.3,
                        margin: EdgeInsets.only(top: screenheight * 0.02),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/logo.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenheight * 0.02),
                  Center(
                    child: FadeTransition(
                      opacity: _fadeAnimationTitle,
                      child: const Text(
                        'Tạo Tài Khoản',
                        style: TextStyle(
                          fontFamily: 'Raleway-Bold',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff2B2B2B),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenheight * 0.01),
                  Center(
                    child: FadeTransition(
                      opacity: _fadeAnimationSubtitle,
                      child: const Text(
                        'Hãy cùng nhau tạo tài khoản',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          color: Color(0xff707B81),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenheight * 0.04),
                  FadeTransition(
                    opacity: _fadeAnimationName,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            'Tên của bạn',
                            style: TextStyle(
                              fontFamily: 'Raleway-Medium',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff2B2B2B),
                            ),
                          ),
                        ),
                        SizedBox(height: screenheight * 0.01),
                        Container(
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
                            controller: namecontroller,
                            decoration: InputDecoration(
                              hintText: 'Nhập Họ Tên',
                              hintStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Color(0xff6A6A6A),
                              ),
                              prefixIcon: const Icon(
                                Icons.person_outline,
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
                      ],
                    ),
                  ),
                  SizedBox(height: screenheight * 0.025),
                  FadeTransition(
                    opacity: _fadeAnimationEmail,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            'Địa chỉ Email',
                            style: TextStyle(
                              fontFamily: 'Raleway-Medium',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff2B2B2B),
                            ),
                          ),
                        ),
                        SizedBox(height: screenheight * 0.01),
                        Container(
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
                            controller: emailcontroller,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'xyz@gmail.com',
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
                      ],
                    ),
                  ),
                  SizedBox(height: screenheight * 0.025),
                  FadeTransition(
                    opacity: _fadeAnimationPassword,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            'Mật khẩu',
                            style: TextStyle(
                              fontFamily: 'Raleway-Medium',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff2B2B2B),
                            ),
                          ),
                        ),
                        SizedBox(height: screenheight * 0.01),
                        ValueListenableBuilder(
                          valueListenable: _obsecurepassword,
                          builder: (context, value, child) {
                            return Container(
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
                                obscureText: _obsecurepassword.value,
                                controller: passwordcontroller,
                                decoration: InputDecoration(
                                  hintText: 'Nhập mật khẩu',
                                  hintStyle: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    color: Color(0xff6A6A6A),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.lock_outline_rounded,
                                    color: AppColor.backgroundColor,
                                  ),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      _obsecurepassword.value = !_obsecurepassword.value;
                                    },
                                    child: Icon(
                                      _obsecurepassword.value
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: AppColor.backgroundColor,
                                    ),
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
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenheight * 0.04),
                  FadeTransition(
                    opacity: _fadeAnimationButton,
                    child: Consumer<GeneralUtils>(
                      builder: ((context, value1, child) {
                        return Container(
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
                                    if (namecontroller.text.trim().isEmpty) {
                                      value1.showerrorflushbar('Vui lòng nhập họ và tên', context);
                                      return;
                                    }

                                    if (emailcontroller.text.trim().isEmpty) {
                                      value1.showerrorflushbar('Vui lòng nhập email', context);
                                      return;
                                    }

                                    if (passwordcontroller.text.trim().isEmpty) {
                                      value1.showerrorflushbar('Vui lòng nhập mật khẩu', context);
                                      return;
                                    }

                                    if (passwordcontroller.text.length < 6) {
                                      value1.showerrorflushbar('Mật khẩu phải có ít nhất 6 ký tự', context);
                                      return;
                                    }

                                    value1.showloading(true);
                                    await authenticate
                                        .createUserWithEmailAndPassword(
                                            email: emailcontroller.text.toString(),
                                            password: passwordcontroller.text.toString())
                                        .then((value) {
                                      final userid = authenticate.currentUser!.uid.toString();
                                      db.doc(userid).set({
                                        'id': userid,
                                        'Full name': namecontroller.text.toString(),
                                        'Email': emailcontroller.text.toString(),
                                        'image': '',
                                        'address': '',
                                      });
                                      value1.showloading(false);

                                      value1.showsuccessflushbar('Đăng ký thành công!', context);
                                      Navigator.pushNamed(context, RouteNames.loginScreen);
                                    }).onError((error, stackTrace) {
                                      value1.showloading(false);
                                      value1.showerrorflushbar(error.toString(), context);
                                    });
                                  },
                            child: value1.load
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    'Đăng Ký',
                                    style: TextStyle(
                                      fontFamily: 'Raleway-SemiBold',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: screenheight * 0.02),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Hoặc',
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Raleway-Medium',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenheight * 0.02),
                  Consumer<GeneralUtils>(
                    builder: (context, value1, child) {
                      return InkWell(
                        onTap: () {
                          value1.signInWithGoogle().then((value) {
                            db.doc(value1.id).set({
                              'id': value1.id,
                              'Full name': value1.name,
                              'Email': value1.email,
                              'image': '',
                            }).onError(
                              (error, stackTrace) => GeneralUtils()
                                  .showerrorflushbar(error.toString(), context),
                            );
                            Navigator.pushNamed(context, RouteNames.navbarscreen);
                          }).onError((error, stackTrace) {
                            value1.showerrorflushbar(
                              error.toString(),
                              context,
                            );
                          });
                        },
                        child: Container(
                          height: 55,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'images/googlelogo.png',
                                height: 24,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Đăng nhập với Google',
                                style: TextStyle(
                                  fontFamily: 'Raleway-SemiBold',
                                  color: Color(0xff2B2B2B),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: screenheight * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Bạn đã có tài khoản?',
                        style: TextStyle(
                          fontFamily: 'Raleway-Medium',
                          fontSize: 13,
                          color: Color(0xff6A6A6A),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RouteNames.loginScreen);
                        },
                        style: TextButton.styleFrom(
                          minimumSize: Size(0, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.only(left: 5),
                        ),
                        child: Text(
                          'Đăng nhập',
                          style: TextStyle(
                            fontFamily: 'Raleway-Bold',
                            fontSize: 13,
                            color: AppColor.backgroundColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenheight * 0.02),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
