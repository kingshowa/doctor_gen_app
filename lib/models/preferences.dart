class Preferences {
  final int? id;
  final int userId;
  final String themeMode;
  final String language;
  final String voiceGender;
  final double voiceSpeed;
  final double voicePitch;
  final bool notificationsEnabled;
  final bool saveConversations;
  final String createdAt;
  final String updatedAt;

  Preferences({
    this.id,
    required this.userId,
    this.themeMode = 'system',
    this.language = 'en',
    this.voiceGender = 'neutral',
    this.voiceSpeed = 1.0,
    this.voicePitch = 1.0,
    this.notificationsEnabled = true,
    this.saveConversations = true,
    String? createdAt,
    String? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String(),
       updatedAt = updatedAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'theme_mode': themeMode,
      'language': language,
      'voice_gender': voiceGender,
      'voice_speed': voiceSpeed,
      'voice_pitch': voicePitch,
      'notifications_enabled': notificationsEnabled ? 1 : 0,
      'save_conversations': saveConversations ? 1 : 0,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory Preferences.fromMap(Map<String, dynamic> map) {
    return Preferences(
      id: map['id'],
      userId: map['user_id'],
      themeMode: map['theme_mode'],
      language: map['language'],
      voiceGender: map['voice_gender'],
      voiceSpeed: map['voice_speed'],
      voicePitch: map['voice_pitch'],
      notificationsEnabled: map['notifications_enabled'] == 1,
      saveConversations: map['save_conversations'] == 1,
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }
}
