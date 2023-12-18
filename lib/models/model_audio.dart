class ModelAudio {
  ModelAudio({
    required this.url,
    required this.title,
    required this.preview,
  });

  final String url;
  final String title;
  final String preview;

  static ModelAudio empty() {
    return ModelAudio(
      url: '',
      title: '',
      preview: '',
    );
  }

  fromJson(Map<String, dynamic> json) {
    return ModelAudio(
      url: json['url'],
      title: json['title'],
      preview: json['preview'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'title': title,
      'preview': preview,
    };
  }
}
