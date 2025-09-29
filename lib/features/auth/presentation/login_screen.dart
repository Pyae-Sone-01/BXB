import 'package:bxb/router/router.dart';
import 'package:bxb/utils/common/widgets/background_stack_widget.dart';
import 'package:bxb/utils/common/widgets/custom_image_widget.dart';
import 'package:bxb/utils/themes/app_resources.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: BackgroundStackWidget(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Gap(130),
              const Text(
                'WELCOME TO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Gap(20),
              CustomImageWidget(
                AppResources.assets.images.logo,
                width: 170,
              ),
              const SizedBox(height: 18),
              // Myanmar bullet points
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _bulletTextWidget('ရှင်းလင်းတဲ့မြန်မာကြေး'),
                    _bulletTextWidget('မြန်ဆန်တဲ့ ငွေသွင်းငွေထုတ်'),
                    _bulletTextWidget('၂၄နာရီ ဝန်ဆောင်မှု'),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Log in with phone button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.phone, color: Color(0xFF1846C7)),
                    label: const Text(
                      'LOG IN WITH PHONE',
                      style: TextStyle(
                        color: Color(0xFF1846C7),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      elevation: 2,
                    ),
                    onPressed: () {
                      context.pushNamed(RouteNames.auth.loginWith, extra: true);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 18),
              // Divider with Or
              const Row(
                children: [
                  const Expanded(
                    child: Divider(
                      color: Colors.white54,
                      thickness: 1,
                      indent: 20,
                      endIndent: 10,
                    ),
                  ),
                  const Text(
                    'Or',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      color: Colors.white54,
                      thickness: 1,
                      indent: 10,
                      endIndent: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              // Log in with email button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.mail, color: Colors.white),
                    label: const Text(
                      'LOG IN WITH EMAIL',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white38, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.white.withOpacity(0.08),
                    ),
                    onPressed: () {
                      context.pushNamed(RouteNames.auth.loginWith,
                          extra: false);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 38),
              // Underlined Myanmar text
              const Text(
                'အကောင့်ဘယ်လိုဖွင့်ရမလဲ?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                  decorationThickness: 2,
                ),
              ),
              const Spacer(),
              // Secure . Fast . Reliable
              const Padding(
                padding: EdgeInsets.only(bottom: 32.0),
                child: Text(
                  'Secure . Fast . Reliable',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _bulletTextWidget(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '\u2022',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
