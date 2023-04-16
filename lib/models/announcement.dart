class Announcement {
  final String title;
  final String description;

  Announcement({required this.description, required this.title});

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      description: json['description'],
      title: json['title'],
    );
  }
}
