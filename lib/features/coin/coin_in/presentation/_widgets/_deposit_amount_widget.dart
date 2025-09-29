part of '../coin_in_screen.dart';

class _DepositAmountWidget extends StatefulWidget {
  final TextEditingController amountController;
  const _DepositAmountWidget({required this.amountController});

  @override
  State<_DepositAmountWidget> createState() => __DepositAmountWidgetState();
}

class __DepositAmountWidgetState extends State<_DepositAmountWidget> {
  final List<String> quickAmounts = [
    '2,000 MMK',
    '5,000 MMK',
    '10,000 MMK',
    '3,000 MMK',
    '50,000 MMK',
    '100,000 MMK'
  ];

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
          const Text('သွင်းမည့် ငွေပမာဏ',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 12),
          TxtInputWidget(
            name: "",
            controller: widget.amountController,
            style: const TextStyle(color: Colors.black),
            boxBorder: Border.all(color: Colors.grey),
            keyboardType: TextInputType.number,
            hintText: 'Enter Amount',
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            borderRadius: 8,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Amount is required';
              }
              final numValue = int.tryParse(value.replaceAll(',', ''));
              if (numValue == null) {
                return 'Enter a valid number';
              }
              if (numValue < 2000) {
                return 'Amount must be at least 2,000 MMK';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          const Text('သွင်းငွေ အနည်းဆုံး ၂,၀၀၀ ကျပ် ဖြစ်ရမည်',
              style: TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.5,
            ),
            itemCount: quickAmounts.length,
            itemBuilder: (context, index) {
              final amount = quickAmounts[index];
              return GestureDetector(
                onTap: () {
                  // Extract digits from amount string and set as plain number
                  final plainAmount = amount.replaceAll(RegExp(r'[^0-9]'), '');
                  widget.amountController.text = plainAmount;
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFF4B8AF3),
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(amount, style: const TextStyle(fontSize: 13)),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
