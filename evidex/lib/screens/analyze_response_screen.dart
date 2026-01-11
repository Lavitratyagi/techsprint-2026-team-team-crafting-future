import 'package:flutter/material.dart';
import '../services/analyze_api_service.dart';

class AnalyzeResponseScreen extends StatefulWidget {
  final String state;
  final String policy;

  const AnalyzeResponseScreen({
    super.key,
    required this.state,
    required this.policy,
  });

  @override
  State<AnalyzeResponseScreen> createState() =>
      _AnalyzeResponseScreenState();
}

class _AnalyzeResponseScreenState extends State<AnalyzeResponseScreen> {
  final TextEditingController inputController = TextEditingController();

  String selectedLens = "Humantarian";
  String responseText = "Ask a question to begin analysis...";

  bool loading = false;

  final List<String> chatHistory = [];

  final List<String> lenses = [
    "Humantarian",
    "Finance",
    "Healthcare",
    "Infrastructural",
  ];

  Future<void> _sendQuery() async {
    final query = inputController.text.trim();
    if (query.isEmpty) return;

    setState(() => loading = true);

    try {
      final result = await AnalyzeApiService.analyzePolicy(
        lens: selectedLens,
        state: widget.state,
        policy: widget.policy,
        chatHistory: chatHistory,
        query: query,
      );

      setState(() {
        responseText = result;

        /// maintain only last 3 responses
        chatHistory.add(result);
        if (chatHistory.length > 3) {
          chatHistory.removeAt(0);
        }
      });

      inputController.clear();
    } catch (e) {
      debugPrint("Analyze error: $e");
    }

    setState(() => loading = false);
  }

  void _showLensPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          children: lenses.map((lens) {
            return ListTile(
              title: Text(lens),
              onTap: () {
                setState(() => selectedLens = lens);
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF1765BE);

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
                children: const [
                  Icon(Icons.verified,
                      color: primaryBlue, size: 18),
                  SizedBox(width: 6),
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
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// SELECTED LENS
              Text(
                "Lens: $selectedLens",
                style: const TextStyle(
                    fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 12),

              /// RESPONSE CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFCFE3F3),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Text(
                        responseText,
                        style: const TextStyle(fontSize: 14),
                      ),
              ),

              const Spacer(),

              /// INPUT + ACTIONS
              Row(
                children: [
                  /// PLUS BUTTON
                  Container(
                    width: 46,
                    height: 46,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF1765BE),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add,
                          color: Colors.white),
                      onPressed: _showLensPicker,
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// INPUT
                  Expanded(
                    child: Container(
                      height: 46,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey.shade400),
                        borderRadius:
                            BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: inputController,
                        decoration: const InputDecoration(
                          hintText: "Write something ...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// SEND
                  Container(
                    width: 46,
                    height: 46,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF0B2F58),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send,
                          color: Colors.white),
                      onPressed: loading ? null : _sendQuery,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
