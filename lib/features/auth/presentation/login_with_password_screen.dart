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

class LoginWithPasswordScreen extends ConsumerStatefulWidget {
  final String phone;
  final String msg;
  const LoginWithPasswordScreen(
      {super.key, required this.phone, required this.msg});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LoginWithPasswordScreenState();
}

class _LoginWithPasswordScreenState
    extends ConsumerState<LoginWithPasswordScreen> {
  late final TextEditingController _phoneTxtCtl;
  late final TextEditingController _passwordTxtCtl;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _phoneTxtCtl = TextEditingController(text: widget.phone);
    _passwordTxtCtl = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _phoneTxtCtl.dispose();
    _passwordTxtCtl.dispose();
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
                    'ဖုန်းနံပါတ်ထည့်ပါ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'သင့် ဖုန်းနံပါတ် နှင့် စကား၀ှက် ကို  ဖြည့်ပါ။',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (widget.msg.isNotEmpty) ...[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.green.shade500),
                      child: Text(
                        widget.msg,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Gap(15),
                  ],
                  // Phone input
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ဖုန်းနံပါတ်',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
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
                            Expanded(
                                child: TxtInputWidget(
                              name: "",
                              hintText: "9xxxxxxxxx",
                              validator: phoneValidator,
                              keyboardType: TextInputType.phone,
                              controller: _phoneTxtCtl,
                              enable: false,
                              labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            )),
                          ],
                        ),
                        Gap(25),
                        TxtInputWidget(
                          name: "စကား၀ှက်",
                          hintText: "xxxxxxxxxx",
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passwordTxtCtl,
                          labelStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        label: const Text(
                          'ဆက်လက်လုပ်ဆောင်မည်',
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
                          if (_formKey.currentState!.validate()) {
                            ref
                                .read(authViewModelImplProvider.notifier)
                                .loginWithAtom(context,
                                    phone: _phoneTxtCtl.text,
                                    password: _passwordTxtCtl.text);
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
