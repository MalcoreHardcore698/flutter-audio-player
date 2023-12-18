import 'package:audio_player/providers/provider_library.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ScreenLibrary extends StatelessWidget {
  const ScreenLibrary({super.key});

  @override
  Widget build(BuildContext context) {
    final library = context.watch<ProviderLibrary>().getLibrary();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Library',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        centerTitle: false,
        backgroundColor: const Color.fromRGBO(20, 24, 27, 1),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color.fromRGBO(31, 36, 40, 1),
            height: 1,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(20, 24, 27, 1),
        ),
        child: ListView(
          children: library.map((audio) {
            return Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromRGBO(31, 36, 40, 1),
                  ),
                ),
              ),
              child: ListTile(
                title: Text(
                  audio.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  audio.url,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.85),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(audio.preview),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                tileColor: Colors.transparent,
                onTap: () {
                  context.go('/audio-player', extra: audio);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
