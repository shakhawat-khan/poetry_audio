import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused, continued }

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> lines = [
    "I met a traveller from an antique land",
    "Who said: Two vast and trunkless legs of stone",
    "Stand in the desert...Near them, on the sand,",
    "Half sunk, a shattered visage lies, whose frown,",
    "And wrinkled lip, and sneer of cold command,",
    "Tell that its sculptor well those passions read",
    "Which yet survive, stamped on these lifeless things,",
    "The hand that mocked them, and the heart that fed:",
    "And on the pedestal these words appear:",
    "'My name is Ozymandias, king of kings:",
    "Look on my works, ye Mighty, and despair!'",
    "Nothing beside remains. Round the decay",
    "Of that colossal wreck, boundless and bare",
    "The lone and level sands stretch far away."
  ];
  // String? language;
  // String? engine;
  // double volume = 0.5;
  // double pitch = 1.0;
  // double rate = 0.5;

  int lineCount = -1;

  late FlutterTts _flutterTts;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    _flutterTts = FlutterTts();
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(.3);
    await _flutterTts.setPitch(1);
    await _flutterTts.setVolume(1.0);
  }

  Future<void> _speakWithPauses() async {
    await _flutterTts.awaitSpeakCompletion(true);
    Future<int> speak(String text) async {
      int result = await _flutterTts.speak(text);
      return result;
    }

    for (int i = 0; i < lines.length; i++) {
      setState(() {
        lineCount = i;
      });
      int test = await speak(lines[i].trim());
      log(test.toString());

      await Future.delayed(const Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio '),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: lines.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Text(
                      lines[index],
                      style: TextStyle(
                        color: lineCount == index ? Colors.red : Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                );
              },
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                await _speakWithPauses();
              },
              child: const Text('Play'))
        ],
      ),
    );
  }
}
