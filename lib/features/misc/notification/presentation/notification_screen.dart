import 'package:bxb/features/misc/notification/view_model/notification_view_model.dart';
import 'package:bxb/router/router.dart';
import 'package:bxb/utils/common/widgets/empty_error_widget.dart';
import 'package:bxb/utils/common/widgets/loading_widget.dart';
import 'package:bxb/utils/extension/string_extension.dart';
import 'package:bxb/utils/themes/app_resources.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationViewModelProvider.notifier).initializeData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(notificationViewModelProvider.select((s) => s.isLoading));
    final notifications =
        ref.watch(notificationViewModelProvider.select((s) => s.notifications));

    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        centerTitle: false,
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          ref.read(notificationViewModelProvider.notifier).initializeData();
        },
        child: isLoading
            ? const LoadingWidget()
            : notifications.isEmpty
                ? const EmptyErrorWidget(msg: "အကြောင်းကြားစာများ မရှိပါ")
                : ListView.separated(
                    padding: EdgeInsets.all(16),
                    itemCount: notifications.length,
                    separatorBuilder: (context, index) => Gap(10),
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return GestureDetector(
                        onTap: () {
                          context.pushNamed(RouteNames.misc.notificationDetail,
                              extra: notification);
                        },
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppResources.colors.blue200,
                                radius: 20,
                                child: Icon(
                                  Icons.message,
                                  color: AppResources.colors.blue500,
                                ),
                              ),
                              Gap(10),
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        notification.title ?? "No Title",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Gap(8),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        notification.createdDate
                                                ?.toReadableNotificationDate() ??
                                            "",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
