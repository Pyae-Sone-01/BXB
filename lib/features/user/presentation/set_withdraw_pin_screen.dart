import 'package:bxb/features/user/view_model/set_withdraw_pin_view_model.dart';
import 'package:bxb/utils/common/widgets/background_stack_widget.dart';
import 'package:bxb/utils/common/widgets/txt_input_widget.dart';
import 'package:bxb/utils/helpers/validator_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class SetWithdrawPinScreen extends ConsumerStatefulWidget {
  const SetWithdrawPinScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SetWithdrawPinScreenState();
}

class _SetWithdrawPinScreenState extends ConsumerState<SetWithdrawPinScreen> {
  final TextEditingController _newPinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BackgroundStackWidget(
          child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(150),
              const Text(
                "လုံခြုံရေး PIN ပြုလုပ်ပါ",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const Text(
                "အလွယ်တကူ မေ့ပျောက်မည်မဟုတ်သော ဂဏန်း ၆ လုံးကို ရွေးချယ်ပါ",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white60),
              ),
              Gap(20),
              TxtInputWidget(
                name: 'သင်အသုံးပြုမည့် ဂဏန်း ၆ လုံးကို ရိုက်ထည့်ပါ',
                controller: _newPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLines: 1,
                hintText: '******',
                style: const TextStyle(
                    fontSize: 16, letterSpacing: 4, color: Colors.white),
                boxBorder: Border.all(color: Colors.grey),
                borderRadius: 8,
                validator: pinValidator,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 18),
                labelStyle:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Gap(15),
              TxtInputWidget(
                name: 'သေချာစေရန် သင်၏ PIN နံပါတ်ကို နောက်တစ်ကြိမ် ရိုက်ထည့်ပါ',
                controller: _confirmPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLines: 1,
                hintText: '******',
                style: const TextStyle(
                    fontSize: 16, letterSpacing: 4, color: Colors.white),
                boxBorder: Border.all(color: Colors.grey),
                borderRadius: 8,
                validator: (value) {
                  if (value != _newPinController.text) {
                    return "PIN နှစ်ခု တူညီရမည်";
                  }
                },
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 18),
                labelStyle:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Gap(10),
              Text(
                "သင်၏ ရွေးချယ်ထားသော PIN ကို မမေ့ပါနှင့်။",
                style: TextStyle(color: Colors.white60),
              ),
              Gap(20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _confirmPinController.clear();
                        _newPinController.clear();
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "ရှင်းလင်းရန်",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const Gap(15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ref
                              .read(setWithdrawPinViewModelProvider.notifier)
                              .setupWithdrawPin(
                                  context, _confirmPinController.text);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("သတ်မှတ်မည်"),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
