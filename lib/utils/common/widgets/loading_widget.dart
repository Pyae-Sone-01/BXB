import 'package:bxb/utils/common/widgets/custom_image_widget.dart';
import 'package:bxb/utils/themes/app_resources.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final double width;
  final double height;
  const LoadingWidget({super.key, this.width = 70, this.height = 70});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomImageWidget(
        AppResources.assets.gifs.loading,
        width: width,
        height: height,
      ),
    );
  }
}
