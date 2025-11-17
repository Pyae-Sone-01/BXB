import 'package:bxb/services/misc/models/notification_model.dart';
import 'package:bxb/utils/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class NotificationDetailScreen extends StatelessWidget {
  final NotificationModel data;
  const NotificationDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(data.title ?? "No title"),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Html(
          data: data.body,
          onLinkTap: (url, attributes, element) => url?.openLink(),
        ),
      ),
    );
  }
}
