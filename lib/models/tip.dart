class Tip {
  final String title;
  final String description;
  final String imageUrl;

  Tip({required this.title, required this.description, required this.imageUrl});

  // factory Tip.fromJson(Map<String, dynamic> json) {
  //   return Tip(
  //     title: json['title'] as String,
  //     description: json['description'] as String,
  //     imageUrl: json['imageUrl'] as String,
  //   );
  // }
}
