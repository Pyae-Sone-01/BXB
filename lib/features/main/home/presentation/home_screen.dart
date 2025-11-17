import 'package:bxb/features/main/home/presentation/drawer_screen.dart';
import 'package:bxb/router/router.dart';
import 'package:bxb/services/coin/models/bff_coin_model.dart';
import 'package:bxb/utils/common/dialog_manager/dialog_manager.dart';
import 'package:bxb/utils/common/widgets/custom_image_widget.dart';
import 'package:bxb/utils/extension/num_extension.dart';
import 'package:bxb/utils/themes/app_resources.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../home_view_model.dart';
part '_widget/_wallet_info_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with RouteAware {
  @override
  void initState() {
    super.initState();

    Future.microtask(
        () => ref.read(homeViewModelImplProvider.notifier).initializeData());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(homeViewModelImplProvider.notifier)
          .showRuleAndRegulationDialog(context);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(
        this, ModalRoute.of(context)! as PageRoute<dynamic>);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    ref.read(homeViewModelImplProvider.notifier).initializeData();
  }

  @override
  Widget build(BuildContext context) {
    final userData =
        ref.watch(homeViewModelImplProvider.select((s) => s.userData));
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Builder(
          builder: (context) => Row(
            children: [
              GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 16,
                  child: Icon(
                    Icons.person,
                    color: AppResources.colors.blue700,
                  ),
                ),
              ),
              const Gap(5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Profile",
                    style: TextStyle(
                        fontSize: 11,
                        color: AppResources.colors.blue200,
                        fontWeight: FontWeight.normal),
                  ),
                  Text(
                    userData?.name ?? "",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              )
            ],
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              DialogManger.showSupportDialog(context);
            },
            child: CircleAvatar(
              backgroundColor: AppResources.colors.blue600,
              radius: 16,
              child: CustomImageWidget(
                AppResources.assets.icons.support,
                color: Colors.white,
                width: 20,
              ),
            ),
          ),
          const Gap(16),
          GestureDetector(
            onTap: () {
              context.pushNamed(RouteNames.misc.notification);
            },
            child: Stack(
              alignment: AlignmentGeometry.topRight,
              children: [
                CircleAvatar(
                    backgroundColor: AppResources.colors.blue600,
                    radius: 16,
                    child: const Icon(
                      Icons.notifications,
                      color: Colors.white,
                      size: 20,
                    )),
                const Positioned(
                    child: CircleAvatar(
                  radius: 4,
                  backgroundColor: Colors.red,
                ))
              ],
            ),
          ),
          const Gap(16),
        ],
      ),
      backgroundColor: Colors.white,
      drawer: const DrawerScreen(),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          ref.read(homeViewModelImplProvider.notifier).initializeData();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const _WalletInfoWidget(),
              // Feature Grid
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    _FeatureCard(
                        onTap: () async {
                          context.pushNamed(RouteNames.fixture.accumulator);
                        },
                        icon: AppResources.assets.images.filed3d,
                        label: 'မောင်း'),
                    _FeatureCard(
                        onTap: () {
                          context.pushNamed(RouteNames.fixture.handicap);
                        },
                        icon: AppResources.assets.images.football3d,
                        label: 'ဘော်ဒီ/ဂိုးပေါင်း'),
                    _FeatureCard(
                        onTap: () {
                          context
                              .pushNamed(RouteNames.prediciton.onGoingHistory);
                        },
                        icon: AppResources.assets.images.alarmClock,
                        label: 'လောင်းထားသောပွဲများ'),
                    _FeatureCard(
                        onTap: () {
                          context
                              .pushNamed(RouteNames.prediciton.finishedHistory);
                        },
                        icon: AppResources.assets.images.calendar3d,
                        label: 'လောင်းပြီးသောပွဲများ'),
                    _FeatureCard(
                        onTap: () {
                          context.pushNamed(RouteNames.coin.coinHistory);
                        },
                        icon: AppResources.assets.images.money3d,
                        label: 'ငွေစာရင်းများ'),
                    _FeatureCard(
                        onTap: () {
                          context.pushNamed(RouteNames.fixture.score);
                        },
                        icon: AppResources.assets.images.whistle3d,
                        label: 'ပွဲရလဒ်များ'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  const _FeatureCard(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: const Color(0xFFF2F6FF),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey.shade200,
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageWidget(icon, width: 80, height: 80),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
