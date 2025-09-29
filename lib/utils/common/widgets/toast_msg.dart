import 'package:bxb/utils/themes/app_resources.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/utils/enums.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToastMsg {
  ToastMsg._();
  static show(BuildContext context,
      {required String message, bool isError = false}) {
    DelightToastBar(
        snackbarDuration: Duration(milliseconds: 2100),
        animationDuration: Duration(milliseconds: 50),
        position: DelightSnackbarPosition.bottom,
        autoDismiss: true,
        builder: (context) => Container(
              margin: EdgeInsets.symmetric(horizontal: 40.w),
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: isError ? Colors.red.shade400 : Colors.green.shade400,
                borderRadius: BorderRadius.circular(10.r),
              ),
              alignment: Alignment.center,
              child: Text(
                message,
                style: AppResources.fonts.body4.copyWith(color: Colors.white),
              ),
            )).show(context);
  }
}
