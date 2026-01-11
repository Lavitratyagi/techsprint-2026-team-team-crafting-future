class PolicyModel {
  final String title;
  final String description;
  final String imageUrl;
  final Map<String, double> presentIndex;
  final Map<String, double> pastIndex;

  PolicyModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.presentIndex,
    required this.pastIndex,
  });

  factory PolicyModel.fromJson(Map<String, dynamic> json) {
    return PolicyModel(
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      presentIndex: Map<String, double>.from(
        json['present_index'].map(
          (k, v) => MapEntry(k, (v as num).toDouble()),
        ),
      ),
      pastIndex: Map<String, double>.from(
        json['past_index'].map(
          (k, v) => MapEntry(k, (v as num).toDouble()),
        ),
      ),
    );
  }
}
