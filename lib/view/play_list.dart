import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/controller/spotify_controller.dart';

import 'music_player.dart';

class PlaylistScreen extends StatelessWidget {
  final SpotifyController spotifyController = Get.put(SpotifyController());

  PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playlist'),
      ),
      body: Obx(() {
        if (spotifyController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: spotifyController.tracks.length,
          itemBuilder: (context, index) {
            final track = spotifyController.tracks[index]['track'];
            return ListTile(
              title: Text(track['name']),
              subtitle: Text(track['artists'][0]['name']),
              onTap: () {
                spotifyController.playTrack(index);
                Get.to(() => MusicPlayerScreen());
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => spotifyController.fetchTracks('YOUR_PLAYLIST_ID'),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
