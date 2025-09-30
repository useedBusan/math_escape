class ContentItem {
  final String image;
  final String title;
  final String description;
  final String url;

  const ContentItem({
    required this.image,
    required this.title,
    required this.description,
    required this.url,
  });

  factory ContentItem.fromMap(Map<String, dynamic> map) {
    return ContentItem(
      image: map['image'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      url: map['url'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'title': title,
      'description': description,
      'url': url,
    };
  }
} 