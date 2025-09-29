import 'package:bxb/utils/common/widgets/custom_image_widget.dart';
import 'package:bxb/utils/themes/app_resources.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomImageWidget(
        AppResources.assets.gifs.loading,
        width: 70,
        height: 70,
      ),
    );
  }
}
