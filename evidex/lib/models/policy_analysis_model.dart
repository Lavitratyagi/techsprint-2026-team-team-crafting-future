class PolicyAnalysisModel {
  final Map<String, double> deltaIndex;
  final String suggestion;
  final bool goodChanges;

  PolicyAnalysisModel({
    required this.deltaIndex,
    required this.suggestion,
    required this.goodChanges,
  });

  factory PolicyAnalysisModel.fromJson(Map<String, dynamic> json) {
    final rawDelta = json['delta_index'];

    // ✅ SAFE PARSING
    final Map<String, double> parsedDelta =
        rawDelta is Map<String, dynamic>
            ? rawDelta.map(
                (k, v) => MapEntry(k, (v as num).toDouble()),
              )
            : {};

    return PolicyAnalysisModel(
      deltaIndex: parsedDelta,
      suggestion: json['suggestion']?.toString() ?? "",
      goodChanges: json['good_changes'] ?? false,
    );
  }
}
