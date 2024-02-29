class CoordinateModel {
  final String id;
  final List<String> field;
  final Map<String, int> start;
  final Map<String, int> end;
  List<Map<String, String>>? steps;
  String? path;

  CoordinateModel({
    required this.id,
    required this.field,
    required this.start,
    required this.end,
    this.path,
    this.steps,
  });

  factory CoordinateModel.fromJson(Map<String, dynamic> json) {
    return CoordinateModel(
      id: json['id'],
      field: List<String>.from(json['field']),
      start: Map<String, int>.from(json['start']),
      end: Map<String, int>.from(json['end']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'result': {
        'steps': steps,
        'path': path,
      },
    };
  }
}
