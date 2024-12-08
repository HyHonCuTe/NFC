// import 'package:nfc_01/screens/main_screen.dart';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:nfc_manager/nfc_manager.dart';
//
// class WordScreen extends StatefulWidget {
//   final List<WordData> wordList;
//
//   const WordScreen({super.key, required this.wordList});
//
//   @override
//   State<WordScreen> createState() => _WordScreenState();
// }
//
// class _WordScreenState extends State<WordScreen> {
//   WordData? scannedWord;
//   List<WordData> randomWords = [];
//   String? selectedLanguage = 'English';
//   bool isScanning = false;
//   bool isScanned = false;
//
//   Future<void> _startNfcScan() async {
//     setState(() {
//       isScanning = true;
//       isScanned = false;
//       scannedWord = null;
//     });
//
//     await NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
//       try {
//         var ndef = Ndef.from(tag);
//         if (ndef == null || ndef.cachedMessage == null) {
//           _showSnackbar('Thẻ NFC không hợp lệ hoặc không có dữ liệu.');
//           await NfcManager.instance.stopSession();
//           setState(() {
//             isScanning = false;
//           });
//           return;
//         }
//
//         String payload = String.fromCharCodes(ndef.cachedMessage!.records.first.payload);
//         String word = payload.startsWith('en') ? payload.substring(2) : payload;
//         word = word.substring(3);
//
//         _matchScannedWord(word);
//         await NfcManager.instance.stopSession();
//       } catch (e) {
//         _showSnackbar('Lỗi khi quét thẻ: $e');
//         await NfcManager.instance.stopSession();
//         setState(() {
//           isScanning = false;
//         });
//       }
//     });
//   }
//
//   void _matchScannedWord(String word) {
//     var wordData = widget.wordList.firstWhere(
//           (data) => data.englishWord.toLowerCase() == word.toLowerCase(),
//       orElse: () => WordData(
//         englishWord: '',
//         vietnameseWord: '',
//         englishAudio: '',
//         vietnameseAudio: '',
//         imagePath: '',
//       ),
//     );
//
//     setState(() {
//       scannedWord = wordData.englishWord.isNotEmpty ? wordData : null;
//       isScanning = false;
//       isScanned = scannedWord != null;
//     });
//   }
//
//   List<WordData> _generateRandomWords(WordData correctWord) {
//     final random = Random();
//     final randomWords = [correctWord];
//     final remainingWords = widget.wordList
//         .where((word) => word.englishWord != correctWord.englishWord)
//         .toList();
//
//     while (randomWords.length < 4 && remainingWords.isNotEmpty) {
//       final index = random.nextInt(remainingWords.length);
//       randomWords.add(remainingWords.removeAt(index));
//     }
//
//     randomWords.shuffle();
//     return randomWords;
//   }
//
//   void _handleWordSelection(WordData word) {
//     if (word == scannedWord) {
//       _playAudio(word.englishAudio);
//       _playAudio(word.vietnameseAudio);
//
//       setState(() {
//         // Hiển thị thông tin chi tiết của từ đã chọn đúng
//       });
//     } else {
//       _showSnackbar('Sai rồi! Hãy thử lại.');
//     }
//   }
//
//   void _playAudio(String audioPath) {
//     // Logic phát âm thanh
//     print('Playing audio: $audioPath');
//   }
//
//   void _showSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Học từ vựng với NFC')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             if (!isScanned)
//               ElevatedButton(
//                 onPressed: isScanning ? null : _startNfcScan,
//                 child: Text(isScanning ? 'Đang quét thẻ...' : 'Quét thẻ NFC'),
//               )
//             else
//               Column(
//                 children: [
//                   DropdownButton<String>(
//                     value: selectedLanguage,
//                     items: const [
//                       DropdownMenuItem(value: 'English', child: Text('Tiếng Anh')),
//                       DropdownMenuItem(value: 'Vietnamese', child: Text('Tiếng Việt')),
//                     ],
//                     onChanged: (value) {
//                       setState(() {
//                         selectedLanguage = value!;
//                         randomWords = _generateRandomWords(scannedWord!);
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   ...randomWords.map((word) {
//                     final displayText = selectedLanguage == 'English'
//                         ? word.englishWord
//                         : word.vietnameseWord;
//
//                     return ElevatedButton(
//                       onPressed: () => _handleWordSelection(word),
//                       child: Text(displayText),
//                     );
//                   }).toList(),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_01/screens/main_screen.dart';

class WordScreen extends StatefulWidget {
  final List<WordData> wordList;

  const WordScreen({super.key, required this.wordList});

  @override
  State<WordScreen> createState() => _WordScreenState();
}

class _WordScreenState extends State<WordScreen> {
  WordData? scannedWord;
  List<WordData> randomWords = [];
  String? selectedLanguage = 'English';
  bool isScanning = false;
  bool isScanned = false;

  // Function to start NFC scan
  Future<void> _startNfcScan() async {
    setState(() {
      isScanning = true;
      isScanned = false;
      scannedWord = null;
    });

    await NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      try {
        var ndef = Ndef.from(tag);
        if (ndef == null || ndef.cachedMessage == null) {
          _showSnackbar('Thẻ NFC không hợp lệ hoặc không có dữ liệu.');
          await NfcManager.instance.stopSession();
          setState(() {
            isScanning = false;
          });
          return;
        }

        String payload =
            String.fromCharCodes(ndef.cachedMessage!.records.first.payload);
        String word = payload.startsWith('en') ? payload.substring(2) : payload;
        word = word.substring(3);

        _matchScannedWord(word);
        await NfcManager.instance.stopSession();
      } catch (e) {
        _showSnackbar('Lỗi khi quét thẻ: $e');
        await NfcManager.instance.stopSession();
        setState(() {
          isScanning = false;
        });
      }
    });
  }

  // Function to match the word from the NFC tag with the word list
  void _matchScannedWord(String word) {
    var wordData = widget.wordList.firstWhere(
      (data) => data.englishWord.toLowerCase() == word.toLowerCase(),
      orElse: () => WordData(
        englishWord: '',
        vietnameseWord: '',
        englishAudio: '',
        vietnameseAudio: '',
        imagePath: '',
      ),
    );

    setState(() {
      scannedWord = wordData.englishWord.isNotEmpty ? wordData : null;
      isScanning = false;
      isScanned = scannedWord != null;
    });
  }

  // Function to generate random words
  List<WordData> _generateRandomWords(WordData correctWord) {
    final random = Random();
    final randomWords = [correctWord];
    final remainingWords = widget.wordList
        .where((word) => word.englishWord != correctWord.englishWord)
        .toList();

    while (randomWords.length < 4 && remainingWords.isNotEmpty) {
      final index = random.nextInt(remainingWords.length);
      randomWords.add(remainingWords.removeAt(index));
    }

    randomWords.shuffle();
    return randomWords;
  }

  // Function to handle word selection
  // void _handleWordSelection(WordData word) {
  //   if (word == scannedWord) {
  //     _playAudio(word.englishAudio);
  //     _playAudio(word.vietnameseAudio);
  //     _showSnackbar('Đúng rồi! Hãy thử thẻ tiếp theo.');
  //     setState(() {
  //       // Hiển thị thông tin chi tiết của từ đã chọn đúng
  //     });
  //   } else {
  //     _showSnackbar('Sai rồi!');
  //     // Hiển thị đáp án và đổi sang quét thẻ khác
  //   }
  // }

  void _handleWordSelection(WordData word) {
    if (word == scannedWord) {
      // Nếu chọn đúng, phát âm thanh và hiển thị thông tin chi tiết của từ
      _playAudio(word.englishAudio);
      _playAudio(word.vietnameseAudio);
      _showSnackbar('Đúng rồi! Hãy thử thẻ tiếp theo.');

      setState(() {
        // Hiển thị chi tiết của từ đã chọn đúng
        // Bạn có thể sử dụng các widget để hiển thị thông tin từ như image, nghĩa tiếng Việt, v.v.
      });
    } else {
      // Nếu chọn sai, hiển thị đáp án và yêu cầu quét lại thẻ
      _showSnackbar(
          'Sai rồi! Đáp án là: ${scannedWord?.englishWord ?? ''} - ${scannedWord?.vietnameseWord ?? ''}');

      // Quay lại trạng thái quét thẻ mới
      setState(() {
        scannedWord = null;
        randomWords.clear();
        isScanning = false;
        isScanned = false;
      });

      // Khởi động lại quét thẻ NFC
      _startNfcScan();
    }
  }

  // Function to play audio
  void _playAudio(String audioPath) {
    // Logic phát âm thanh
    print('Playing audio: $audioPath');
  }

  // Function to show a snackbar message
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // Function to reset the NFC scan state and start over
  void _resetScan() {
    setState(() {
      scannedWord = null;
      randomWords.clear();
      isScanning = false;
      isScanned = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Học từ vựng với NFC')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!isScanned)
              ElevatedButton(
                onPressed: isScanning ? null : _startNfcScan,
                child: Text(isScanning ? 'Đang quét thẻ...' : 'Quét thẻ NFC'),
              )
            else
              Column(
                children: [
                  DropdownButton<String>(
                    value: selectedLanguage,
                    items: const [
                      DropdownMenuItem(
                          value: 'English', child: Text('Tiếng Anh')),
                      DropdownMenuItem(
                          value: 'Vietnamese', child: Text('Tiếng Việt')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedLanguage = value!;
                        randomWords = _generateRandomWords(scannedWord!);
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  ...randomWords.map((word) {
                    final displayText = selectedLanguage == 'English'
                        ? word.englishWord
                        : word.vietnameseWord;

                    return ElevatedButton(
                      onPressed: () => _handleWordSelection(word),
                      child: Text(displayText),
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _resetScan,
                    child: const Text('Quét lại thẻ và học tiếp'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
