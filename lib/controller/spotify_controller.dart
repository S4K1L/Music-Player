import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:music_player/api/api_services.dart';

class SpotifyController extends GetxController {
  final audioPlayer = AudioPlayer();
  var isLoading = false.obs;
  var currentTrackIndex = 0.obs;
  var tracks = [].obs;
  var isPlaying = false.obs;

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }

  Future<dynamic> getAccessToken() async {
    try {
      final credentials = base64.encode(utf8.encode('$apiClientId:$apiClientSecret'));
      final response = await http.post(
        Uri.parse('https://accounts.spotify.com/api/token'),
        headers: {
          'Authorization': 'Basic $credentials',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'grant_type': 'client_credentials'},
      );

      if (response.statusCode == 200) {
        final accessToken = jsonDecode(response.body)['access_token'];
        return accessToken;
      } else {
        throw Exception('Failed to fetch access token');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> fetchTracks(String playlistId) async {
    try {
      isLoading(true);
      final token = await getAccessToken();
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/playlists/$playlistId/tracks'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        tracks.value = jsonDecode(response.body)['items'];
      } else {
        Get.snackbar('Error', 'Failed to fetch tracks');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  void playTrack(int index) async {
    currentTrackIndex(index);
    final previewUrl = tracks[index]['track']['preview_url'];
    if (previewUrl != null) {
      await audioPlayer.setUrl(previewUrl);
      audioPlayer.play();
      isPlaying(true);
    } else {
      Get.snackbar('Error', 'No preview available for this track');
    }
  }

  void togglePlayback() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
      isPlaying(false);
    } else {
      audioPlayer.play();
      isPlaying(true);
    }
  }

  void playNextTrack() {
    if (currentTrackIndex.value < tracks.length - 1) {
      playTrack(currentTrackIndex.value + 1);
    }
  }

  void playPreviousTrack() {
    if (currentTrackIndex.value > 0) {
      playTrack(currentTrackIndex.value - 1);
    }
  }
}
