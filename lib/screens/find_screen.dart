// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:nfc_manager/nfc_manager.dart';
// import 'package:nfc_01/screens/main_screen.dart';

// class FindScreen extends StatefulWidget {
//   final List<WordData> wordList;

//   const FindScreen({super.key, required this.wordList});

//   @override
//   _FindScreenState createState() => _FindScreenState();
// }

// class _FindScreenState extends State<FindScreen> {
//   String selectedMode = 'English'; // Chế độ mặc định
//   WordData? currentWord;
//   bool isScanning = false;
//   bool isScanned = false;

//   // Hàm bắt đầu quét NFC
//   Future<void> _startNfcScan() async {
//     setState(() {
//       isScanning = true;
//       isScanned = false;
//     });

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

//         String payload =
//             String.fromCharCodes(ndef.cachedMessage!.records.first.payload);
//         String word = payload.startsWith('en') ? payload.substring(2) : payload;
//         word = word.substring(3);

//         _checkScannedWord(word);
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

//   // Hàm chọn từ ngẫu nhiên từ danh sách
//   WordData _getRandomWord() {
//     final random = Random();
//     return widget.wordList[random.nextInt(widget.wordList.length)];
//   }

//   // Hàm kiểm tra từ quét có đúng hay không
//   // void _checkScannedWord(String word) {
//   //   if (selectedMode == 'English' &&
//   //       word.toLowerCase() == currentWord?.englishWord.toLowerCase()) {
//   //     _showSnackbar('Đúng rồi!');
//   //   } else if (selectedMode == 'Vietnamese' &&
//   //       word.toLowerCase() == currentWord?.vietnameseWord.toLowerCase()) {
//   //     _showSnackbar('Đúng rồi!');
//   //   } else {
//   //     _showSnackbar('Sai rồi! Hãy thử lại.');
//   //     // Chọn từ mới để thử lại
//   //     setState(() {
//   //       currentWord = _getRandomWord();
//   //       isScanning = false;
//   //       isScanned = false;
//   //     });
//   //   }
//   // }

//   void _checkScannedWord(String word) {
//     // So sánh từ quét với từ tiếng Anh hoặc tiếng Việt tùy vào chế độ
//     if (selectedMode == 'English' &&
//         word.toLowerCase() == currentWord?.englishWord.toLowerCase()) {
//       _showSnackbar('Đúng rồi!');
//     } else if (selectedMode == 'Vietnamese' &&
//         word.toLowerCase() == currentWord?.englishWord.toLowerCase()) {
//       _showSnackbar('Đúng rồi!');
//     } else if (selectedMode == 'Listen in English' &&
//         word.toLowerCase() == currentWord?.englishWord.toLowerCase()) {
//       _showSnackbar('Đúng rồi!');
//     } else if (selectedMode == 'Listen in Vietnamese' &&
//         word.toLowerCase() == currentWord?.englishWord.toLowerCase()) {
//       _showSnackbar('Đúng rồi!');
//     } else {
//       _showSnackbar('Sai rồi! Hãy thử lại.');
//       // Chọn từ mới để thử lại
//       setState(() {
//         currentWord = _getRandomWord();
//         isScanning = false;
//         isScanned = false;
//       });
//     }
//   }

//   // Hiển thị Snackbar với thông báo
//   void _showSnackbar(String message) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(message)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (currentWord == null) {
//       currentWord =
//           _getRandomWord(); // Lấy từ ngẫu nhiên khi lần đầu vào màn hình
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text('Chọn chế độ học từ vựng')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Dropdown chọn chế độ học
//             DropdownButton<String>(
//               value: selectedMode,
//               items: const [
//                 DropdownMenuItem(value: 'English', child: Text('Tiếng Anh')),
//                 DropdownMenuItem(
//                     value: 'Vietnamese', child: Text('Tiếng Việt')),
//                 DropdownMenuItem(
//                     value: 'Listen in English', child: Text('Nghe Tiếng Anh')),
//                 DropdownMenuItem(
//                     value: 'Listen in Vietnamese',
//                     child: Text('Nghe Tiếng Việt')),
//               ],
//               onChanged: (value) {
//                 setState(() {
//                   selectedMode = value!;
//                   currentWord = _getRandomWord();
//                   isScanning = false;
//                   isScanned = false;
//                 });
//               },
//             ),
//             const SizedBox(height: 16),
//             // Hiển thị từ vựng
//             Text(
//               selectedMode == 'English'
//                   ? currentWord!.englishWord
//                   : currentWord!.vietnameseWord,
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: isScanning ? null : _startNfcScan,
//               child: Text(isScanning ? 'Đang quét thẻ...' : 'Quét thẻ NFC'),
//             ),
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
import 'package:flutter_tts/flutter_tts.dart';

