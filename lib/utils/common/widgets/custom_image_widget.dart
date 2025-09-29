import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomImageWidget extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;
  final String? errorImage;
  const CustomImageWidget(this.url,
      {super.key,
      this.errorImage,
      this.width,
      this.height,
      this.fit,
      this.color});

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return _errorWidget();
    } else if (url.contains("http")) {
      return _networkImage();
    } else if (url.split(".").last == "svg") {
      return _svgImage();
    } else if (url.contains("cache")) {
      return Image.file(
        File(url),
        height: height,
        width: width,
        fit: fit,
        color: color,
      );
    } else {
      return _assetImage();
    }
  }

  Widget _svgImage() {
    return SvgPicture.asset(
      url,
      colorFilter:
          color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
      width: width,
      height: height,
    );
  }

  Widget _assetImage() {
    return Image.asset(
      url,
      width: width,
      height: height,
      fit: fit,
      color: color,
      errorBuilder: (context, error, stackTrace) {
        return _errorWidget();
      },
    );
  }

  Widget _networkImage() {
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) {
        return Container(
          width: width,
          height: width,
          padding: const EdgeInsets.all(5),
          color: Colors.grey.shade100,
          child: const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
      },
      errorWidget: (context, url, error) => _errorWidget(),
    );
  }

  Container _errorWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.withOpacity(0.1),
      //color: Colors.red,
      child: Center(
          child: errorImage != null
              ? CustomImageWidget(errorImage!)
              : Icon(Icons.image)),
    );
  }
}
