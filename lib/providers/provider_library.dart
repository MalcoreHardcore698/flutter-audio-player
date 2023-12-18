import 'package:audio_player/models/model_audio.dart';
import 'package:flutter/material.dart';

List<ModelAudio> library = [
  ModelAudio(
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    title: 'Imagine Dragons - Enemy',
    preview: 'https://upload.wikimedia.org/wikipedia/en/5/5c/Enemy_Imagine_Dragons.jpg',
  ),
  ModelAudio(
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
    title: 'Imagine Dragons - Follow You',
    preview: 'https://i1.sndcdn.com/artworks-gbSsBxf3nRWOHlb8-L6bJNg-t500x500.jpg',
  ),
  ModelAudio(
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
    title: 'Imagine Dragons - Natural',
    preview: 'https://i.scdn.co/image/ab67616d0000b273da6f73a25f4c79d0e6b4a8bd',
  ),
  ModelAudio(
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
    title: 'Imagine Dragons - Radioactive',
    preview: 'https://i.scdn.co/image/ab67616d0000b273b2b2747c89d2157b0b29fb6a',
  ),
  ModelAudio(
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
    title: 'Imagine Dragons - Thunder',
    preview: 'https://i.scdn.co/image/ab67616d0000b2735675e83f707f1d7271e5cf8a',
  ),
  ModelAudio(
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
    title: 'Imagine Dragons - Warriors',
    preview: 'https://upload.wikimedia.org/wikipedia/en/f/fb/Song_Cover_for_%22Warriors%22_by_Imagine_Dragons.jpg',
  ),
  ModelAudio(
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
    title: 'Imagine Dragons - Whatever It Takes',
    preview: 'https://i1.sndcdn.com/artworks-000634752964-eo9o9r-t500x500.jpg',
  ),
];

class ProviderLibrary with ChangeNotifier {
  final List<ModelAudio> _library = library;

  int get count => _library.length;

  void add(ModelAudio audio) {
    _library.add(audio);
    notifyListeners();
  }

  List<ModelAudio> getLibrary() => _library;

  void remove(ModelAudio audio) {
    _library.remove(audio);
    notifyListeners();
  }

  void reset() {
    _library.addAll(library);
    notifyListeners();
  }

  void clear() {
    _library.clear();
    notifyListeners();
  }
}
