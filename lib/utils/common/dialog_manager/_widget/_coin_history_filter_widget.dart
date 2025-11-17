part of '../dialog_manager.dart';

class _CoinHistoryFilterWidget extends StatefulWidget {
  final Function(String startDate, String endDate) onApply;

  const _CoinHistoryFilterWidget({
    required this.onApply,
  });

  @override
  State<_CoinHistoryFilterWidget> createState() =>
      _CoinHistoryFilterWidgetState();
}

class _CoinHistoryFilterWidgetState extends State<_CoinHistoryFilterWidget> {
  String _selectedDateRange = '3 Days';
  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> _dateRangeOptions = ['3 Days', '7 Days', 'Custom'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Filters',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppResources.colors.neutral950,
              ),
            ),
            const Gap(12),

            // Description
            Text(
              'Use the payment transaction history filter to quickly find your transaction records.',
              style: TextStyle(
                fontSize: 14,
                color: AppResources.colors.gray500,
                height: 1.4,
              ),
            ),
            const Gap(24),

            // Date Range Section
            Text(
              'Date Range',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppResources.colors.neutral950,
              ),
            ),
            const Gap(12),

            // Date Range Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              decoration: BoxDecoration(
                border:
                    Border.all(color: AppResources.colors.blue600, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: _selectedDateRange,
                isExpanded: true,
                underline: const SizedBox(),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: AppResources.colors.gray500,
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: AppResources.colors.neutral950,
                ),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedDateRange = newValue;
                      // Reset custom dates when switching away from custom
                      if (newValue != 'Custom') {
                        _startDate = null;
                        _endDate = null;
                      }
                    });
                  }
                },
                items: _dateRangeOptions
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),

            // Custom Date Pickers (show only when Custom is selected)
            if (_selectedDateRange == 'Custom') ...[
              const Gap(24),

              // Start Date
              Text(
                'Start Date',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppResources.colors.neutral950,
                ),
              ),
              const Gap(8),
              GestureDetector(
                onTap: () => _selectStartDate(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppResources.colors.gray300),
                    borderRadius: BorderRadius.circular(8),
                    color: AppResources.colors.gray50,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _startDate != null
                              ? _formatDate(_startDate!)
                              : 'mm/dd/yyyy',
                          style: TextStyle(
                            fontSize: 16,
                            color: _startDate != null
                                ? AppResources.colors.neutral950
                                : AppResources.colors.gray500,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.calendar_today,
                        color: AppResources.colors.gray500,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(16),

              // End Date
              Text(
                'End Date',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppResources.colors.neutral950,
                ),
              ),
              const Gap(8),
              GestureDetector(
                onTap: () => _selectEndDate(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppResources.colors.gray300),
                    borderRadius: BorderRadius.circular(8),
                    color: AppResources.colors.gray50,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _endDate != null
                              ? _formatDate(_endDate!)
                              : 'mm/dd/yyyy',
                          style: TextStyle(
                            fontSize: 16,
                            color: _endDate != null
                                ? AppResources.colors.neutral950
                                : AppResources.colors.gray500,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.calendar_today,
                        color: AppResources.colors.gray500,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const Gap(32),

            // Apply Filters Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onApplyPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppResources.colors.blue600,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Apply Filters',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Add bottom padding for safe area
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatApiDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _onApplyPressed() {
    String startDate;
    String endDate;

    final now = DateTime.now();

    switch (_selectedDateRange) {
      case '3 Days':
        startDate = _formatApiDate(now.subtract(const Duration(days: 3)));
        endDate = _formatApiDate(now);

        break;
      case '7 Days':
        startDate = _formatApiDate(now.subtract(const Duration(days: 7)));
        endDate = _formatApiDate(now);

        break;
      case 'Custom':
        if (_startDate != null && _endDate != null) {
          startDate = _formatApiDate(_startDate!);
          endDate = _formatApiDate(_endDate!);
        } else {
          // Show error if custom dates not selected
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select both start and end dates'),
            ),
          );
          return;
        }
        break;
      default:
        return;
    }

    widget.onApply(startDate, endDate);
  }
}
