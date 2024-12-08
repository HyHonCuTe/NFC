import 'package:flutter/material.dart';
import 'package:nfc_01/screens/scan_screen.dart';
import 'package:nfc_01/screens/write_screen.dart';
import 'home_screen.dart';
import 'word_screen.dart';
import 'find_screen.dart';

class WordData {
  final String englishWord;
  final String vietnameseWord;
  final String englishAudio;
  final String vietnameseAudio;
  final String imagePath;

  WordData({
    required this.englishWord,
    required this.vietnameseWord,
    required this.englishAudio,
    required this.vietnameseAudio,
    required this.imagePath,
  });
}

List<WordData> wordList = [
  WordData(
      englishWord: "apple",
      vietnameseWord: "quả táo",
      englishAudio: "assets/audio/en/apple.mp3",
      vietnameseAudio: "assets/audio/vn/apple.mp3",
      imagePath: "assets/images/apple.jpg"),
  WordData(
    englishWord: "banana",
    vietnameseWord: "quả chuối",
    englishAudio: "assets/audio/banana_en.mp3",
    vietnameseAudio: "assets/audio/banana_vn.mp3",
    imagePath: "assets/images/banana.jpg",
  ),
  WordData(
    englishWord: "potato",
    vietnameseWord: "củ khoai tây",
    englishAudio: "assets/audio/banana_en.mp3",
    vietnameseAudio: "assets/audio/banana_vn.mp3",
    imagePath: "assets/images/potato.jpg",
  ),
  WordData(
    englishWord: "orange",
    vietnameseWord: "quả cam",
    englishAudio: "assets/audio/banana_en.mp3",
    vietnameseAudio: "assets/audio/banana_vn.mp3",
    imagePath: "assets/images/orange.jpg",
  ),
];

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // List of screens
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      const HomeScreen(),
      ScanScreen(wordList: wordList),
      WordScreen(wordList: wordList),
      FindScreen(wordList: wordList),
      WriteScreen(wordList: wordList),
    ];
  }

  // Get icon color for BottomNavigationBar items
  Color _getIconColor(int index) {
    return _currentIndex == index ? Colors.blue : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text('Main Screen'),
          ),
      body: _screens[_currentIndex], // Render the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the current index on tap
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _getIconColor(0)), // Trang chủ
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info,
                color: _getIconColor(1)), // Đọc & hiển thị thông tin thẻ
            label: 'Scan & Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz,
                color: _getIconColor(2)), // Trò chơi chọn đúng từ
            label: 'Word Match',
          ),
          BottomNavigationBarItem(
            icon:
                Icon(Icons.search, color: _getIconColor(3)), // Trò chơi tìm thẻ
            label: 'Find Card',
          ),
          BottomNavigationBarItem(
            icon:
                Icon(Icons.edit, color: _getIconColor(4)), // Ghi thông tin thẻ
            label: 'Write Card',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        elevation: 10,
      ),
    );
  }
}
