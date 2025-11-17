import 'package:flutter/material.dart';

import '../../themes/app_resources.dart';

class TxtInputWidget extends StatefulWidget {
  final String name;
  final String? hintText;
  final TextEditingController controller;
  final bool? obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputAction textInputAction;
  final FormFieldValidator? validator;
  final int? maxLines;
  final bool? enable;
  final bool? autofocus;
  final bool isRequired;

  final BoxBorder? boxBorder;
  final double borderRadius;

  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final int? maxLength;
  final void Function(String)? onChanged;

  //final onSaved;

  const TxtInputWidget(
      {super.key,
      this.maxLength,
      required this.name,
      required this.controller,
      this.hintText,
      this.obscureText,
      this.keyboardType = TextInputType.text,
      this.suffixIcon,
      this.prefixIcon,
      this.textInputAction = TextInputAction.next,
      this.validator,
      this.maxLines = 1,
      this.enable,
      this.autofocus = false,
      this.onChanged,
      this.boxBorder,
      this.borderRadius = 15,
      this.labelStyle,
      this.isRequired = false,
      this.hintStyle,
      this.style
      //required this.onSaved,
      });

  @override
  State<TxtInputWidget> createState() => _TxtInputWidgetState();
}

class _TxtInputWidgetState extends State<TxtInputWidget> {
  bool _obscureText = true;
  String error = "";
  final BoxBorder boxBorder =
      BoxBorder.all(color: Colors.white.withOpacity(0.25), width: 2);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.name.isNotEmpty) ...[
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: widget.name,
                ),
                if (widget.isRequired)
                  const TextSpan(
                      text: "*", style: TextStyle(color: Colors.red)),
              ],
            ),
            style: widget.labelStyle ??
                AppResources.fonts.body4.copyWith(
                  color: AppResources.colors.primary,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 10),
        ],
        Container(
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            border: widget.boxBorder ?? boxBorder,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: TextFormField(
                maxLength: widget.maxLength,
                style: widget.style ??
                    TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                keyboardType: widget.keyboardType,
                controller: widget.controller,
                obscureText:
                    widget.keyboardType == TextInputType.visiblePassword &&
                        _obscureText,
                validator: (value) {
                  final String? error = widget.validator != null
                      ? widget.validator!(value)
                      : null;
                  setState(() {
                    this.error = error ?? "";
                  });
                  return error != null ? "" : null;
                },
                textInputAction: widget.textInputAction,
                maxLines: widget.maxLines,
                autofocus: widget.autofocus ?? false,
                enabled: widget.enable,
                onChanged: widget.onChanged,
                cursorColor: const Color(0xff757575),
                decoration: InputDecoration(
                  filled: true,
                  errorStyle: const TextStyle(fontSize: 0, height: 0),
                  hintText: widget.hintText,
                  suffixIcon: widget.suffixIcon ??
                      ((widget.keyboardType != TextInputType.visiblePassword)
                          ? null
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              icon: _obscureText
                                  ? const Icon(
                                      Icons.visibility_off_outlined,
                                      color: Colors.grey,
                                      size: 20,
                                    )
                                  : Icon(
                                      Icons.visibility_outlined,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                            )),
                  prefixIcon: widget.prefixIcon,
                  border: InputBorder.none,
                  fillColor: Colors.transparent,
                  hintStyle: widget.hintStyle ??
                      TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                )),
          ),
        ),
        if (error.isNotEmpty)
          Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
          )
      ],
    );
  }
}
