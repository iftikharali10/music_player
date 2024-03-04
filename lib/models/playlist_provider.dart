import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  // Playlist of Songs
  final List<Song> _playlist = [
    // song 1
    Song(
      songName: "Rumbling",
      artistName: "SIM",
      albumArtImagePath: "assets/images/imagea.jpg",
      audioPath: "audio/rumbling.mp3",
    ),

    // Song 2
    Song(
      songName: "Aot",
      artistName: "TK",
      albumArtImagePath: "assets/images/imageb.jpg",
      audioPath: "audio/rumbling.mp3",
    ),

    // song 3
    Song(
      songName: "Aot ED",
      artistName: "Linked Horizon",
      albumArtImagePath: "assets/images/imagec.jpg",
      audioPath: "audio/rumbling.mp3",
    ),
  ];

  // current song playing index
  int? _currentSongIndex;
  /*

  A U D I O P L A Y E R

  */

  // audio player

  final AudioPlayer _audioPlayer = AudioPlayer();

  // duration

  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // constructor

  PlaylistProvider() {
    listenToDuration();
  }
  // initially not playing
  bool _isPlaying = false;

  // play the song

  void play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop(); // stop current song
    await _audioPlayer.play(AssetSource(path)); // play the new song
    _isPlaying = true;
    notifyListeners();
  }

  // pause current song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // resume playing
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // pause or resume

  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  // seek to a specific position in the current song

  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }
  // play next song

  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        // go to the next song if it's not the last song
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        // if it's the last song loop back to the first song
        currentSongIndex = 0;
      }
    }
  }

  // play previous song
  void playPreviousSong() async {
    // if more than 2 secs have passed restart the current song
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    }
    // if it's within first 2 secs of the song go to previous song 
    else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! -1;
      } else {
        // if it's first song loop back to last song
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  // listen to duration
  void listenToDuration() {
    // listen for total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });
    // listen for current duration

    _audioPlayer.onPositionChanged.listen((newPositon) {
      _currentDuration = newPositon;
      notifyListeners();
    });
    // listen for when the song is completed
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }
  // dispose audio player

  /*
      G E T T E R S 

  */

  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  /*
      
  S E T T E R S

  */

  set currentSongIndex(int? newindex) {
    // update current song index
    _currentSongIndex = newindex;

   if (newindex != null) {
     play(); // play the song at the new index
   } 

   // update UI
   notifyListeners();
  }
}
