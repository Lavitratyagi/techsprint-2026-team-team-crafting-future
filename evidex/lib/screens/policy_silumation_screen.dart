import 'package:flutter/material.dart';
import '../services/policy_api_service.dart';

class PolicySimulationScreen extends StatefulWidget {
  final String state;
  final String policyTitle;

  const PolicySimulationScreen({
    super.key,
    required this.state,
    required this.policyTitle,
  });

  @override
  State<PolicySimulationScreen> createState() =>
      _PolicySimulationScreenState();
}

class _PolicySimulationScreenState extends State<PolicySimulationScreen> {
  bool loading = false;

  Map<String, double>? deltaIndex;
  String? suggestion;

  final Map<String, double> sliders = {
    "civilian_well_being": 50,
    "economic_stability": 50,
    "healthcare_access": 50,
    "food_security": 50,
    "refugee_risk": 50,
    "inflation_pressure": 50,
    "household_cost_stress": 50,
    "supply_chain_stress": 50,
    "currency_stability": 50,
  };

  Future<void> _simulate() async {
    setState(() => loading = true);

    try {
      final result = await PolicyApiService.analyzePolicy(
        state: widget.state,
        policyTitle: widget.policyTitle,
        index: sliders, // 🔥 REAL SIMULATION INPUT
      );

      setState(() {
        deltaIndex = result.deltaIndex;
        suggestion = result.suggestion;
      });
    } catch (e) {
      debugPrint("Simulation error: $e");
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Lets Simulate and Learn"),
        backgroundColor: const Color(0xFF1765BE),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Adjust the sliders as per your preference",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 12),

            /// SLIDERS
            Expanded(
              child: ListView(
                children: sliders.keys.map((key) {
                  return _sliderItem(key);
                }).toList(),
              ),
            ),

            /// SIMULATE BUTTON
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1765BE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: loading ? null : _simulate,
                child: loading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Simulate",
                        style:
                            TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ),

            const SizedBox(height: 16),

            /// RESULT
            if (deltaIndex != null && deltaIndex!.isNotEmpty)
              Expanded(child: _resultTable()),

            if (suggestion != null) _suggestionBox(),
          ],
        ),
      ),
    );
  }

  // ================= SLIDER =================

  Widget _sliderItem(String key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          key.replaceAll("_", " "),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Slider(
          min: 0,
          max: 100,
          divisions: 100,
          value: sliders[key]!,
          label: sliders[key]!.round().toString(),
          activeColor: const Color(0xFF1765BE),
          onChanged: (v) {
            setState(() {
              sliders[key] = v;
            });
          },
        ),
      ],
    );
  }

  // ================= TABLE =================

  Widget _resultTable() {
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
          child: Text("No.", style: TextStyle(color: Colors.white)),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child:
              Text("Index", style: TextStyle(color: Colors.white)),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child:
              Text("% Change", style: TextStyle(color: Colors.white)),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child:
              Text("Analysis", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  TableRow _tableRow(int no, String key, double delta) {
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
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text("${delta.toStringAsFixed(2)}%"),
        ),
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

  // ================= SUGGESTION =================

  Widget _suggestionBox() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        suggestion!,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
