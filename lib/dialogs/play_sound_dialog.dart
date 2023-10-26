

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';




class MusicPlayerDialog extends StatefulWidget {
  final String audioPath;
  final String fileName;

  MusicPlayerDialog(this.audioPath, this.fileName);

  @override
  _MusicPlayerDialogState createState() => _MusicPlayerDialogState();
}

class _MusicPlayerDialogState extends State<MusicPlayerDialog> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = true;
  Duration _duration = const Duration();
  Duration _position = const Duration();


  @override
  void initState() {
    super.initState();
    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration;
      });
    });

    audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _position = position;
        //_playPause();

      });
    });

    audioPlayer.play(UrlSource(widget.audioPath));


  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }



  void _playPause() {
    if (isPlaying) {
      audioPlayer.pause();
    } else {
      audioPlayer.play(UrlSource(widget.audioPath));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22.0),
      ),
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'Music Player',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Slider(
              value: _position.inMilliseconds.toDouble(),
              onChanged: (value) {
                audioPlayer.seek(Duration(milliseconds: value.round()));
              },
              min: 0.0,
              max: _duration.inMilliseconds.toDouble(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${_position.inMinutes}:${(_position.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${_duration.inMinutes}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 22.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: isPlaying ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
                  onPressed: _playPause,
                  iconSize: 32.0,
                ),
                IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: () {
                    audioPlayer.stop();
                    setState(() {
                      isPlaying = false;
                      _position = const Duration(seconds: 0);
                    });
                  },
                  iconSize: 32.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


}



// void showTargetDialog(BuildContext context , String fileName){
//
//
//
//
//
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       // Create a custom widget for the dialog content
//     return AlertDialog(
//       title: Text('Music Player'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Slider(
//             value: _position.inMilliseconds.toDouble(),
//             onChanged: (value) {
//               audioPlayer.seek(Duration(milliseconds: value.round()));
//             },
//             min: 0.0,
//             max: _duration.inMilliseconds.toDouble(),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               IconButton(
//                 icon: isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
//                 onPressed: _playPause,
//               ),
//               IconButton(
//                 icon: Icon(Icons.stop),
//                 onPressed: () {
//                   audioPlayer.stop();
//                   setState(() {
//                     isPlaying = false;
//                   });
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//       actions: <Widget>[
//         TextButton(
//           child: Text('Close'),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ],
//     );
//   }
//
//
// }
