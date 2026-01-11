import 'package:evidex/screens/floating_bottom_nav.dart';
import 'package:evidex/screens/home_screen.dart';
import 'package:flutter/material.dart';

class NgoCompleteProfilePage extends StatefulWidget {
  const NgoCompleteProfilePage({super.key});

  @override
  State<NgoCompleteProfilePage> createState() => _NgoCompleteProfilePageState();
}

class _NgoCompleteProfilePageState extends State<NgoCompleteProfilePage> {
  final Color primaryBlue = const Color(0xFF1765BE);
  final Color hintTextColor = const Color(0xFF9DC6DF);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
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
            top: screenHeight * 0.09,
            left: 28,
            right: 28,
            child: Center(
              child: Image.asset('assets/login_bg.png', fit: BoxFit.contain),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),

                        const Text(
                          "Complete your profile",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Enter more details for verification",
                          style: TextStyle(color: Colors.grey),
                        ),

                        const SizedBox(height: 22),

                        const Text(
                          "NGO Name",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        _inputField(hint: "NGO Name", icon: Icons.apartment),

                        const SizedBox(height: 18),

                        const Text(
                          "NGO ID",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        _inputField(
                          hint: "Your NGO Administration ID",
                          icon: Icons.badge,
                        ),

                        const SizedBox(height: 18),

                        const Text(
                          "Address",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        _inputField(
                          hint: "XYZFFDVDDVe",
                          icon: Icons.location_on,
                        ),

                        const SizedBox(height: 18),

                        const Text(
                          "Your NGO ID/No.",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        _inputField(
                          hint: "Employee ID",
                          icon: Icons.confirmation_number,
                        ),

                        const SizedBox(height: 26),

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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const FloatingBottomNav(),
                                ),
                              );
                            },
                            child: const Text(
                              "Create Account",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField({required String hint, required IconData icon}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
}
