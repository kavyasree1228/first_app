class Character {
  final String name;
  final String description;
  final String image;

  Character({
    required this.name,
    required this.description,
    required this.image,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    final result = json['Result'] as String;
    final imageUrl = json['Icon']['URL'] as String;
    final strippedResult = _stripHtmlTags(result);
    final completeImageUrl = _extractImageUrl(imageUrl);

    return Character(
      name: strippedResult,
      description: '', //  can set description as needed
      image: completeImageUrl,
    );
  }

  // Helper method to strip HTML tags from a string
  static String _stripHtmlTags(String htmlString) {
    final regex = RegExp(r'<[^>]*>');
    return htmlString.replaceAll(regex, '');
  }

  // Helper method to extract the image URL from the API response
  static String _extractImageUrl(String url) {
    return 'https://duckduckgo.com$url';
  }
}
