class NewsModel {
  final int newsCode;
  final String newsTitle;
  final String newsLatTitle;
  final String newsDescription;
  final String newsLatDescription;
  final DateTime newsDate;
  final bool isActive;
  final String photoPath;
  final int orderBy;

  NewsModel({
    required this.newsCode,
    required this.newsTitle,
    required this.newsLatTitle,
    required this.newsDescription,
    required this.newsLatDescription,
    required this.newsDate,
    required this.isActive,
    required this.photoPath,
    required this.orderBy,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      newsCode: json['newsCode'],
      newsTitle: json['newsTitle'],
      newsLatTitle: json['newsLatTitle'],
      newsDescription: json['newsDescription'],
      newsLatDescription: json['newsLatDescription'],
      newsDate: DateTime.parse(json['newsDate']),
      isActive: json['isActive'],
      photoPath: json['photoPath'],
      orderBy: json['orderBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'newsCode': newsCode,
      'newsTitle': newsTitle,
      'newsLatTitle': newsLatTitle,
      'newsDescription': newsDescription,
      'newsLatDescription': newsLatDescription,
      'newsDate': newsDate.toIso8601String(),
      'isActive': isActive,
      'photoPath': photoPath,
      'orderBy': orderBy,
    };
  }
}
