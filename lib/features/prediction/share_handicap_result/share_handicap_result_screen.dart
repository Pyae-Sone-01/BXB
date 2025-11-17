import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bxb/features/prediction/share_handicap_result/view_model/share_handicap_view_model.dart';
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

class ShareHandicapResultScreen extends ConsumerStatefulWidget {
  final int orderId;
  const ShareHandicapResultScreen({super.key, required this.orderId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShareHandicapResultScreenState();
}

class _ShareHandicapResultScreenState
    extends ConsumerState<ShareHandicapResultScreen> {
  final GlobalKey<_OverRepaintBoundaryState> _globalKey = GlobalKey();
  Uint8List? _imageByteData;
  String? _tempImagPath;

  @override
  void initState() {
    Future.microtask(() {
      ref.read(shareHandicapVM).initializedData(id: widget.orderId);
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
    final isLoading = ref.watch(shareHandicapState.select((s) => s.isLoading));
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
                                    _buildPredicitonDetail(),
                                    _buildRoi(),
                                    _buildBottomAdsSection(),
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
                    ),
                  ),
                  _buildButtomSection(),
                ],
              ));
  }

  Widget _buildBannerSection() {
    final data = ref.watch(shareHandicapState.select((s) => s.data));
    bool isWon = (data?.status != "lose");
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: BoxDecoration(
        color: AppResources.colors.blue700,
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
          Column(
            children: [
              CustomImageWidget(
                AppResources.assets.images.logo,
                width: 150,
              ),
              const Gap(50),
              Text(
                data?.title ?? "",
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Gap(15),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white70),
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            children: [
                          TextSpan(
                            text: data?.homeTeam ?? "",
                          ),
                          if (data?.predictionType == "body" &&
                              (data?.isHomeTeamUpper ?? false))
                            TextSpan(
                              text:
                                  " (${data?.handicapValue?.withSignPrefix(withoutPlusSign: true, withoutSpace: true)}${data?.handicapPrice?.withSignPrefix(withoutSpace: true)})",
                              style:
                                  TextStyle(color: Colors.blueAccent.shade100),
                            )
                        ])),
                    Text(
                      "Vs",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent.shade100),
                    ),
                    RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            children: [
                          TextSpan(
                            text: data?.awayTeam ?? "",
                          ),
                          if (data?.predictionType == "body" &&
                              !(data?.isHomeTeamUpper ?? false))
                            TextSpan(
                              text:
                                  " (${data?.handicapValue?.withSignPrefix(withoutPlusSign: true, withoutSpace: true)}${data?.handicapPrice?.withSignPrefix(withoutSpace: true)})",
                              style:
                                  TextStyle(color: Colors.blueAccent.shade100),
                            )
                        ])),
                    const Gap(10),
                    Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        data?.score ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppResources.colors.blue800),
                      ),
                    ),
                    const Gap(10),
                    if (data?.predictionType == "goal_total")
                      Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(10)),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: "Goal Total",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                      text: "  ${data?.score}",
                                      style: TextStyle(color: Colors.yellow))
                                ]),
                          )),
                    if (data?.status != "lose") ...[
                      const Gap(15),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.amber.shade300,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Text(
                              "ပြန်ရငွေ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const Gap(5),
                            Text(
                              "${data?.returnedCoin?.toPricing}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                          ],
                        ),
                      ),
                    ],
                    Gap(15),
                    Text(
                      data?.body ?? "",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          ),
          ...const [
            Positioned(
              top: 16,
              left: 16,
              child: Text(
                "⚽",
                style: TextStyle(fontSize: 60, color: Colors.white10),
              ),
            ),
            Positioned(
              top: 32,
              right: 32,
              child: Text(
                "🎯",
                style: TextStyle(fontSize: 50, color: Colors.white10),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 80,
              child: Text(
                "💰",
                style: TextStyle(fontSize: 40, color: Colors.white10),
              ),
            ),
            Positioned(
              right: 48,
              bottom: 32,
              child: Text(
                "✨",
                style: TextStyle(fontSize: 50, color: Colors.white10),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildPredicitonDetail() {
    final data = ref.watch(shareHandicapState.select((s) => s.data));
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomImageWidget(
                AppResources.assets.icons.target,
                width: 15,
                color: AppResources.colors.blue600,
              ),
              const Gap(5),
              Text(
                "လောင်းငွေအသေးစိတ်",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "လောင်းငွေ",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.grey),
                    ),
                    Text("${data?.predictedCoin?.toPricing}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        )),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "ရွေးချယ်မူ",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.grey),
                    ),
                    Text(data?.predictionSide ?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppResources.colors.blue700,
                        )),
                  ],
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "ရငွေ",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.grey),
                    ),
                    Text("${data?.returnedCoin?.toPricing}",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppResources.colors.blue800)),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data?.status == "lose" ? "အရူံး" : "အနိုင်",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                        "${data?.status != "lose" ? "+" : ""}${data?.winOrLoseCoin?.toPricing}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: data?.status == "lose"
                                ? Colors.red
                                : AppResources.colors.blue800)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRoi() {
    final data = ref.watch(shareHandicapState.select((s) => s.data));
    if (data?.status == "lose") return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blue.shade100.withAlpha(50),
          border: Border.all(color: Colors.blue.shade200),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomImageWidget(
                        AppResources.assets.icons.trending,
                        width: 15,
                        color: AppResources.colors.blue600,
                      ),
                      const Gap(5),
                      Text(
                        "ROI",
                        style: TextStyle(
                          color: AppResources.colors.blue600,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  Text(
                    data?.roi ?? "",
                    style: TextStyle(
                        color: AppResources.colors.blue800,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 50,
              width: 50,
              child: VerticalDivider(
                thickness: 1,
                color: Colors.blue.shade200,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomImageWidget(
                        AppResources.assets.icons.target,
                        color: AppResources.colors.blue600,
                        width: 15,
                      ),
                      const Gap(5),
                      Text(
                        "Result",
                        style: TextStyle(
                          color: AppResources.colors.blue600,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  Text(
                    data?.status ?? "",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ],
        ),
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

  Widget _buildButtomSection() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      color: Colors.white,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _shareImage,
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
            onPressed: _saveImageToGallery,
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
