class Chat {
  final int id;
  final String title;

  Chat({required this.id, required this.title});

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(id: map['id'] as int, title: map['title'] as String);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title};
  }
}
