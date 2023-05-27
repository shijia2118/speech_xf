class SpeechResult {
  bool? success;
  bool? isLast;
  String? result;
  String? error;

  SpeechResult({this.success, this.isLast, this.result, this.error});

  SpeechResult.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    isLast = json['isLast'];
    result = json['result'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['isLast'] = isLast;
    data['result'] = result;
    data['error'] = error;
    return data;
  }
}
