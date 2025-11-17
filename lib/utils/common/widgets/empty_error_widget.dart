import 'package:bxb/utils/common/widgets/custom_image_widget.dart';
import 'package:bxb/utils/themes/app_resources.dart';
import 'package:flutter/material.dart';

class EmptyErrorWidget extends StatelessWidget {
  final String msg;
  const EmptyErrorWidget({
    super.key,
    required this.msg,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomImageWidget(
            AppResources.assets.images.clockBox,
            width: 200,
          ),
          Text(msg)
        ],
      ),
    );
  }
}
