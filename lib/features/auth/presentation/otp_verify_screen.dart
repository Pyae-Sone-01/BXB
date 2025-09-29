import 'package:bxb/features/auth/view_model/auth_view_model.dart';

import 'package:bxb/utils/common/widgets/background_stack_widget.dart';
import 'package:bxb/utils/common/widgets/txt_input_widget.dart';
import 'package:bxb/utils/helpers/validator_functions.dart';
import 'package:bxb/utils/themes/app_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/common/widgets/custom_image_widget.dart';

class OtpVerifyScreen extends ConsumerStatefulWidget {
  const OtpVerifyScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends ConsumerState<OtpVerifyScreen> {
  late final TextEditingController _otpTxtCtl;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _otpTxtCtl = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _otpTxtCtl.dispose();
  }

  _verifyOtp() {
    if (_formKey.currentState!.validate()) {
      ref.read(authViewModelImplProvider.notifier).otpVerify(
            context,
            otp: _otpTxtCtl.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailOrPhone =
        ref.watch(authViewModelImplProvider.select((s) => s.emailOrPhone));
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
                children: [
                  const Gap(200),
                  CustomImageWidget(
                    AppResources.assets.images.logo,
                    width: 170,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'OTP ကို အတည်ပြုပါ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      '$emailOrPhone သို့ ပေးပို့ထားသော ၄ လုံးကုဒ်ကို ထည့်ပေးပါ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // OTP input boxes
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: TxtInputWidget(
                      name: "",
                      controller: _otpTxtCtl,
                      hintText: "1234",
                      validator: otpCodeValidator,
                      keyboardType: TextInputType.numberWithOptions(),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        label: const Text(
                          'အတည်ပြုပါ',
                          style: TextStyle(
                            color: Color(0xFF1846C7),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
                        onPressed: _verifyOtp,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'OTP မရောက်သေးလား? ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          ' ပြန်လည်ပို့ရန်',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
