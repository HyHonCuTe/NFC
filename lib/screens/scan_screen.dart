import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_01/screens/main_screen.dart';

class ScanScreen extends StatefulWidget {
  final List<WordData> wordList;

  const ScanScreen({super.key, required this.wordList});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String scannedWord = '';
  WordData? matchedWord;
  bool isScanning = false;

  // Bắt đầu quét NFC
  void _startNfcScan() {
    setState(() {
      isScanning = true;
      scannedWord = '';
      matchedWord = null;
    });

    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        setState(() {
          scannedWord = 'Không thể đọc thẻ NFC này.';
          isScanning = false;
        });
        NfcManager.instance.stopSession();
        return;
      }

      try {
        var ndefMessage = await ndef.read();
        String wordFromTag =
            String.fromCharCodes(ndefMessage?.records.first.payload ?? []);
        wordFromTag = wordFromTag.startsWith('en')
            ? wordFromTag.substring(2)
            : wordFromTag;

        setState(() {
          scannedWord = wordFromTag;
        });
        print(wordFromTag);
        wordFromTag = wordFromTag.substring(3);

        // Kiểm tra từ trong danh sách
        _checkWordInList(wordFromTag);
      } catch (e) {
        setState(() {
          scannedWord = 'Lỗi khi đọc thẻ: $e';
          isScanning = false;
        });
        NfcManager.instance.stopSession();
      }
    });
  }

  // Kiểm tra từ trong danh sách
  void _checkWordInList(String word) {
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
      matchedWord = wordData.englishWord.isNotEmpty ? wordData : null;
      isScanning = false;
    });

    NfcManager.instance.stopSession();
  }

  // Hàm giả lập phát âm thanh
  void _playAudio(String audioPath) {
    // TODO: Thêm logic phát âm thanh từ đường dẫn `audioPath`.
    print('Playing audio: $audioPath');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan NFC Tag'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (isScanning)
              CircularProgressIndicator()
            else if (matchedWord != null) ...[
              Text(
                'Từ quét được: ${matchedWord!.englishWord}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              if (matchedWord!.imagePath.isNotEmpty)
                Image.asset(
                  matchedWord!
                      .imagePath, // Đường dẫn phải tương ứng với đường dẫn trong assets
                  height: 200,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 20),
              Text(
                'Vietnamese: ${matchedWord!.vietnameseWord}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _playAudio(matchedWord!.englishAudio),
                    icon: Icon(Icons.volume_up),
                    label: Text('Nghe tiếng Anh'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _playAudio(matchedWord!.vietnameseAudio),
                    icon: Icon(Icons.volume_up),
                    label: Text('Nghe tiếng Việt'),
                  ),
                ],
              ),
            ] else ...[
              Text(
                scannedWord.isEmpty ? 'Chưa quét thẻ' : scannedWord,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startNfcScan,
              child: const Text('Đọc thẻ NFC'),
            ),
          ],
        ),
      ),
    );
  }
}
