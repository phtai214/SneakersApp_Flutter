import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/respository/components/app_styles.dart';
import 'package:ecommerce_app/respository/components/route_names.dart';
import 'package:ecommerce_app/utils/general_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final ValueNotifier<bool> _obsecurepassword = ValueNotifier<bool>(true);
  
  // Animation controllers and animations
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  // Staggered animations timing
  late Animation<double> _logoAnimation;
  late Animation<double> _titleAnimation;
  late Animation<double> _emailFieldAnimation;
  late Animation<double> _passwordFieldAnimation;
  late Animation<double> _loginButtonAnimation;
  late Animation<double> _forgotPasswordAnimation;
  late Animation<double> _dividerAnimation;
  late Animation<double> _googleButtonAnimation;
  late Animation<double> _signUpPromptAnimation;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance.collection('User Data');

  @override
  void initState() {
    super.initState();
    // Setup main animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    // Setup basic animations
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutQuint,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    // Setup staggered animations with different delays
    _logoAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    );
    
    _titleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
    );
    
    _emailFieldAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
    );
    
    _passwordFieldAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
    );
    
    _forgotPasswordAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.5, 0.9, curve: Curves.easeOut),
    );
    
    _loginButtonAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    );
    
    _dividerAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
    );
    
    _googleButtonAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.8, 1.0, curve: Curves.easeOut),
    );
    
    _signUpPromptAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.9, 1.0, curve: Curves.easeOut),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenwidth * 0.06),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo animation
                Center(
                  child: FadeTransition(
                    opacity: _logoAnimation,
                    child: ScaleTransition(
                      scale: _logoAnimation,
                      child: Container(
                        height: screenheight * 0.15,
                        width: screenwidth * 0.4,
                        margin: EdgeInsets.only(top: screenheight * 0.03),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/logo.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenheight * 0.02),
                
                // Title animations
                Center(
                  child: FadeTransition(
                    opacity: _titleAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(_titleAnimation),
                      child: Text(
                        'Xin chào!',
                        style: TextStyle(
                          fontFamily: 'Raleway-Bold',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff2B2B2B),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenheight * 0.01),
                
                Center(
                  child: FadeTransition(
                    opacity: _titleAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(_titleAnimation),
                      child: Text(
                        'Chào mừng bạn trở lại, chúng tôi nhớ bạn lắm!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          color: const Color(0xff707B81),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenheight * 0.04),
                
                // Email field animation
                FadeTransition(
                  opacity: _emailFieldAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.3, 0),
                      end: Offset.zero,
                    ).animate(_emailFieldAnimation),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            'Email của bạn',
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
                              hintStyle: TextStyle(
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
                ),
                SizedBox(height: screenheight * 0.025),
                
                // Password field animation
                FadeTransition(
                  opacity: _passwordFieldAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.3, 0),
                      end: Offset.zero,
                    ).animate(_passwordFieldAnimation),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            'Mật Khẩu',
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
                                  hintStyle: TextStyle(
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
                ),
                
                // Forgot password animation
                FadeTransition(
                  opacity: _forgotPasswordAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.3, 0),
                      end: Offset.zero,
                    ).animate(_forgotPasswordAnimation),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RouteNames.forgotPasswordScreen);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Quên mật khẩu',
                          style: TextStyle(
                            fontFamily: 'Raleway-Medium',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColor.backgroundColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenheight * 0.02),
                
                // Login button animation
                FadeTransition(
                  opacity: _loginButtonAnimation,
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.95,
                      end: 1.0,
                    ).animate(_loginButtonAnimation),
                    child: Consumer<GeneralUtils>(
                      builder: ((context, value1, child) {
                        return Container(
                          width: double.infinity,
                          height: 55,
                          margin: EdgeInsets.only(top: screenheight * 0.01),
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
                                    if (emailcontroller.text == "admin@gmail.com" &&
                                        passwordcontroller.text == "admin") {
                                      Navigator.pushNamed(
                                          context, RouteNames.adminHomeScreen);
                                      return;
                                    }
                                    value1.showloading(true);
                                    await auth
                                        .signInWithEmailAndPassword(
                                            email: emailcontroller.text.toString(),
                                            password: passwordcontroller.text.toString())
                                        .then((value) {
                                      value1.showsuccessflushbar(
                                        'Đăng nhập thành công',
                                        context,
                                      );

                                      Navigator.pushNamed(context, RouteNames.navbarscreen);
                                      value1.showloading(false);
                                    }).onError((error, stackTrace) {
                                      value1.showerrorflushbar(error.toString(), context);
                                      value1.showloading(false);
                                    });
                                  },
                            child: value1.load
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    'Đăng Nhập',
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
                ),
                SizedBox(height: screenheight * 0.02),
                
                // Divider animation
                FadeTransition(
                  opacity: _dividerAnimation,
                  child: Row(
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
                ),
                SizedBox(height: screenheight * 0.02),
                
                // Google button animation
                FadeTransition(
                  opacity: _googleButtonAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(_googleButtonAnimation),
                    child: Consumer<GeneralUtils>(
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
                  ),
                ),
                SizedBox(height: screenheight * 0.03),
                
                // Sign-up prompt animation
                FadeTransition(
                  opacity: _signUpPromptAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(_signUpPromptAnimation),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Bạn chưa có tài khoản?',
                          style: TextStyle(
                            fontFamily: 'Raleway-Medium',
                            fontSize: 13,
                            color: Color(0xff6A6A6A),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, RouteNames.signUpScreen);
                          },
                          style: TextButton.styleFrom(
                            minimumSize: Size(0, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.only(left: 5),
                          ),
                          child: Text(
                            'Đăng ký miễn phí',
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
                  ),
                ),
                SizedBox(height: screenheight * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
