part of '../app_resources.dart';

extension FigmaDimention on double {
  double toFigmaHeight(double fontSize) {
    return this / fontSize;
  }
}

class _Fonts {
  final TextStyle heading1 = GoogleFonts.poppins(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    height: 36.0.toFigmaHeight(24),
  );
  final TextStyle heading2 = GoogleFonts.poppins(
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    height: 33.0.toFigmaHeight(22),
  );
  final TextStyle heading3 = GoogleFonts.poppins(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    height: 30.0.toFigmaHeight(20),
  );
  final TextStyle heading4 = GoogleFonts.poppins(
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    height: 27.0.toFigmaHeight(18),
  );
  final TextStyle heading5 = GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    height: 24.0.toFigmaHeight(16),
  );
  final TextStyle heading6 = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
    height: 21.0.toFigmaHeight(14),
  );

  final TextStyle body1 = GoogleFonts.poppins(
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    height: 27.0.toFigmaHeight(18),
  );

  final TextStyle body2 = GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    height: 24.0.toFigmaHeight(16),
  );

  final TextStyle body3 = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height: 21.0.toFigmaHeight(14),
  );
  final TextStyle body3Bold = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
    height: 21.0.toFigmaHeight(14),
  );
  final TextStyle body4 = GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    height: 18.0.toFigmaHeight(12),
  );
  final TextStyle body4Bold = GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
    height: 18.0.toFigmaHeight(12),
  );
  final TextStyle body5 = GoogleFonts.poppins(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    height: 15.0.toFigmaHeight(10),
  );
}
