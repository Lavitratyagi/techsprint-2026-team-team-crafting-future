import 'package:evidex/screens/analyze_policy_input_screen.dart';
import 'package:flutter/material.dart';

class AnalyzeScreen extends StatefulWidget {
  const AnalyzeScreen({super.key});

  @override
  State<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyzeScreen> {
  String? selectedState;

  final Color primaryBlue = const Color(0xFF1765BE);

  final List<String> states = [
    "Uttar Pradesh",
    "Delhi",
    "Maharashtra",
    "Karnataka",
    "Tamil Nadu",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TOP BRAND
              Row(
                children: [
                  Icon(Icons.verified, color: primaryBlue, size: 24),
                  const SizedBox(width: 6),
                  Text(
                    "Evidex",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: const [
                  Icon(Icons.menu, size: 24),
                  SizedBox(width: 10),
                  Text(
                    "Greetings!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                    text: TextSpan(
                      style: const TextStyle(fontSize: 24, color: Colors.black),
                      children: [
                        const TextSpan(text: "Let's do a "),
                        TextSpan(
                          text: "ground reality\ncheck",
                          style: TextStyle(
                            color: primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: " for your policy"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// SELECT STATE ROW
                  /// SELECT STATE ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Select a state:",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 42,
                        width: 150,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade600),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedState,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: states
                                .map(
                                  (state) => DropdownMenuItem(
                                    value: state,
                                    child: Text(state),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedState = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: 180,
                    height: 48,
                    child: GestureDetector(
                      onTap: selectedState == null
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AnalyzePolicyInputScreen(
                                        selectedState: selectedState!,
                                      ),
                                ),
                              );
                            },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF04101E),
                              Color(0xFF0A2B51),
                              Color(0xFF104684),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Continue",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
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
