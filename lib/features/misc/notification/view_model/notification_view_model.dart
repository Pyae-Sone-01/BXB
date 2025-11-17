import 'package:bxb/services/misc/models/notification_model.dart';
import 'package:bxb/services/misc/misc_service.dart';
import 'package:bxb/services/misc/providers/misc_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_view_model.g.dart';

class NotificationState {
  final bool isLoading;
  final List<NotificationModel> notifications;
  final int page;

  NotificationState({
    this.isLoading = true,
    this.notifications = const [],
    this.page = 1,
  });

  NotificationState copyWith({
    bool? isLoading,
    List<NotificationModel>? notifications,
    int? page,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      notifications: notifications ?? this.notifications,
      page: page ?? this.page,
    );
  }
}

@riverpod
class NotificationViewModel extends _$NotificationViewModel {
  late final MiscService _miscService;

  @override
  NotificationState build() {
    _miscService = ref.read(miscServiceProvider);
    return NotificationState();
  }

  void initializeData() async {
    await _getNotifications();
  }

  void loadMore() async {
    final nextPage = state.page + 1;
    state = state.copyWith(page: nextPage);
    await _getNotifications(isLoadMore: true);
  }

  void refresh() async {
    state = state.copyWith(page: 1, notifications: []);
    await _getNotifications();
  }

  Future<void> _getNotifications({
    bool isLoadMore = false,
  }) async {
    if (!isLoadMore) {
      state = state.copyWith(isLoading: true);
    }

    final payload = {
      "page": state.page.toString(),
    };

    final res = await _miscService.getNotification(payload);

    if (!isLoadMore) {
      state = state.copyWith(isLoading: false);
    }

    if (res.isSuccess && res.data != null) {
      List<NotificationModel> updatedNotifications;

      if (isLoadMore) {
        // Append new notifications for pagination
        updatedNotifications = [...state.notifications, ...res.data!];
      } else {
        // Replace notifications for initial load or refresh
        updatedNotifications = res.data!;
      }

      state = state.copyWith(notifications: updatedNotifications);
    }
  }
}
