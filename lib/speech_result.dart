class SpeechResult {
  bool? success;
  bool? isLast;
  String? type;
  String? result;
  String? error;

  SpeechResult({this.success, this.isLast, this.type, this.result, this.error});

  SpeechResult.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    isLast = json['isLast'];
    type = json['type'];
    result = json['result'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['isLast'] = isLast;
    data['type'] = type;
    data['result'] = result;
    data['error'] = error;
    return data;
  }
}
