import 'package:bxb/services/coin/models/coin_history_model.dart';
import 'package:bxb/utils/extension/num_extension.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CoinHistoryItemWidget extends StatelessWidget {
  final CoinHistoryModel data;
  const CoinHistoryItemWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF4B8AF3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                data.date ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            const Gap(8),
            _buildDataRow('သွင်းငွေ', data.deposit?.toPricing ?? "0 Ks"),
            _buildDataRow('ထုတ်ငွေ', data.withdraw?.toPricing ?? '0 Ks'),
            _buildDataRow(
                'လောင်းငွေ', data.predictionAmount?.toPricing ?? '0 Ks'),
            _buildDataRow('ပြန်ရငွေ', data.predictionWin?.toPricing ?? '0 Ks'),
            _buildDataRow('BFF မှ ရငွေ', data.fromBff?.toPricing ?? '0 Ks'),
            _buildDataRow('BFF သို့ သွင်းငွေ', data.toBff?.toPricing ?? '0 Ks'),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF484C54),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF484C54),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