class FindScreen extends StatefulWidget {
  final List<WordData> wordList;

  const FindScreen({super.key, required this.wordList});

  @override
  _FindScreenState createState() => _FindScreenState();
}

class _FindScreenState extends State<FindScreen> {
  String selectedMode = 'English'; // Chế độ mặc định
  WordData? currentWord;
  bool isScanning = false;
  bool isScanned = false;
  bool isListening = false; // Biến lưu trạng thái nghe

  // Tạo đối tượng FlutterTTS để phát âm
  final FlutterTts flutterTts = FlutterTts();

  // Hàm bắt đầu quét NFC
  Future<void> _startNfcScan() async {
    setState(() {
      isScanning = true;
      isScanned = false;
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

        _checkScannedWord(word);
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

  // Hàm chọn từ ngẫu nhiên từ danh sách
  WordData _getRandomWord() {
    final random = Random();
    return widget.wordList[random.nextInt(widget.wordList.length)];
  }

  // Hàm kiểm tra từ quét có đúng hay không
  void _checkScannedWord(String word) {
    // So sánh từ quét với từ tiếng Anh hoặc tiếng Việt tùy vào chế độ
    if (selectedMode == 'English' &&
        word.toLowerCase() == currentWord?.englishWord.toLowerCase()) {
      _showSnackbar('Đúng rồi!');
    } else if (selectedMode == 'Vietnamese' &&
        word.toLowerCase() == currentWord?.englishWord.toLowerCase()) {
      _showSnackbar('Đúng rồi!');
    } else if (selectedMode == 'Listen in English' &&
        word.toLowerCase() == currentWord?.englishWord.toLowerCase()) {
      _showSnackbar('Đúng rồi!');
    } else if (selectedMode == 'Listen in Vietnamese' &&
        word.toLowerCase() == currentWord?.englishWord.toLowerCase()) {
      _showSnackbar('Đúng rồi!');
    } else {
      _showSnackbar('Sai rồi! Hãy thử lại.');
      // Chọn từ mới để thử lại
      setState(() {
        currentWord = _getRandomWord();
        isScanning = false;
        isScanned = false;
      });
    }
  }

  // Hàm phát âm từ vựng
  Future<void> _speakWord() async {
    setState(() {
      isListening = true; // Đánh dấu trạng thái đang nghe
    });

    String textToSpeak = selectedMode == 'Listen in English'
        ? currentWord!.englishWord
        : currentWord!.vietnameseWord;

    await flutterTts.speak(textToSpeak);
    flutterTts.setCompletionHandler(() {
      setState(() {
        isListening = false; // Đánh dấu nghe xong
      });
    });
  }

  // Hiển thị Snackbar với thông báo
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (currentWord == null) {
      currentWord =
          _getRandomWord(); // Lấy từ ngẫu nhiên khi lần đầu vào màn hình
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Chọn chế độ học từ vựng')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Dropdown chọn chế độ học
            DropdownButton<String>(
              value: selectedMode,
              items: const [
                DropdownMenuItem(value: 'English', child: Text('Tiếng Anh')),
                DropdownMenuItem(
                    value: 'Vietnamese', child: Text('Tiếng Việt')),
                DropdownMenuItem(
                    value: 'Listen in English', child: Text('Nghe Tiếng Anh')),
                DropdownMenuItem(
                    value: 'Listen in Vietnamese',
                    child: Text('Nghe Tiếng Việt')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedMode = value!;
                  currentWord = _getRandomWord();
                  isScanning = false;
                  isScanned = false;
                });
              },
            ),
            const SizedBox(height: 16),
            // Hiển thị từ vựng
            Text(
              selectedMode == 'English'
                  ? currentWord!.englishWord
                  : currentWord!.vietnameseWord,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Nút Nghe
            if (selectedMode == 'Listen in English' ||
                selectedMode == 'Listen in Vietnamese')
              ElevatedButton(
                onPressed: isListening ? null : _speakWord,
                child: Text(isListening ? 'Đang phát âm...' : 'Nghe từ vựng'),
              ),
            const SizedBox(height: 16),
            // Nút quét NFC
            ElevatedButton(
              onPressed: isScanning || isListening ? null : _startNfcScan,
              child: Text(isScanning ? 'Đang quét thẻ...' : 'Quét thẻ NFC'),
            ),
          ],
        ),
      ),
    );
  }
}
