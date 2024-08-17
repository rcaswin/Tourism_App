import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import 'package:trip_to_kumari/mediaquery.dart';
import 'package:trip_to_kumari/video.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatelessWidget {
  final VideoData videoData;

  const VideoPlayerScreen({Key? key, required this.videoData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 249, 237),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: ResponsiveMargin.fromLTRB(context, 0, 23, 0, 0),
              width: double.infinity,
              height: ContainerScaler.getContainerWidth(context, 280.0),
              child: Stack(
                children: [
                  YoutubePlayerBuilder(
                    player: YoutubePlayer(
                      controller: YoutubePlayerController(
                        initialVideoId: videoData.videoId,
                        flags: const YoutubePlayerFlags(
                          autoPlay: false,
                          mute: false,
                          controlsVisibleAtStart: false,
                          hideControls: true,
                        ),
                      ),
                    ),
                    builder: (context, player) {
                      return Positioned.fill(child: player);
                    },
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.7),
                      ),
                      child: IconButton(
                        icon: const Icon(BootstrapIcons.arrow_left_short,
                            color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      width: 40, // Adjust the width as needed
                      height: 40, // Adjust the height as needed
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.7),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          BootstrapIcons.share,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          _shareContent(context);
                        },
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.7),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.play_arrow,
                            color: Colors.white, size: 40),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FullScreenVideoPlayer(videoData: videoData),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    videoData.title,
                    style: GoogleFonts.inknutAntiqua(
                      fontSize: 19,
                      color: const Color.fromARGB(255, 0, 54, 64),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    videoData.description,
                    style: GoogleFonts.imprima(
                      fontSize: 15,
                      color: const Color.fromARGB(255, 0, 54, 64),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Related Videos',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareContent(BuildContext context) async {
    final String shareText =
        'Check out this video: ${videoData.title}\n https://www.youtube.com/watch?v=${videoData.videoId}';

    final bool isAppInstalled = await canLaunch('myapp://');

    if (isAppInstalled) {
      // If the app is installed, open the app-specific page
      await launch('myapp://specific-page');
    } else {
      // If the app is not installed, open a web URL
      await Share.share(shareText);
    }
  }
}

class FullScreenVideoPlayer extends StatelessWidget {
  final VideoData videoData;

  const FullScreenVideoPlayer({Key? key, required this.videoData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: YoutubePlayerController(
            initialVideoId: videoData.videoId,
            flags: const YoutubePlayerFlags(
              autoPlay: true,
              mute: false,
              forceHD: true,
            ),
          ),
          showVideoProgressIndicator: true,
          progressIndicatorColor: const Color.fromARGB(255, 7, 47, 114),
        ),
        builder: (context, player) {
          return Stack(
            children: [
              Center(
                child: player,
              ),
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 23, 0, 0),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.7),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
