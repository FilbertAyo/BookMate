class Book {
  final String title;
  final String description;
  final List<String> authors;
  final List<String> categories;
  final String smallThumbnailUrl;
  final String thumbnailUrl;
  final int ratingsCount;
  final String publishedDate;
  final String fullDate;
  final String contentVersion;
  final String maturityRating;
  final int printedPageCount;
  final String publisher;
  final String language;
  final String previewLink;

  Book({
    required this.title,
    required this.description,
    required this.authors,
    required this.categories,
    required this.smallThumbnailUrl,
    required this.thumbnailUrl,
    required this.ratingsCount,
    required this.publishedDate,
    required this.fullDate,
    required this.contentVersion,
    required this.maturityRating,
    required this.printedPageCount,
    required this.publisher,
    required this.language,
    required this.previewLink,
  });

  static String extractYear(String date) {
    if (date.isEmpty) {
      return '';
    }
    return date.split('-')[0];
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    int parseRatingsCount(dynamic value) {
      if (value is int) {
        return value;
      } else if (value is String) {
        return int.tryParse(value) ?? 0; // Fallback to 0 if parsing fails
      } else {
        return 0; // Fallback to 0 if the value is null or of an unexpected type
      }
    }

    int pageCount(dynamic value) {
      if (value is int) {
        return value;
      } else if (value is String) {
        return int.tryParse(value) ?? 0; // Fallback to 0 if parsing fails
      } else {
        return 0; // Fallback to 0 if the value is null or of an unexpected type
      }
    }

    return Book(
      title: json['volumeInfo']['title'] ?? '',
      description: json['volumeInfo']['description'] ?? '',
      fullDate: json['volumeInfo']['publishedDate'] ?? '',
      publishedDate:
          extractYear(json['volumeInfo']['publishedDate'] ?? 'vague'),
      authors: json['volumeInfo']['authors'] != null
          ? List<String>.from(json['volumeInfo']['authors'])
          : [],
      categories: json['volumeInfo']['categories'] != null
          ? List<String>.from(json['volumeInfo']['categories'])
          : [],
      smallThumbnailUrl:
          json['volumeInfo']['imageLinks']?['smallThumbnail'] ?? '',
      thumbnailUrl: json['volumeInfo']['imageLinks']?['thumbnail'] ?? '',
      ratingsCount: parseRatingsCount(json['volumeInfo']['ratingsCount']),
      contentVersion:
          json['volumeInfo']['contentVersion'] ?? 'unspecified version',
      maturityRating: json['volumeInfo']['maturityRating'] ?? '',
      printedPageCount: pageCount(json['volumeInfo']['printedPageCount']),
      publisher: json['volumeInfo']['publisher'] ?? 'Not specified',
      language: json['volumeInfo']['language'],
      previewLink: json['volumeInfo']['previewLink'],
    );
  }
}
