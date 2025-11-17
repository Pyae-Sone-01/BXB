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

class FillUserInformationScreen extends ConsumerStatefulWidget {
  const FillUserInformationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FillInformationScreenState();
}

class _FillInformationScreenState
    extends ConsumerState<FillUserInformationScreen> {
  late final TextEditingController _nameTxtCtl;
  late final TextEditingController _agentCodeTxtCtl;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _nameTxtCtl = TextEditingController();
    _agentCodeTxtCtl = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _nameTxtCtl.dispose();
    _agentCodeTxtCtl.dispose();
  }

  _register() {
    if (_formKey.currentState!.validate()) {
      ref.read(authViewModelImplProvider.notifier).register(
            context,
            name: _nameTxtCtl.text,
            agentCode: _agentCodeTxtCtl.text,
          );
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
                children: [
                  const Gap(200),
                  CustomImageWidget(
                    AppResources.assets.images.logo,
                    width: 170,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'သင့်အချက်အလက်များကို ထည့်ပါ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      'သင့်အမည် စစ်ဆေးပါ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Name input
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TxtInputWidget(
                          name: "သင့်အမည်",
                          hintText: "သင့်အမည်ထည့်ပါ",
                          controller: _nameTxtCtl,
                          validator: nameValidator,
                          labelStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const Gap(15),
                        TxtInputWidget(
                          name: "Agent Code",
                          hintText: "Agent Code ထည့်သွင်းရန်",
                          controller: _agentCodeTxtCtl,
                          labelStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
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
                          'အကောင့်ဖွင့်ပါ',
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
                        onPressed: _register,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
