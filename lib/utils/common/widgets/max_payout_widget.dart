import 'package:bxb/utils/themes/app_resources.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MaxPayoutWidget extends StatefulWidget {
  final String remainingBalance;
  final int? predictionCount;
  final void Function(num) onPrediction;
  final VoidCallback onPreviewPrediction;
  const MaxPayoutWidget({
    super.key,
    required this.remainingBalance,
    this.predictionCount,
    required this.onPrediction,
    required this.onPreviewPrediction,
  });

  @override
  State<MaxPayoutWidget> createState() => _MaxPayoutWidgetState();
}

class _MaxPayoutWidgetState extends State<MaxPayoutWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePrediction() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      widget.onPrediction(0);
      return;
    }
    final value = num.tryParse(text) ?? 0;
    widget.onPrediction(value);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 170,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Max Payout',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppResources.colors.neutral800,
                fontSize: 14,
              ),
            ),
            const Gap(4),
            Text(
              'အနည်းဆုံး ၁၀၀၀ ကျပ်မှ စတင်ထားရပါမည်',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppResources.colors.blue600,
                fontSize: 14,
              ),
            ),
            const Gap(16),
            Row(
              children: [
                GestureDetector(
                  onTap: widget.onPreviewPrediction,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppResources.colors.blue600, width: 1.5),
                    ),
                    child: Center(
                      child: widget.predictionCount != null
                          ? Text(widget.predictionCount.toString())
                          : Icon(Icons.remove_red_eye,
                              color: AppResources.colors.blue600, size: 20),
                    ),
                  ),
                ),
                const Gap(5),
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppResources.colors.blue600, width: 1.5),
                        borderRadius: BorderRadius.circular(100)),
                    child: TextField(
                      controller: _controller,
                      cursorHeight: 20,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '0',
                        hintStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600),
                        isCollapsed: true,
                        suffixText: "MMK",
                      ),
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                const Gap(5),
                GestureDetector(
                  onTap: _handlePrediction,
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F5F9),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Text(
                        'လောင်းမည်',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: AppResources.colors.neutral800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(10),
            Text(
              'လက်ကျန်ငွေ: ${widget.remainingBalance}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppResources.colors.neutral800,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
