class ErrorModel {
  final bool error;
  final String message;

  ErrorModel({
    required this.error,
    required this.message,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      error: json['error'],
      message: json['message'],
    );
  }
}
