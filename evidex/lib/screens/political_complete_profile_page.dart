import 'package:evidex/screens/floating_bottom_nav.dart';
import 'package:evidex/screens/home_screen.dart';
import 'package:flutter/material.dart';

class PoliticalCompleteProfilePage extends StatefulWidget {
  const PoliticalCompleteProfilePage({super.key});

  @override
  State<PoliticalCompleteProfilePage> createState() =>
      _PoliticalCompleteProfilePageState();
}

class _PoliticalCompleteProfilePageState
    extends State<PoliticalCompleteProfilePage> {
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

          /// TOP IMAGE
          Positioned(
            top: screenHeight * 0.09,
            left: 28,
            right: 28,
            child: Center(
              child: Image.asset('assets/login_bg.png', fit: BoxFit.contain),
            ),
          ),

          /// DRAGGABLE WHITE SHEET
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
                        /// DRAG HANDLE
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

                        /// TITLE
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

                        /// STATE
                        const Text(
                          "State",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        _inputField(hint: "Uttar Pradesh", icon: Icons.map),

                        const SizedBox(height: 18),

                        /// PARTY NAME
                        const Text(
                          "Party Name",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        _inputField(hint: "XYZ Party", icon: Icons.flag),

                        const SizedBox(height: 18),

                        /// POSITION
                        const Text(
                          "Position",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        _inputField(hint: "Chief Minister", icon: Icons.work),

                        const SizedBox(height: 18),

                        /// CANDIDATE ID
                        const Text(
                          "Candidate ID",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        _inputField(hint: "CAND001", icon: Icons.badge),

                        const SizedBox(height: 26),

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

  /// INPUT FIELD WITH SHADOW (NO BORDER)
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
