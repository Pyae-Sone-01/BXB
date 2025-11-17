part of '../dialog_manager.dart';

class _FinishedPredictFilterDialog extends StatefulWidget {
  final Function({required String? startDate, required String? endDate})
      onApply;
  const _FinishedPredictFilterDialog({super.key, required this.onApply});

  @override
  State<_FinishedPredictFilterDialog> createState() =>
      __FinishedPredictFilterDialogState();
}

class __FinishedPredictFilterDialogState
    extends State<_FinishedPredictFilterDialog> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
  }

  String _fmt(DateTime? d) {
    if (d == null) return 'mm/dd/yyyy';
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$mm/$dd/$yyyy';
  }

  String _fmtIso(DateTime d) {
    final yyyy = d.year.toString();
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '$yyyy-$mm-$dd';
  }

  Future<void> _pickStart() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      setState(() => _startDate = picked);
      if (_endDate != null && _endDate!.isBefore(picked)) {
        setState(() => _endDate = picked);
      }
    }
  }

  Future<void> _pickEnd() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? (_startDate ?? now),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      setState(() => _endDate = picked);
      if (_startDate != null && _startDate!.isAfter(picked)) {
        setState(() => _startDate = picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Start Date',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Gap(8),
            InkWell(
              onTap: _pickStart,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppResources.colors.primary),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _fmt(_startDate),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.calendar_today,
                    ),
                  ],
                ),
              ),
            ),
            const Gap(12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'End Date',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Gap(8),
            InkWell(
              onTap: _pickEnd,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppResources.colors.primary),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _fmt(_endDate),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.calendar_today,
                    ),
                  ],
                ),
              ),
            ),
            const Gap(16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // if (_startDate != null && _endDate != null) {
                  //   print('start_date\n${_fmtIso(_startDate!)}');
                  //   print('end_date\n${_fmtIso(_endDate!)}');
                  // } else {
                  //   print(
                  //       'start_date\n${_startDate == null ? 'null' : _fmtIso(_startDate!)}');
                  //   print(
                  //       'end_date\n${_endDate == null ? 'null' : _fmtIso(_endDate!)}');
                  // }

                  widget.onApply(
                      startDate:
                          _startDate != null ? _fmtIso(_startDate!) : null,
                      endDate: _endDate != null ? _fmtIso(_endDate!) : null);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppResources.colors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'Apply',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
