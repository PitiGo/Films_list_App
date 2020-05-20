import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerPage extends StatefulWidget {

  final String videoId;
  final String caption;

  const VideoPlayerPage({Key key, this.videoId,this.caption}) : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  YoutubePlayerController _controller;

  @override
  void initState() {
    print('videoID:${widget.videoId}');

    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        // forceHideAnnotation: true,
        controlsVisibleAtStart: true,
        captionLanguage: widget.caption,
         
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,

      bottomActions: [
        CurrentPosition(),
        ProgressBar(isExpanded: true),
      ],
      //  videoProgressIndicatorColor: Colors.amber,
      progressColors: ProgressBarColors(
        playedColor: Colors.amber,
        handleColor: Colors.amberAccent,
      ),
      onReady: () {
        print('Player is ready.');
      },
      onEnded: (metadata) {
        Navigator.pop(context);
      },
    );
  }
}
