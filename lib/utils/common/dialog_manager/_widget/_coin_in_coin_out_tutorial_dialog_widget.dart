part of '../dialog_manager.dart';

class _CoinInCoinOutTutorialDialogWidget extends StatefulWidget {
  final VoidCallback onClose;

  const _CoinInCoinOutTutorialDialogWidget({required this.onClose});

  @override
  State<_CoinInCoinOutTutorialDialogWidget> createState() =>
      _CoinInCoinOutTutorialDialogWidgetState();
}

class _CoinInCoinOutTutorialDialogWidgetState
    extends State<_CoinInCoinOutTutorialDialogWidget> {
  static const _videoUrl =
      'https://bff-stg-bcket.sgp1.digitaloceanspaces.com/transaction-tutorial.mp4';

  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _showControls = true;
  bool _isFullscreen = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(_videoUrl))
      ..addListener(_onVideoChanged)
      ..setLooping(false)
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _initialized = true);
        }
      });
  }

  void _onVideoChanged() {
    if (!mounted) return;
    // update UI for position / play state
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideoChanged);
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });

    if (_isFullscreen) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => _FullscreenVideoPlayer(
            controller: _controller,
            onExit: () {
              setState(() {
                _isFullscreen = false;
              });
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final dialogWidth = mediaQuery.size.width * 0.9;
    final videoHeight = dialogWidth * 9 / 16; // 16:9

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title row with close icon
            Row(
              children: [
                Expanded(
                  child: Text(
                    'ငွေသွင်းငွေထုတ်လုပ်နည်း',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                InkWell(
                  onTap: widget.onClose,
                  child: Icon(
                    Icons.close,
                    size: 22,
                    color: AppResources.colors.blue600,
                  ),
                ),
              ],
            ),
            const Gap(12),
            // Video container
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                  width: dialogWidth,
                  height: videoHeight,
                  color: Colors.black,
                  child: _initialized
                      ? GestureDetector(
                          onTap: () {
                            setState(() => _showControls = !_showControls);
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: VideoPlayer(_controller),
                              ),
                              if (_showControls)
                                const Positioned.fill(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black26,
                                          Colors.transparent,
                                          Colors.black26
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                  ),
                                ),
                              if (_showControls)
                                Positioned(
                                  left: 12,
                                  right: 12,
                                  bottom: 8,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              if (_controller.value.isPlaying) {
                                                _controller.pause();
                                              } else {
                                                _controller.play();
                                              }
                                            },
                                            icon: Icon(
                                              _controller.value.isPlaying
                                                  ? Icons.pause_circle_filled
                                                  : Icons.play_circle_fill,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                          Expanded(
                                            child: Slider(
                                              activeColor: Colors.white,
                                              inactiveColor: Colors.white38,
                                              min: 0,
                                              max: _controller.value.duration
                                                          .inMilliseconds
                                                          .toDouble() >
                                                      0
                                                  ? _controller.value.duration
                                                      .inMilliseconds
                                                      .toDouble()
                                                  : 1,
                                              value: _controller
                                                  .value.position.inMilliseconds
                                                  .toDouble()
                                                  .clamp(
                                                      0,
                                                      _controller.value.duration
                                                          .inMilliseconds
                                                          .toDouble()),
                                              onChanged: (v) {
                                                final pos = Duration(
                                                    milliseconds: v.toInt());
                                                _controller.seekTo(pos);
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                          IconButton(
                                            onPressed: _toggleFullscreen,
                                            icon: const Icon(
                                              Icons.fullscreen,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        )
                      : const LoadingWidget(
                          width: 30,
                          height: 30,
                        )),
            ),
            const Gap(16),
          ],
        ),
      ),
    );
  }
}

class _FullscreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  final VoidCallback onExit;

  const _FullscreenVideoPlayer({
    required this.controller,
    required this.onExit,
  });

  @override
  State<_FullscreenVideoPlayer> createState() => _FullscreenVideoPlayerState();
}

class _FullscreenVideoPlayerState extends State<_FullscreenVideoPlayer> {
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onVideoChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onVideoChanged);
    super.dispose();
  }

  void _onVideoChanged() {
    if (!mounted) return;
    setState(() {});
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          setState(() => _showControls = !_showControls);
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: widget.controller.value.aspectRatio,
                child: VideoPlayer(widget.controller),
              ),
            ),
            if (_showControls)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black54,
                        Colors.transparent,
                        Colors.black54
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            // Top controls
            if (_showControls)
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 8,
                right: 8,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        widget.onExit();
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        widget.onExit();
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.fullscreen_exit,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            // Bottom controls
            if (_showControls)
              Positioned(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).padding.bottom + 16,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (widget.controller.value.isPlaying) {
                              widget.controller.pause();
                            } else {
                              widget.controller.play();
                            }
                          },
                          icon: Icon(
                            widget.controller.value.isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_fill,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            activeColor: Colors.white,
                            inactiveColor: Colors.white38,
                            min: 0,
                            max: widget.controller.value.duration.inMilliseconds
                                        .toDouble() >
                                    0
                                ? widget
                                    .controller.value.duration.inMilliseconds
                                    .toDouble()
                                : 1,
                            value: widget
                                .controller.value.position.inMilliseconds
                                .toDouble()
                                .clamp(
                                    0,
                                    widget.controller.value.duration
                                        .inMilliseconds
                                        .toDouble()),
                            onChanged: (v) {
                              final pos = Duration(milliseconds: v.toInt());
                              widget.controller.seekTo(pos);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '${_formatDuration(widget.controller.value.position)} / ${_formatDuration(widget.controller.value.duration)}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
