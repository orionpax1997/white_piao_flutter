import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import 'package:white_piao/bloc/series_bloc.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlayerPageState();
  }
}

class _PlayerPageState extends State<PlayerPage> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isError = false;

  Future<void> initializePlayer(src) async {
    _videoPlayerController = VideoPlayerController.network(src);
    try {
      await _videoPlayerController.initialize();
      _createChewieController();
      setState(() {});
    } catch (e) {
      setState(() {
        _isError = true;
      });
    }
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      hideControlsTimer: const Duration(seconds: 20),
      showControls: true,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    Wakelock.disable();
    super.dispose();
  }

  @override
  void initState() {
    Wakelock.enable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SeriesBloc.get(),
      child: BlocListener<SeriesBloc, SeriesState>(
        listenWhen: (previous, current) =>
            previous.loadingStreamUrl != current.loadingStreamUrl,
        listener: (context, state) {
          if (state.currentPlayStreamUrl != null) {
            initializePlayer(state.currentPlayStreamUrl);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: _chewieController != null &&
                  _chewieController!.videoPlayerController.value.isInitialized
              ? RawKeyboardListener(
                  focusNode: FocusNode(),
                  onKey: (event) {
                    if (event is RawKeyDownEvent) {
                      RawKeyEventDataAndroid data =
                          event.data as RawKeyEventDataAndroid;
                      switch (data.keyCode) {
                        case 19:
                          _chewieController =
                              _chewieController?.copyWith(showControls: true);
                          setState(() {});
                          break;
                        case 21:
                          _chewieController?.seekTo(Duration(
                              seconds: _videoPlayerController
                                      .value.position.inSeconds -
                                  30));
                          break;
                        case 22:
                          _chewieController?.seekTo(Duration(
                              seconds: _videoPlayerController
                                      .value.position.inSeconds +
                                  30));
                          break;
                        case 23:
                        case 66:
                          if (_chewieController!.isPlaying) {
                            _chewieController?.pause();
                          } else {
                            _chewieController?.play();
                          }
                          break;
                        default:
                          break;
                      }
                    }
                  },
                  child: Chewie(
                    controller: _chewieController!,
                  ),
                )
              : _isError
                  ? const Center(child: Text("视频加载出错了，换个源试试吧"))
                  : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
