class GovernorateModel {
  final int governorateId;
  final String governorateName;
  final String governorateLatName;

  GovernorateModel({
    required this.governorateId,
    required this.governorateName,
    required this.governorateLatName,
  });

  factory GovernorateModel.fromJson(Map<String, dynamic> json) {
    return GovernorateModel(
      governorateId: json['governorateId'],
      governorateName: json['governorateName'],
      governorateLatName: json['governorateLatName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'governorateId': governorateId,
      'governorateName': governorateName,
      'governorateLatName': governorateLatName,
    };
  }

  @override
  String toString() {
    return governorateLatName; // Or governorateName if Arabic is preferred
  }
}
