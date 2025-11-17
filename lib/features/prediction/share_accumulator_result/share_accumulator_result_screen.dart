import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bxb/features/prediction/share_accumulator_result/view_model/share_accumulator_view_model.dart';

import 'package:bxb/utils/common/widgets/custom_image_widget.dart';
import 'package:bxb/utils/common/widgets/loading_widget.dart';
import 'package:bxb/utils/extension/num_extension.dart';
import 'package:bxb/utils/themes/app_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

part 'widgets/_fixture_match_item_widget.dart';

class ShareAccumulatorResultScreen extends ConsumerStatefulWidget {
  final int orderId;
  const ShareAccumulatorResultScreen({super.key, required this.orderId});

  @override
  ConsumerState<ShareAccumulatorResultScreen> createState() =>
      _ShareAccumulatorResultScreenState();
}

class _ShareAccumulatorResultScreenState
    extends ConsumerState<ShareAccumulatorResultScreen> {
  final GlobalKey<_OverRepaintBoundaryState> _globalKey = GlobalKey();
  Uint8List? _imageByteData;
  String? _tempImagPath;
  @override
  void initState() {
    Future.microtask(() {
      ref.read(shareAccumulatorVM).initializedData(id: widget.orderId);
    });
    super.initState();
  }

  _shareImage() async {
    if (_imageByteData == null) {
      await _captureFullPage();
    }
    if (_imageByteData != null && _tempImagPath == null) {
      await _saveImageToTemp();
    }
    if (_tempImagPath != null) {
      try {
        await SharePlus.instance
            .share(ShareParams(files: [XFile(_tempImagPath!)]));
      } catch (e) {
        print('Error sharing image: $e');
      }
    } else {
      print('Failed to save image for sharing');
    }
  }

  _saveImageToGallery() async {
    if (_imageByteData == null) {
      await _captureFullPage();
    }

    if (_imageByteData != null) {
      await ImageGallerySaverPlus.saveImage(
        _imageByteData!,
        name: "screenshot_${DateTime.now().millisecondsSinceEpoch}",
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Screenshot saved')),
        );
      }
    }
  }

  Future _captureFullPage() async {
    try {
      final boundary = _globalKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary;

      final double pixelRatio = MediaQuery.of(context).devicePixelRatio;
      final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);

      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        _imageByteData = byteData.buffer.asUint8List();
      } else {
        _imageByteData = null;
      }
    } catch (e) {
      debugPrint('Screenshot error: $e');
      _imageByteData = null;
    }
  }

  Future _saveImageToTemp() async {
    try {
      final directory = await getTemporaryDirectory();
      final imagePath =
          '${directory.path}/screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
      File imageFile = File(imagePath);
      await imageFile.writeAsBytes(_imageByteData!);

      _tempImagPath = imagePath;
    } catch (e) {
      print('Error saving image: $e');
      _tempImagPath = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(shareAccumulatorState.select((s) => s.isLoading));

    return Scaffold(
      appBar: isLoading ? AppBar() : null,
      body: isLoading
          ? const Center(
              child: LoadingWidget(),
            )
          : Column(
              children: [
                Expanded(
                    child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: OverRepaintBoundary(
                        key: _globalKey,
                        child: RepaintBoundary(
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                _buildBannerSection(),
                                _buildInfoSection(),
                                _buildFixtureSection(),
                                _buildBottomAdsSection(),
                                const Gap(15)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        left: 15,
                        top: 15,
                        child: GestureDetector(
                          onTap: () {
                            context.pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(100),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ))
                  ],
                )),
                _buildButtomSection(),
              ],
            ),
    );
  }

  Widget _buildBannerSection() {
    final data = ref.watch(shareAccumulatorState.select((s) => s.data));
    bool isWon = data?.winTeamsCount?.split('/').length == 2 &&
        data!.winTeamsCount!.split('/')[0] == data.winTeamsCount!.split('/')[1];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.yellow,
            Colors.amber,
          ],
        ),
        image: isWon
            ? DecorationImage(
                image: AssetImage(
                  AppResources.assets.gifs.celebration,
                ),
                fit: BoxFit.fitHeight,
              )
            : null,
      ),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                CustomImageWidget(
                  AppResources.assets.images.logo,
                  width: 150,
                ),
                const Gap(50),
                Text(
                  data?.title ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      color: AppResources.colors.blue900,
                      fontWeight: FontWeight.bold),
                ),
                if (data?.returnedCoin != 0)
                  Text(
                    "+ ${data?.returnedCoin?.toPricing}",
                    style: TextStyle(
                        fontSize: 22,
                        color: AppResources.colors.blue900,
                        fontWeight: FontWeight.bold),
                  ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppResources.colors.blue900,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    data?.winTeamsCount ?? "",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.yellow,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Text(
                  data?.body ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: AppResources.colors.blue900,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          const Positioned(
              child: Opacity(
            opacity: 0.2,
            child: Text(
              "🎯",
              style: TextStyle(fontSize: 35),
            ),
          )),
          const Positioned(
              right: 0,
              child: Opacity(
                opacity: 0.2,
                child: Text(
                  "💰",
                  style: TextStyle(fontSize: 40),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    final data = ref.watch(shareAccumulatorState.select((s) => s.data));
    final valueTextStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w500);
    final labelTextStyle =
        TextStyle(fontSize: 16, color: AppResources.colors.blue500);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                data?.roi ?? "",
                style: valueTextStyle.copyWith(
                  color: AppResources.colors.blue600,
                ),
              ),
              Text(
                "ROI",
                style: labelTextStyle,
              )
            ],
          ),
          Column(
            children: [
              Text(
                data?.accuracy ?? "",
                style: valueTextStyle.copyWith(color: Colors.green),
              ),
              Text(
                "Accuracy",
                style: labelTextStyle,
              )
            ],
          ),
          Column(
            children: [
              Text(
                data?.itemsCount.toString() ?? "",
                style: valueTextStyle.copyWith(color: Colors.red),
              ),
              Text(
                "မောင်း",
                style: labelTextStyle,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFixtureSection() {
    final data = ref.watch(shareAccumulatorState.select((s) => s.data));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "  ⚡ Winning Picks",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        ListView.separated(
          padding: EdgeInsets.all(20),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: data?.predictions?.length ?? 0,
          separatorBuilder: (context, index) => Gap(15),
          itemBuilder: (context, index) {
            final item = data!.predictions![index];
            return _FixtureMatchItemWidget(
              homeTeam: item.homeTeam ?? "",
              awayTeam: item.awayTeam ?? "",
              predictionSide: item.predictionSide ?? "",
              score: item.score ?? "",
              statusString: item.statusString ?? "",
              handicapPrice: item.handicapPrice ?? 0,
              handicapValue: item.handicapValue,
              predicitonType: item.predictionType ?? "",
              isHomeTeamUpper: item.isHomeTeamUpper ?? false,
              isWon: item.status?.contains("win") ?? false,
            );
          },
        )
      ],
    );
  }

  Widget _buildButtomSection() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      color: Colors.white,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              _shareImage();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.share),
                Gap(10),
                Text("Share My Victory  🎉"),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _saveImageToGallery();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppResources.colors.blue700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.download),
                Gap(10),
                Text("Save Screenshot"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAdsSection() {
    return Container(
      width: double.infinity,
      color: AppResources.colors.blue700,
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people,
                color: Colors.white,
              ),
              Gap(10),
              Text(
                "Join 50,000+ Winners on ballxbet",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Text(
            "ကိုယ့်ကိုယ်ကို ယုံကြည်လိုက်ပါ",
            style: TextStyle(color: Colors.white70),
          )
        ],
      ),
    );
  }
}

class OverRepaintBoundary extends StatefulWidget {
  final Widget child;
  const OverRepaintBoundary({super.key, required this.child});

  @override
  State<OverRepaintBoundary> createState() => _OverRepaintBoundaryState();
}

class _OverRepaintBoundaryState extends State<OverRepaintBoundary> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
