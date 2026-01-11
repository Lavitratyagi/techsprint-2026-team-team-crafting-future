import 'package:evidex/screens/signup_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = true;
  bool hidePassword = true;

  final Color primaryBlue = const Color(0xFF1765BE);
  final Color hintTextColor = const Color(0xFF9DC6DF);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          /// BACKGROUND GRADIENT
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1765BE), Color(0xFFFFFFFF)],
              ),
            ),
          ),

          Positioned(
            top: 64,
            left: 0,
            right: 0,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Image.asset(
                  'assets/login_bg.png',
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          /// WHITE BOTTOM SHEET
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Sign in to your account",
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 28),

                    const Text("Email Address"),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "you@example.com",
                        hintStyle: TextStyle(color: hintTextColor),
                        prefixIcon: Icon(Icons.email, color: primaryBlue),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryBlue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: primaryBlue,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text("Password"),
                    const SizedBox(height: 8),
                    TextField(
                      obscureText: hidePassword,
                      decoration: InputDecoration(
                        hintText: "••••••••",
                        hintStyle: TextStyle(color: hintTextColor),
                        prefixIcon: Icon(Icons.lock, color: primaryBlue),
                        suffixIcon: IconButton(
                          icon: Icon(
                            hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: primaryBlue,
                          ),
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryBlue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: primaryBlue,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          activeColor: primaryBlue,
                          onChanged: (v) {
                            setState(() => rememberMe = v!);
                          },
                        ),
                        const Text("Remember me"),
                        const Spacer(),
                        Text(
                          "Forgot password?",
                          style: TextStyle(color: primaryBlue),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Sign In",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: const TextStyle(color: Colors.grey),
                          children: [
                            TextSpan(
                              text: "Sign up",
                              style: TextStyle(
                                color: primaryBlue,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignupPage(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
