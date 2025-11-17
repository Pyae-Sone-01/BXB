part of '../dialog_manager.dart';

class _RuleAndRegulationDialogWidget extends StatelessWidget {
  final VoidCallback onClose;

  const _RuleAndRegulationDialogWidget({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              child: Column(
                children: [
                  Text(
                    'စည်းမျဉ်းစည်းကမ်းများ (Rules and Regulations)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppResources.colors.blue700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(6),
                      Text('စည်းမျဉ်း (၁)',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppResources.colors.neutral800)),
                      const Gap(8),
                      _bulletedText(
                          'ဘော်ဒီ/ဂိုးပေါင်းများကို တစ်ကြိမ်လျှင် အနည်းဆုံး ၁,၀၀၀ ကျပ် မှ အများဆုံး ၅၀၀,၀၀၀ ကျပ် အထိ ကစားနိုင်ပါသည်။'),
                      _bulletedText(
                          'မောင်းများကို တစ်ကြိမ်လျှင် အနည်းဆုံး ၅၀၀ ကျပ် မှ အများဆုံး ၁၀၀,၀၀၀ ကျပ် အထိ ကစားနိုင်ပါသည်။'),
                      const Gap(10),
                      Text('စည်းမျဉ်း (၂)',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppResources.colors.neutral800)),
                      const Gap(8),
                      _plainText(
                          'ဘော်ဒီ/ဂိုးပေါင်း ကစားရာတွင် ပွဲကြီးပွဲသေးမခွဲခြားထားပဲ အကောက် 5% သာ ကောက်ပါမည်။'),
                      const Gap(10),
                      Text('စည်းမျဉ်း (၃)',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppResources.colors.neutral800)),
                      const Gap(8),
                      _plainText(
                          'မောင်းကစားရာတွင် ၂ သင်းမောင်းအတွက် ၁၅% ၊ ၃ သင်း မှ ၁၁ မောင်းအထိ ၂၀% ကောက်ပါမည်။'),
                      const Gap(10),
                      Text('စည်းမျဉ်း (၄)',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppResources.colors.neutral800)),
                      const Gap(8),
                      _plainText(
                          'မောင်းလောင်းကစားရာတွင် အနည်းဆုံး (၂) ပွဲ မှ အများဆုံး (၁၁) ပွဲ အထိ ရွေးချယ်နိုင်ပါသည်။'),
                      const Gap(10),
                      Text('စည်းမျဉ်း (၅)',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppResources.colors.neutral800)),
                      const Gap(8),
                      _bulletedText(
                          'ရွေးချယ်ထားသော မောင်းပွဲစဉ်များထဲမှ ပွဲစဉ်တစ်ခုခု ပယ်ပျက်ခဲ့လျှင် (မကစားဖြစ်လျှင် သို့ ပယ်ဖျက်လျှင်)၊ ကျန်ရှိသည့် ပွဲစဉ်များ၏ ရလဒ်အတိုင်း အလျော်အစားလုပ်ဆောင်ပေးမည်ဖြစ်သည်။'),
                      _bulletedText(
                          'အကောက်%ကိုမူ မူလရွေးထားသည့်ပွဲအရေအတွက်အတိုင်းကောက်ပါမည်။ (ဥပမာ - ၃ ပွဲမှာ ၁ ပွဲ ပယ်ပျက်ခဲ့လျှင် ၂၀% အတိုင်ပေးရမည်)'),
                      const Gap(10),
                      Text('စည်းမျဉ်း (၆)',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppResources.colors.neutral800)),
                      const Gap(8),
                      _plainText(
                          'ရွေးချယ်ထားသော မောင်းတစ်ခုလုံးရှိ ပွဲစဉ်အားလုံး မကစားဖြစ်ခဲ့ပါက၊ လောင်းကြေးငွေ အပြည့်ကို ပြန်လည်ရရှိမည် ဖြစ်သည်။'),
                      const Gap(10),
                      Text('စည်းမျဉ်း (၇)',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppResources.colors.neutral800)),
                      const Gap(8),
                      _plainText(
                          'သတ်မှတ်ရက်၏ နောက်တစ်နေ့ နံနက် ၁၀:၃၀ အထိ တရားဝင်ရလဒ်မထွက်သေးသော သို့မဟုတ် မပြီးပြတ်သေးသော ပွဲစဉ်များ၏ လောင်းကြေးများကို အလျော်အစားပြုလုပ်ပေးမည် မဟုတ်ပါ။'),
                      const Gap(10),
                      Text('စည်းမျဉ်း (၈)',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppResources.colors.neutral800)),
                      const Gap(8),
                      _plainText(
                          'ပွဲရလဒ်များအတွက် ibet789 နှင့် Sportbooks365 ကဲ့သို့သော ကုမ္ပဏီများ၏ ဂိုးရလဒ်အတိုင်း အလျော်အစားပြုလုပ်ပါမည်။ အဆိုပါကုမ္ပဏီများမှ နံနက် ၁၀:၃၀ အထိ ရလဒ်မထွက်ရှိသေးပါက၊ သက်ဆိုင်ရာ အားကစားအဖွဲ့ချုပ်၏ တရားဝင်ရလဒ်ကိုအတည်ပြုပါမည်။'),
                      const Gap(10),
                      Text('စည်းမျဉ်း (၉)',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppResources.colors.neutral800)),
                      const Gap(8),
                      _plainText(
                          'ပွဲများ၏ရလဒ်သည် မူလရလဒ်မှ မတူညီသည့်ရလဒ်အဖြစ် တစ်မျိုးပြောင်းလဲသွားပါက၊ ထိုရလဒ်နှင့်ပတ်သက်၍ ကန့်ကွက်လိုလျှင် နောက်နေ့ နေ့လည် ၁၂:၀၀ နာရီ နောက်ဆုံးထား၍သာ လက်ခံဆောင်ရွက်ပေးပါသည်။'),
                      const Gap(10),
                      Text('စည်းမျဉ်း (၁၀)',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppResources.colors.neutral800)),
                      const Gap(8),
                      _plainText(
                          'ပွဲကန်မည့်အချိန်ကို ပြောင်းလဲပြီး စောကန်သွားသော်လည်း BXB တွင် မူလအချိန်အတိုင်းမှားယွင်းဖွင့်လှစ်ထားမိသော ပွဲစဉ်များကို ပယ်ဖျက် (Cancel) ပါမည်။'),
                      const Gap(10),
                      Text('စည်းမျဉ်း (၁၁)',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppResources.colors.neutral800)),
                      const Gap(8),
                      _plainText(
                          'နည်းပညာပိုင်းဆိုင်ရာချွတ်ယွင်း၍ အခြားသော ကုမ္ပဏီများနှင့် ပေါက်ကြေး ကွဲလွဲစွာ (သိသာလွန်ကဲစွာ) ဖွင့်လှစ်မိပါက ထိုပေါက်ကြေးဖြင့်ကစားထားသော မောင်း နှင့် ဘော်ဒီများကို ပယ်ဖျက် (Cancel) ပြီး လောင်းကြေးငွေပြန်အမ်းပါမည်။'),
                      const Gap(10),
                      Text('စည်းမျဉ်း (၁၂)',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppResources.colors.neutral800)),
                      const Gap(8),
                      _plainText(
                          'ပုံမှန်မဟုတ်သော သို့မဟုတ် သံသယဖြစ်ဖွယ်ရှိသော ပွဲစဉ်များရှိပါက ပယ်ဖျက် (Cancel) ပြီး လောင်းကြေးငွေ ပြန်အမ်းပေးပါမည်။'),
                      const Gap(10),
                      Text('စည်းမျဉ်း (၁၃)',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppResources.colors.neutral800)),
                      const Gap(8),
                      _plainText(
                          'သာမန်ကစားခြင်းမျိုးမဟုတ်ပဲ ကြေးအဟများကို အသုံးချ၍ သီးသန့် ကြားထိုးကစားခြင်း၊ BXB ၏ နည်းပညာ နှင့် စည်းမျဉ်းပိုင်းအားနည်းချက်များကို တမင်တကာ အသုံးချ၍ အကြိမ်ကြိမ်ကစားခြင်းများ တွေ့ရှိပါက အဆိုပါ အသုံးပြုသူ၏ မသမာသော လောင်းကြေးထိုးခြင်းများကို ငြင်းပယ် (Reject) လုပ်သွားပါမည်။'),
                      const Gap(10),
                      Text('စည်းမျဉ်း (၁၄)',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppResources.colors.neutral800)),
                      const Gap(8),
                      _plainText(
                          'အငြင်းပွါးဖွယ်ရာ ကိစ္စများပေါ်ပေါက်လာပါက BXB ၏ ဆုံးဖြတ်ချက်သာ အတည်ဖြစ်ပါသည်။'),
                      const Gap(20),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onClose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppResources.colors.blue600,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('အိုကေ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bulletedText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 18)),
          Expanded(
              child: Text(text,
                  style: TextStyle(color: AppResources.colors.gray700))),
        ],
      ),
    );
  }

  Widget _plainText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: TextStyle(color: AppResources.colors.gray700)),
    );
  }
}
