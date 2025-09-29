part of '../dialog_manager.dart';

class _ConfirmPinDialog extends StatefulWidget {
  final Function(String pin) onConfirm;
  const _ConfirmPinDialog({required this.onConfirm});

  @override
  State<_ConfirmPinDialog> createState() => _ConfirmPinDialogState();
}

class _ConfirmPinDialogState extends State<_ConfirmPinDialog> {
  final TextEditingController _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'PIN ထည့်ပါ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'ငွေထုတ်ရန် ၆ လုံး PIN ကိုထည့်ပါ',
                style: TextStyle(fontSize: 14, color: Color(0xFF484C54)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              TxtInputWidget(
                name: '',
                controller: _pinController,
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
              ),
              const SizedBox(height: 24),
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
                          Navigator.of(context).pop();
                          widget.onConfirm(_pinController.text);
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
