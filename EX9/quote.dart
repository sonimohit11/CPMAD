
class Quote {
  final String content;
  final String author;

  const Quote({
    required this.content,
    required this.author,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      content: (json['content'] as String?)?.trim() ?? '',
      author: (json['author'] as String?)?.trim() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'author': author,
    };
  }

  String get shareText => '"$content"\n— $author';
}
