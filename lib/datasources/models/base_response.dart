class BaseResponse<T> {
  final bool success;
  final String msg;
  final T? data;

  BaseResponse({
    required this.success,
    required this.msg,
    this.data,
  });

  BaseResponse<T> copyWith({
    bool? success,
    String? msg,
    T? data,
  }) {
    return BaseResponse<T>(
      success: success ?? this.success,
      msg: msg ?? this.msg,
      data: data ?? this.data,
    );
  }

  // Factory constructor to create from JSON
  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic data) fromJson,
  ) {
    return BaseResponse<T>(
      success: json['success'] ?? false,
      msg: json['message'] ?? '',
      data: fromJson(json['result']),
    );
  }
}
