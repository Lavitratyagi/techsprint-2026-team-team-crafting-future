class NewsModel {
  final String title;
  final String description;
  final String author;
  final String imageUrl;

  NewsModel({
    required this.title,
    required this.description,
    required this.author,
    required this.imageUrl,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      author: json['author'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}
