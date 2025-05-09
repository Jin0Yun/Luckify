class UsageDTO {
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;

  const UsageDTO({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  factory UsageDTO.fromJson(Map<String, dynamic> json) {
    return UsageDTO(
      promptTokens: json['prompt_tokens'] ?? 0,
      completionTokens: json['completion_tokens'] ?? 0,
      totalTokens: json['total_tokens'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prompt_tokens': promptTokens,
      'completion_tokens': completionTokens,
      'total_tokens': totalTokens,
    };
  }
}
