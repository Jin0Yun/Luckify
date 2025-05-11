class MessageDTO {
  final String role;
  final String content;

  const MessageDTO({required this.role, required this.content});

  factory MessageDTO.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return MessageDTO(role: 'user', content: '');
    }
    return MessageDTO(
      role: json['role'] ?? 'user',
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'role': role, 'content': content};
  }
}