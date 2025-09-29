import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../themes/app_resources.dart';

class CustomDropdownWidget<T> extends StatelessWidget {
  final String? label;
  final List<T> items;
  final String Function(T value) displayValue;
  final dynamic selectedValue;
  final void Function(T? value)? onChanged;
  // final void Function(T value)? onChanged;
  final bool enable;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final Color borderColor;
  final Color? fillColor;
  final bool isRequired;
  const CustomDropdownWidget(
      {super.key,
      this.label,
      required this.items,
      required this.displayValue,
      required this.selectedValue,
      required this.onChanged,
      this.labelStyle,
      this.enable = true,
      this.borderColor = const Color.fromARGB(255, 238, 238, 238),
      this.textStyle,
      this.isRequired = false,
      this.fillColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Column(
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: label,
                    ),
                    if (isRequired)
                      const TextSpan(
                          text: "*", style: TextStyle(color: Colors.red)),
                  ],
                ),
                style: labelStyle ??
                    AppResources.fonts.body4.copyWith(
                      color: AppResources.colors.primary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Gap(6.h)
            ],
          ),
        Container(
          padding: const EdgeInsets.only(right: 10),
          width: double.infinity,
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
            color: enable ? fillColor ?? Colors.white : Colors.grey.shade200,
          ),
          child: !enable || items.isEmpty
              ? Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    "No options available to select",
                    style: textStyle,
                  ),
                )
              : DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<T>(
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        value: selectedValue,
                        items: items.map((value) {
                          return DropdownMenuItem(
                            alignment: Alignment.centerLeft,
                            value: value,
                            child: Text(
                              displayValue(value),
                              style: textStyle,
                            ),
                          );
                        }).toList(),
                        onChanged: onChanged),
                  ),
                ),
        ),
      ],
    );
  }
}
