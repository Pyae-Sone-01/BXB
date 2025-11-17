part of '../dialog_manager.dart';

class _LanguageSelectDialogWidget extends StatefulWidget {
  final String selectedLanguage;
  final Function(String) onLanguageSelected;

  const _LanguageSelectDialogWidget({
    required this.selectedLanguage,
    required this.onLanguageSelected,
  });

  @override
  State<_LanguageSelectDialogWidget> createState() =>
      _LanguageSelectDialogWidgetState();
}

class _LanguageSelectDialogWidgetState
    extends State<_LanguageSelectDialogWidget> {
  // String widget.selectedLanguage = 'mm';

  // @override
  // void initState() {
  //   super.initState();
  //   widget.selectedLanguage = widget.selectedLanguage ?? 'mm';
  // }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Language',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppResources.colors.blue800,
              ),
            ),
            const Gap(24),

            // English Option
            GestureDetector(
              onTap: () {
                widget.onLanguageSelected('en');
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.selectedLanguage == 'en'
                      ? AppResources.colors.blue200.withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: widget.selectedLanguage == 'en'
                      ? Border.all(color: AppResources.colors.blue600, width: 1)
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                        width: 24,
                        height: 18,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Text("🇬🇧")),
                    const Gap(12),
                    Expanded(
                      child: Text(
                        'English',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppResources.colors.neutral950,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (widget.selectedLanguage == 'en')
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppResources.colors.blue600,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const Gap(8),

            // Myanmar Option
            GestureDetector(
              onTap: () {
                widget.onLanguageSelected("mm");
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.selectedLanguage == 'mm'
                      ? AppResources.colors.blue200.withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: widget.selectedLanguage == 'mm'
                      ? Border.all(color: AppResources.colors.blue600, width: 1)
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                        width: 24,
                        height: 18,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Text("🇲🇲")),
                    const Gap(12),
                    Expanded(
                      child: Text(
                        'Myanmar',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppResources.colors.neutral950,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (widget.selectedLanguage == 'mm')
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppResources.colors.blue600,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const Gap(32),

            // Cancel Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide(color: AppResources.colors.gray400),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppResources.colors.gray700,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
