import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/controller/spotify_controller.dart';

class MusicPlayerScreen extends StatelessWidget {
  final SpotifyController spotifyController = Get.find<SpotifyController>();
  MusicPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        actions: const [Icon(Icons.more_vert, color: Colors.white)],
      ),
      body: Obx(() {
        if (spotifyController.tracks.isEmpty) return Container();

        final currentTrack =
        spotifyController.tracks[spotifyController.currentTrackIndex.value]
        ['track'];

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentTrack['name'],
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            Text(
              currentTrack['artists'][0]['name'],
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            Spacer(),
            CircleAvatar(
              radius: 100,
              backgroundImage: NetworkImage(
                currentTrack['album']['images'][0]['url'],
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.skip_previous, color: Colors.white),
                  onPressed: spotifyController.playPreviousTrack,
                ),
                IconButton(
                  icon: Icon(
                    spotifyController.isPlaying.value
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: spotifyController.togglePlayback,
                ),
                IconButton(
                  icon: Icon(Icons.skip_next, color: Colors.white),
                  onPressed: spotifyController.playNextTrack,
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
