import 'package:bxb/features/main/home/home_view_model.dart';
import 'package:bxb/utils/common/dialog_manager/dialog_manager.dart';
import 'package:bxb/utils/common/widgets/custom_image_widget.dart';
import 'package:bxb/utils/themes/app_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class DrawerScreen extends ConsumerWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(homeViewModelImplProvider).userData;
    return Drawer(
      backgroundColor: AppResources.colors.blue700,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo and language
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 16, left: 20, right: 20, bottom: 8),
                    child: Row(
                      children: [
                        // Logo (replace with your asset if needed)
                        CustomImageWidget(
                          AppResources.assets.images.logo,
                          width: 100,
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  const Gap(10),
                  // Account section
                  const Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text('ACCOUNT',
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            letterSpacing: 1)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppResources.colors.blue800,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person,
                                  color: Colors.white, size: 20),
                              const Gap(10),
                              Text(
                                user?.name ?? '',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                          const Gap(8),
                          Row(
                            children: [
                              const Icon(Icons.email,
                                  color: Colors.white, size: 20),
                              const Gap(10),
                              Flexible(
                                child: Text(
                                  user?.email ?? user?.phone ?? "",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(24),
                  // Menus section
                  const Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Text('MENUS',
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            letterSpacing: 1)),
                  ),
                  const Gap(4),
                  // Menu items
                  _DrawerMenuButton(
                    icon: Icons.vpn_key,
                    label: 'Agent Code ထည့်သွင်းရန်',
                    onTap: () {
                      DialogManger.showAddAgentCodeDialog(context,
                          onConfirm: (value) {});
                    },
                  ),
                  _DrawerMenuButton(
                    icon: Icons.password,
                    label: 'PIN ကို ပြောင်းလဲမည်',
                    onTap: () {},
                  ),
                  _DrawerMenuButton(
                    icon: Icons.tv,
                    label: 'ငွေသွင်းငွေထုတ်မှတ်တမ်း',
                    onTap: () {},
                  ),
                  _DrawerMenuButton(
                    icon: Icons.gavel,
                    label: 'စည်းမျဉ်းစည်းကမ်းများ',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                onTap: () {
                  ref.read(homeViewModelImplProvider.notifier).logout(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppResources.colors.red100,
                    border: Border.all(
                        color: AppResources.colors.red500, width: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: AppResources.colors.red500),
                      Gap(10),
                      Text('Log out',
                          style: TextStyle(
                              color: AppResources.colors.red700,
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios,
                          size: 20, color: AppResources.colors.red700),
                    ],
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

class _DrawerMenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _DrawerMenuButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: AppResources.colors.blue700, size: 28),
                const Gap(14),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: AppResources.colors.blue700,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios,
                    color: AppResources.colors.blue700, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
