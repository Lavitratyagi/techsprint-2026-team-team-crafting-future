import 'package:evidex/screens/ngo_complete_profile_page.dart';
import 'package:evidex/screens/political_complete_profile_page.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool hidePassword = true;

  String selectedRole = "role";
  String selectedNationality = "nationality";

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
            top: screenHeight * 0.06,
            left: 28,
            right: 28,
            child: Center(
              child: Image.asset('assets/login_bg.png', fit: BoxFit.contain),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 14),
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
                      "Setup your account",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "create account",
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 16),

                    /// ROLE + NATIONALITY
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _dropdown(
                          value: selectedRole,
                          items: const ["role", "user", "ngo", "political"],
                          onChanged: (v) => setState(() => selectedRole = v!),
                        ),
                        const SizedBox(width: 12),
                        _dropdown(
                          value: selectedNationality,
                          items: const ["nationality", "Indian", "Other"],
                          onChanged: (v) =>
                              setState(() => selectedNationality = v!),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    /// FULL NAME
                    const Text(
                      "Full name",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _inputField(hint: "Full name", icon: Icons.person),

                    const SizedBox(height: 18),

                    /// EMAIL
                    const Text(
                      "Email Address",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _inputField(hint: "you@example.com", icon: Icons.email),

                    const SizedBox(height: 18),

                    /// PASSWORD
                    const Text(
                      "Password",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _passwordField(),

                    const SizedBox(height: 24),

                    /// CREATE ACCOUNT BUTTON
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
                        onPressed: () {
                          if (selectedRole == "ngo") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const NgoCompleteProfilePage(),
                              ),
                            );
                          } else if (selectedRole == "political") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PoliticalCompleteProfilePage(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Role selected: $selectedRole"),
                              ),
                            );
                          }
                        },

                        child: const Text(
                          "Create Account",
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// INPUT FIELD WITH SHADOW
  Widget _inputField({required String hint, required IconData icon}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF5B5B5B).withOpacity(0.33)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: hintTextColor),
          prefixIcon: Icon(icon, color: primaryBlue),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  /// PASSWORD FIELD
  Widget _passwordField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF5B5B5B).withOpacity(0.33)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        obscureText: hidePassword,
        decoration: InputDecoration(
          hintText: "••••••••",
          hintStyle: TextStyle(color: hintTextColor),
          prefixIcon: Icon(Icons.lock, color: primaryBlue),
          suffixIcon: IconButton(
            icon: Icon(
              hidePassword ? Icons.visibility_off : Icons.visibility,
              color: primaryBlue,
            ),
            onPressed: () => setState(() => hidePassword = !hidePassword),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  /// DROPDOWN CHIP
  Widget _dropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 30,
      decoration: BoxDecoration(
        border: Border.all(color: primaryBlue),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: Icon(Icons.keyboard_arrow_down, color: primaryBlue, size: 18),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: const TextStyle(fontSize: 12)),
                ),
              )
              .toList(),
          onChanged: onChanged,
          isDense: true,
        ),
      ),
    );
  }
}
