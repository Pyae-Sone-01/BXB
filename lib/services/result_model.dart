class ResultModel<T> {
  final T? data;
  final String? error;
  String? msg;

  ResultModel.success(this.data, {this.msg}) : error = null;
  ResultModel.failure(this.error) : data = null;

  bool get isSuccess => data != null;
}
