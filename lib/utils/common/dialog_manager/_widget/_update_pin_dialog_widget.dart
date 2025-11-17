part of '../dialog_manager.dart';

class _UpdatePinDialog extends StatefulWidget {
  final Function(String pin, String newPin) onConfirm;
  const _UpdatePinDialog({required this.onConfirm});

  @override
  State<_UpdatePinDialog> createState() => _UpdatePinDialogState();
}

class _UpdatePinDialogState extends State<_UpdatePinDialog> {
  final TextEditingController _currentPinController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'လုံခြုံရေး PIN ကို ပြောင်းလဲမည်',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppResources.colors.blue600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              TxtInputWidget(
                name: 'လက်ရှိ PIN',
                controller: _currentPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLines: 1,
                hintText: '******',
                style: const TextStyle(
                    fontSize: 16, letterSpacing: 4, color: Colors.black),
                boxBorder: Border.all(color: Colors.grey),
                borderRadius: 8,
                validator: pinValidator,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 18),
                labelStyle: const TextStyle(),
              ),
              const SizedBox(height: 18),
              TxtInputWidget(
                name: 'PIN အသစ်',
                controller: _newPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLines: 1,
                hintText: '******',
                style: const TextStyle(
                    fontSize: 16, letterSpacing: 4, color: Colors.black),
                boxBorder: Border.all(color: Colors.grey),
                borderRadius: 8,
                validator: pinValidator,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 18),
                labelStyle: const TextStyle(),
              ),
              const SizedBox(height: 18),
              TxtInputWidget(
                name: 'PIN အသစ်ကို နောက်တစ်ကြိမ် ထပ်မံရိုက်ထည့်ပါ',
                controller: _confirmPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLines: 1,
                hintText: '******',
                style: const TextStyle(
                    fontSize: 16, letterSpacing: 4, color: Colors.black),
                boxBorder: Border.all(color: Colors.grey),
                borderRadius: 8,
                validator: (value) {
                  if (value != _newPinController.text) {
                    return "PIN နှစ်ခု တူညီရမည်";
                  }
                },
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 18),
                labelStyle: const TextStyle(),
              ),
              // const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      DialogManger.showSupportDialog(context);
                    },
                    child: Text(
                      "Pin နံပါတ် မမှတ်မိပါ",
                      style: TextStyle(
                        color: AppResources.colors.blue500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF484C54)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'ပယ်ဖျက်မည်',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.onConfirm(_currentPinController.text,
                              _confirmPinController.text);
                        }
                      },
                      child: const Text(
                        'အတည်ပြုမည်',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
