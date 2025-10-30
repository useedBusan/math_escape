import 'package:just_audio/just_audio.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _characterPlayer = AudioPlayer();
  final AudioPlayer _bgmPlayer = AudioPlayer();

  double _characterVolume = 0.7;
  double _bgmVolume = 0.1;

  double get characterVolume => _characterVolume;
  double get bgmVolume => _bgmVolume;

  Future<void> setCharacterVolume(double volume) async {
    _characterVolume = volume.clamp(0.0, 1.0);
    await _characterPlayer.setVolume(_characterVolume);
  }

  Future<void> setBgmVolume(double volume) async {
    _bgmVolume = volume.clamp(0.0, 1.0);
    await _bgmPlayer.setVolume(_bgmVolume);
  }

  Future<void> playCharacterAudio(String assetPath) async {
    await _characterPlayer.stop();
    await _characterPlayer.setAudioSource(AudioSource.asset(assetPath));
    await _characterPlayer.setVolume(_characterVolume);
    await _characterPlayer.play();
  }

  Future<void> playBgm(String assetPath) async {
    await _bgmPlayer.stop();
    await _bgmPlayer.setAudioSource(AudioSource.asset(assetPath));
    await _bgmPlayer.setLoopMode(LoopMode.one);
    await _bgmPlayer.setVolume(_bgmVolume);
    await _bgmPlayer.play();
  }

  Future<void> stopBgm() async {
    await _bgmPlayer.stop();
  }

  Future<void> stopCharacter() async {
    await _characterPlayer.stop();
  }

  void dispose() {
    _characterPlayer.dispose();
    _bgmPlayer.dispose();
  }
}


