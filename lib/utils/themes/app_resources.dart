import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

part 'parts/_assets.dart';
part 'parts/_colors.dart';
part 'parts/_custom_themes.dart';
part 'parts/_fonts.dart';

class AppResources {
  AppResources._();
  static final fonts = _Fonts();
  static final colors = _Colors();
  static final assets = _Assets();
  static final themes = _CustomTheme();
}
