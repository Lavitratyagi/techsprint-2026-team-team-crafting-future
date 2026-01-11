import 'package:evidex/screens/policy_silumation_screen.dart';
import 'package:flutter/material.dart';
import '../models/policy_model.dart';
import '../services/policy_api_service.dart';

class SimulatorScreen extends StatefulWidget {
  const SimulatorScreen({super.key});

  @override
  State<SimulatorScreen> createState() => _SimulatorScreenState();
}

class _SimulatorScreenState extends State<SimulatorScreen> {
  final List<String> states = ["delhi", "maharashtra", "karnataka"];

  String? selectedState;
  List<PolicyModel> policies = [];
  PolicyModel? selectedPolicy;

  bool loadingPolicies = false;
  bool loadingAnalysis = false;

  Map<String, double>? deltaIndex;
  String? suggestion;

  Future<void> _fetchPolicies(String state) async {
    setState(() {
      loadingPolicies = true;
      policies = [];
      selectedPolicy = null;
      deltaIndex = null;
    });

    try {
      policies = await PolicyApiService.fetchPolicies(state);
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() => loadingPolicies = false);
  }

  Future<void> _sendForAnalysis() async {
    if (selectedPolicy == null || selectedState == null) return;

    setState(() => loadingAnalysis = true);

    try {
      final result = await PolicyApiService.analyzePolicy(
        state: selectedState!,
        policyTitle: selectedPolicy!.title,
        index: selectedPolicy!.pastIndex,
      );

      setState(() {
        deltaIndex = result.deltaIndex;
        suggestion = result.suggestion;
      });
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() => loadingAnalysis = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 12),

              const Text(
                "Get educated about a policy\nof your choice!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 30),

              _stateDropdown(),
              const SizedBox(height: 16),

              Row(
                children: [
                  SizedBox(width: 240, child: _policyDropdown()),
                  const SizedBox(width: 10),
                  _sendButton(),
                ],
              ),

              const SizedBox(height: 24),

              if (loadingAnalysis)
                const CircularProgressIndicator()
              else if (deltaIndex != null && deltaIndex!.isNotEmpty)
                Expanded(child: _indexTable()),

              const SizedBox(height: 12),

              InkWell(
                onTap: () {
                  if (deltaIndex == null) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PolicySimulationScreen(
                        state: selectedState!,
                        policyTitle: selectedPolicy!.title,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Lets simulate and learn!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= DROPDOWNS =================

  Widget _stateDropdown() {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedState,
          hint: const Text("Select state"),
          isExpanded: true,
          items: states
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (v) {
            setState(() => selectedState = v);
            _fetchPolicies(v!);
          },
        ),
      ),
    );
  }

  Widget _policyDropdown() {
    if (loadingPolicies) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<PolicyModel>(
          value: selectedPolicy,
          hint: const Text("Select policy"),
          isExpanded: true,
          items: policies
              .map(
                (p) => DropdownMenuItem(
                  value: p,
                  child: Text(
                    p.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: (v) => setState(() => selectedPolicy = v),
        ),
      ),
    );
  }

  // ================= SEND =================

  Widget _sendButton() {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: selectedPolicy == null
            ? null
            : const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF104684),
                  Color(0xFF0A2B51),
                  Color(0xFF04101E),
                ],
              ),
        color: selectedPolicy == null ? Colors.grey.shade300 : null,
      ),
      child: IconButton(
        icon: const Icon(Icons.send, color: Colors.white),
        onPressed: selectedPolicy == null ? null : _sendForAnalysis,
      ),
    );
  }

  // ================= TABLE =================

  Widget _indexTable() {
    if (deltaIndex == null || deltaIndex!.isEmpty) {
      return const Center(child: Text("No analysis data"));
    }
    final keys = deltaIndex!.keys.toList();

    return SingleChildScrollView(
      child: Table(
        border: TableBorder.all(color: Colors.black),
        columnWidths: const {
          0: FixedColumnWidth(40),
          1: FlexColumnWidth(2),
          2: FixedColumnWidth(80),
          3: FixedColumnWidth(90),
        },
        children: [
          _tableHeader(),
          ...List.generate(
            keys.length,
            (i) => _tableRow(i + 1, keys[i], deltaIndex![keys[i]]!),
          ),
        ],
      ),
    );
  }

  TableRow _tableHeader() {
    return const TableRow(
      decoration: BoxDecoration(color: Color(0xFF1765BE)),
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Text("No.", style: TextStyle(color: Colors.black)),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text("Index Values", style: TextStyle(color: Colors.black)),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text("% Change", style: TextStyle(color: Colors.black)),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text("Analysis", style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  TableRow _tableRow(int no, String key, double delta) {
    final value = delta.toStringAsFixed(2);

    String label;
    Color color;

    if (delta > 5) {
      label = "good";
      color = Colors.green;
    } else if (delta < -5) {
      label = "bad";
      color = Colors.red;
    } else {
      label = "medium";
      color = Colors.orange;
    }

    return TableRow(
      children: [
        Padding(padding: const EdgeInsets.all(8), child: Text("$no")),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(key.replaceAll("_", " ")),
        ),
        Padding(padding: const EdgeInsets.all(8), child: Text("$value%")),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Chip(
            label: Text(label),
            backgroundColor: color.withOpacity(0.15),
            labelStyle: TextStyle(color: color),
          ),
        ),
      ],
    );
  }
}
