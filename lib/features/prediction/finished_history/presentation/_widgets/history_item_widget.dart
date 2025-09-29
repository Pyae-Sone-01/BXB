part of '../finished_history_screen.dart';

class _HistoryItemWidget extends StatelessWidget {
  final HistoryModel data;
  const _HistoryItemWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.assignment,
                      color: Colors.white, size: 28),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'BET ID',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500),
                          ),
                          const Gap(2),
                          Text(
                            data.orderNumber ?? "",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Gap(8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'DATE',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500),
                          ),
                          const Gap(2),
                          Text(
                            data.transactionDate?.toShortDateTime() ?? "",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            Text(
              'Bet Info',
              style: TextStyle(
                color: AppResources.colors.blue600,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const Gap(8),
            _buildInfoRow(
                label: "မောင်း", value: data.orderItemsCount.toString()),
            _buildInfoRow(
                label: "လောင်းငွေ",
                value: data.predictedCoin?.toPricing ?? "0 Ks"),
            _buildInfoRow(
                label: "ပြန်ရငွေ",
                value: data.returnedCoin?.toPricing ?? "0 Ks"),
            _buildInfoRow(
              label: "နိုင်/ရူံး",
              value: (data.status ?? "").toUpperCase(),
              textColor: Colors.green,
            ),
            const Gap(16),
            GestureDetector(
              onTap: () {
                context.pushNamed(RouteNames.prediciton.historyDetail,
                    queryParameters: {"id": data.id.toString()});
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: AppResources.colors.blue100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'အသေးစိတ်ကြည့်ရူ့ရန်',
                      style: TextStyle(
                        color: AppResources.colors.blue700,
                        fontSize: 16,
                      ),
                    ),
                    CustomImageWidget(
                      AppResources.assets.icons.rightUpperArrow,
                      width: 17,
                      color: AppResources.colors.blue700,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    Color? textColor,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontSize: 14, color: Colors.black87)),
            Text(value,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor)),
          ],
        ),
        const Gap(5)
      ],
    );
  }
}
