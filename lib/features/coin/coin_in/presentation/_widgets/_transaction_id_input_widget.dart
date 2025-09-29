part of '../coin_in_screen.dart';

class _TransactionIdInputWidget extends StatelessWidget {
  final TextEditingController txnIdController;
  const _TransactionIdInputWidget({required this.txnIdController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ငွေသွင်းပြေစာ၏ နောက်ဆုံးဂဏန်း ၆ လုံး',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 10),
          TxtInputWidget(
            name: "",
            controller: txnIdController,
            boxBorder: Border.all(color: Colors.grey),
            borderRadius: 8,
            keyboardType: TextInputType.number,
            hintText: 'Enter last 6 digits of transaction ID',
            style: const TextStyle(color: Colors.black),
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter transaction ID';
              }
              if (value.length != 6) {
                return 'Transaction ID must be 6 digits';
              }
              if (!RegExp(r'^\d{6}$').hasMatch(value)) {
                return 'Only digits are allowed';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
