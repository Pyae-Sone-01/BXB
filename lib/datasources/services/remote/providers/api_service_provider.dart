import '../api_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api_service.dart';

part 'api_service_provider.g.dart';

@riverpod
ApiService apiService(ref) {
  return ApiServiceImpl(ApiRoute.baseUrl, logUrl: "/log");
}
