import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:http/http.dart' as http;
import 'package:trip_to_kumari/mediaquery.dart';
import 'package:trip_to_kumari/player.dart';

class VideoListScreen extends StatefulWidget {
  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  late List<VideoData> _videos = []; // Initialize with an empty list

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  void _loadVideos() async {
    var apiKey =
        'AIzaSyDsOS0pVtXpk3P3aLXNuHVB-3CVQyWkHco'; // Replace with your actual YouTube API key
    var channelId = 'UCNHGo7ZF5UfohMFJPhbflGA';

    // Get the playlist ID for the uploaded videos
    var uploadsPlaylistUrl =
        'https://www.googleapis.com/youtube/v3/channels?part=contentDetails&id=$channelId&key=$apiKey';

    var uploadsPlaylistResponse = await http.get(Uri.parse(uploadsPlaylistUrl));

    if (uploadsPlaylistResponse.statusCode == 200) {
      var uploadsPlaylistData = json.decode(uploadsPlaylistResponse.body);
      var uploadsPlaylistId = uploadsPlaylistData['items'][0]['contentDetails']
          ['relatedPlaylists']['uploads'];

      // Fetch regular videos from the uploads playlist
      var regularVideosUrl =
          'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=$uploadsPlaylistId&key=$apiKey';

      var regularVideosResponse = await http.get(Uri.parse(regularVideosUrl));

      if (regularVideosResponse.statusCode == 200) {
        var regularVideosData = json.decode(regularVideosResponse.body);

        _videos
            .addAll(List<VideoData>.from(regularVideosData['items'].map((item) {
          return VideoData(
            videoId: item['snippet']['resourceId']['videoId'],
            title: item['snippet']['title'],
            thumbnailUrl: item['snippet']['thumbnails']['high']['url'],
            description: item['snippet']['description'],
          );
        })));

        setState(() {});
      } else {
        throw Exception('Failed to load regular videos');
      }

      // Fetch shorts videos from the shorts playlist
      var shortsPlaylistId = uploadsPlaylistData['items'][0]['contentDetails']
          ['relatedPlaylists']['shorts'];

      var shortsVideosUrl =
          'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=$shortsPlaylistId&key=$apiKey';

      var shortsVideosResponse = await http.get(Uri.parse(shortsVideosUrl));

      if (shortsVideosResponse.statusCode == 200) {
        var shortsVideosData = json.decode(shortsVideosResponse.body);

        _videos
            .addAll(List<VideoData>.from(shortsVideosData['items'].map((item) {
          return VideoData(
            videoId: item['snippet']['resourceId']['videoId'],
            title: item['snippet']['title'],
            thumbnailUrl: item['snippet']['thumbnails']['default']['url'],
            description: item['snippet']['description'],
          );
        })));

        setState(() {});
      } else {
        throw Exception('Failed to load shorts videos');
      }
    } else {
      throw Exception('Failed to get uploads playlist ID');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        height: ContainerScaler.getContainerHeight(context, 150),
        child: _videos.isNotEmpty
            ? Row(
                children: _videos.map((video) {
                  return Padding(
                    padding: ResponsivePadding.fromLTRB(context, 8, 8, 8, 8),
                    child: Container(
                      width: ContainerScaler.getContainerWidth(context, 280),
                      height: ContainerScaler.getContainerHeight(context, 150),
                      child: Card(
                        elevation: 5,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    VideoPlayerScreen(videoData: video),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                video.thumbnailUrl,
                                height: ImageSizeScaler.scaleImageSize(
                                    context, 150),
                                width: ImageSizeScaler.scaleImageSize(
                                    context, 280),
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                (loadingProgress
                                                        .expectedTotalBytes ??
                                                    1)
                                            : null,
                                      ),
                                    );
                                  }
                                },
                                errorBuilder: (BuildContext context,
                                    Object error, StackTrace? stackTrace) {
                                  return Image.asset(
                                      'assets/placeholder_image.png');
                                },
                              ),
                              Padding(
                                padding: ResponsivePadding.fromLTRB(
                                    context, 7, 7, 7, 7),
                                child: Text(
                                  video.title,
                                  style: TextStyle(
                                    fontSize: TextSizeScaler.scaleTextSize(
                                        context, 17),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class VideoData {
  final String videoId;
  final String title;
  final String thumbnailUrl;
  final String description;

  VideoData(
      {required this.videoId,
      required this.title,
      required this.thumbnailUrl,
      required this.description});
}
