import 'package:bxb/features/auth/view_model/auth_view_model.dart';

import 'package:bxb/utils/common/widgets/background_stack_widget.dart';
import 'package:bxb/utils/common/widgets/custom_image_widget.dart';
import 'package:bxb/utils/common/widgets/txt_input_widget.dart';
import 'package:bxb/utils/helpers/validator_functions.dart';
import 'package:bxb/utils/themes/app_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class LoginWithScreen extends StatefulWidget {
  final bool isLoginWithPhone;
  final bool isLoginWithAtom;
  const LoginWithScreen(
      {super.key,
      required this.isLoginWithPhone,
      required this.isLoginWithAtom});

  @override
  State<LoginWithScreen> createState() => _LoginWithScreenState();
}

class _LoginWithScreenState extends State<LoginWithScreen> {
  late final TextEditingController _emailOrPhoneTxtCtl;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _emailOrPhoneTxtCtl = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _emailOrPhoneTxtCtl.dispose();
  }

  _requestOtp(WidgetRef ref) {
    if (_formKey.currentState!.validate()) {
      if (widget.isLoginWithAtom) {
        ref
            .read(authViewModelImplProvider.notifier)
            .checkAtomPhone(context, phone: _emailOrPhoneTxtCtl.text);
      } else {
        ref.read(authViewModelImplProvider.notifier).getOtp(context,
            emailOrPhone: _emailOrPhoneTxtCtl.text,
            type: widget.isLoginWithPhone ? "phone" : "email");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leadingWidth: 66,
          toolbarHeight: 66,
          leading: GestureDetector(
            onTap: () {
              context.pop();
            },
            child: Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.only(left: 16.0, top: 16),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24, width: 2)),
              child: IconButton(
                icon:
                    const Icon(Icons.arrow_back, color: Colors.white, size: 32),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
        body: BackgroundStackWidget(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Gap(200),
                  CustomImageWidget(
                    AppResources.assets.images.logo,
                    width: 170,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "${widget.isLoginWithAtom ? 'ATOM ' : ''}${widget.isLoginWithPhone ? 'ဖုန်းနံပါတ်ထည့်ပါ' : 'အီးမေးလ်ထည့်ပါ'}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (!widget.isLoginWithAtom) ...[
                    const SizedBox(height: 12),
                    Text(
                      'သင့်${widget.isLoginWithPhone ? "ဖုန်းနံပါတ်" : "အီးမေးလ်လိပ်စာ"}ကို ထည့်ပေးပါ။ OTP ကုဒ်ပေးပို့ပါမည်။',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  // Phone input
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.isLoginWithPhone ? 'ဖုန်းနံပါတ်' : "အီးမေးလ်",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            if (widget.isLoginWithPhone) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 12.5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.25),
                                      width: 2),
                                ),
                                child: const Text(
                                  '+95',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                            Expanded(
                                child: TxtInputWidget(
                              name: "",
                              hintText: widget.isLoginWithPhone
                                  ? "9xxxxxxxxx"
                                  : "example@mail.com",
                              validator: widget.isLoginWithPhone
                                  ? phoneValidator
                                  : emailValidator,
                              keyboardType: widget.isLoginWithPhone
                                  ? TextInputType.phone
                                  : TextInputType.emailAddress,
                              controller: _emailOrPhoneTxtCtl,
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Consumer(
                    builder: (context, ref, child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            label: Text(
                              !widget.isLoginWithAtom
                                  ? "OTP ပေးပို့မည်"
                                  : 'ဆက်လက်လုပ်ဆောင်မည်',
                              style: TextStyle(
                                color: Color(0xFF1846C7),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              elevation: 2,
                            ),
                            onPressed: () {
                              _requestOtp(ref);
                            },
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

// Helper widget for blurred circle
