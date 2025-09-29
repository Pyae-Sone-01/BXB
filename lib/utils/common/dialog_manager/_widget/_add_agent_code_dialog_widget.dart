part of '../dialog_manager.dart';

class _AddAgentCodeDialog extends StatefulWidget {
  final Function(String pin) onConfirm;
  const _AddAgentCodeDialog({required this.onConfirm});

  @override
  State<_AddAgentCodeDialog> createState() => _AddAgentCodeDialogState();
}

class _AddAgentCodeDialogState extends State<_AddAgentCodeDialog> {
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
                'သင်၏အေးဂျင့်ကုဒ်ကို ထည့်သွင်းပါ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              TxtInputWidget(
                name: '',
                controller: _pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLines: 1,
                hintText: 'Agent Code',
                style: const TextStyle(
                    fontSize: 16, letterSpacing: 4, color: Colors.black),
                boxBorder: Border.all(color: Colors.grey),
                borderRadius: 8,
                validator: pinValidator,
                hintStyle: const TextStyle(
                    color: Colors.grey, fontSize: 13, letterSpacing: 1),
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
