import 'package:evidex/screens/analyze_response_screen.dart';
import 'package:flutter/material.dart';

class AnalyzePolicyInputScreen extends StatelessWidget {
  final String selectedState;
  const AnalyzePolicyInputScreen({super.key, required this.selectedState});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF1765BE);
    const Color darkBlue = Color(0xFF0A2B51);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.verified, color: primaryBlue, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    "Evidex",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// MENU + GREETING
              Row(
                children: const [
                  Icon(Icons.menu, size: 22),
                  SizedBox(width: 10),
                  Text(
                    "Greetings!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const Spacer(),

              /// CENTER CONTENT
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// MAIN TEXT
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(fontSize: 24, color: Colors.black),
                      children: [
                        TextSpan(text: "Let's do a "),
                        TextSpan(
                          text: "ground reality\ncheck",
                          style: TextStyle(
                            color: primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: " for your policy"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        height: 46,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: "Explain your policy..",
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Container(
                        width: 46,
                        height: 46,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF104684),
                              Color(0xFF0A2B51),
                              Color(0xFF04101E),
                            ],
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  final TextEditingController policyController =
                                      TextEditingController();
                                  return AnalyzeResponseScreen(
                                    state: selectedState,
                                    policy: policyController.text,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
