
/// Data model representing a business from yelp API
class Business {
  final String id;
  final double rating;
  final String price;
  final bool isClosed;
  final int reviewCount;
  final String name;
  final String url;
  final String imageUrl;
  final List<String> categoryAlias;

  const Business({
    this.id,
    this.rating,
    this.price,
    this.isClosed,
    this.reviewCount,
    this.name,
    this.url,
    this.imageUrl,
    this.categoryAlias
  });

  /// Helper method for parsing from json dict
  static Business fromDynamic(dynamic dict) {
    return Business(
      id: dict['id'],
      rating: dict['rating'],
      price: dict['price'],
      isClosed: dict['is_closed'],
      reviewCount: dict['review_count'],
      name: dict['name'],
      url: dict['url'],
      imageUrl: dict['image_url'],
      categoryAlias: dict['categories'].map<String>((category) => category['alias'] as String).toList()
    );
  }
}