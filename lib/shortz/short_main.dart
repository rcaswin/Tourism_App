import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:ionicons/ionicons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trip_to_kumari/shortz/content_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class YouTubeAPI {
  static const String youtubeApiBaseUrl =
      'https://www.googleapis.com/youtube/v3';
  static const int maxResults = 10;

  static Future<List<String>> fetchVideoIds(
      String apiKey, String channelId) async {
    final channelIdResponse = await http.get(
      '$youtubeApiBaseUrl/channels'
          '?part=contentDetails'
          '&id=$channelId'
          '&key=$apiKey' as Uri,
    );

    if (channelIdResponse.statusCode == 200) {
      final Map<String, dynamic> channelData =
          json.decode(channelIdResponse.body);
      final String playlistId = channelData['items'][0]['contentDetails']
          ['relatedPlaylists']['uploads'];

      final response = await http.get(
        '$youtubeApiBaseUrl/playlistItems'
            '?part=contentDetails'
            '&playlistId=$playlistId'
            '&maxResults=$maxResults'
            '&type=video'
            '&key=$apiKey' as Uri,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<String> videoIds = [];

        for (final item in data['items']) {
          final videoId = item['contentDetails']['videoId'];
          if (videoId != null) {
            videoIds.add(videoId);
          }
        }

        return videoIds;
      } else {
        throw Exception('Failed to load videos');
      }
    } else {
      throw Exception('Failed to get channel details');
    }
  }
}

class ShortzPage extends StatefulWidget {
  @override
  _ShortzPageState createState() => _ShortzPageState();
}

class _ShortzPageState extends State<ShortzPage> {
  late Future<List<String>> _futureVideos;
  late List<String> videos; // Declare the videos list

  @override
  void initState() {
    super.initState();
    _futureVideos = YouTubeAPI.fetchVideoIds(
        'AIzaSyDsOS0pVtXpk3P3aLXNuHVB-3CVQyWkHco', 'UCNHGo7ZF5UfohMFJPhbflGA');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<List<String>>(
        future: _futureVideos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            videos = snapshot.data!;

            return SafeArea(
              child: Stack(
                children: [
                  Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return ContentScreen(
                        src: videos[index],
                      );
                    },
                    itemCount: videos.length,
                    scrollDirection: Axis.vertical,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          iconSize: 30,
                          color: Colors.white,
                          icon: const Icon(Ionicons.chevron_back),
                        ),
                        Text(
                          "kumari Shortz",
                          style: GoogleFonts.imprima(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
