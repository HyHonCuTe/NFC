import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_01/screens/main_screen.dart';

class WriteScreen extends StatefulWidget {
  final List<WordData> wordList;

  const WriteScreen({super.key, required this.wordList});

  @override
  _WriteScreenState createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  String? _selectedWord; // Từ tiếng Anh được chọn
  bool _isWaiting = false; // Trạng thái chờ đợi
  String _statusMessage = ''; // Thông báo trạng thái

  // Ghi từ vào thẻ NFC
  Future<void> _writeTag(String word) async {
    setState(() {
      _isWaiting = true;
      _statusMessage = 'Đang chờ gắn thẻ NFC...';
    });

    await NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        setState(() {
          _isWaiting = false;
          _statusMessage = 'Thẻ không hỗ trợ NDEF hoặc không thể ghi!';
        });
        await NfcManager.instance.stopSession(errorMessage: _statusMessage);
        return;
      }

      try {
        NdefMessage message = NdefMessage([NdefRecord.createText(word)]);
        await ndef.write(message);
        setState(() {
          _isWaiting = false;
          _statusMessage = 'Ghi thành công: $word';
        });
        await NfcManager.instance.stopSession();
      } catch (e) {
        setState(() {
          _isWaiting = false;
          _statusMessage = 'Lỗi khi ghi thẻ: $e';
        });
        await NfcManager.instance.stopSession(errorMessage: _statusMessage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lấy danh sách từ tiếng Anh
    List<String> englishWords =
        widget.wordList.map((word) => word.englishWord).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Write NFC Tag'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Chọn từ cần ghi:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedWord,
              hint: const Text('Chọn một từ'),
              items: englishWords.map((word) {
                return DropdownMenuItem<String>(
                  value: word,
                  child: Text(word),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedWord = value;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _selectedWord != null
                  ? () => _writeTag(_selectedWord!)
                  : null, // Vô hiệu hóa nút nếu chưa chọn từ
              child: const Text('Ghi NFC'),
            ),
            const SizedBox(height: 16),
            if (_isWaiting)
              const Center(
                child: CircularProgressIndicator(),
              )
            else
              Text(
                _statusMessage,
                style: const TextStyle(fontSize: 16, color: Colors.green),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
