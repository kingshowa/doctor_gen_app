import 'package:doctor_gen_app/database/db_helper.dart';
import 'package:doctor_gen_app/models/chat.dart';
import 'package:flutter/material.dart';
import 'package:doctor_gen_app/data/tips.dart';
import 'package:doctor_gen_app/services/tip_service.dart';
import 'package:doctor_gen_app/models/tip.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({super.key});

  @override
  State<TipsPage> createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  late PageController _pageController;
  int _currentPageIndex = 0;
  bool _isLoading = true;

  List<Chat> chats = [];
  List<String> recentChats = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadChatsAndTips();
  }

  Future<void> _loadChatsAndTips() async {
    try {
      final dbChats = await DBHelper().getAllChats();
      setState(() {
        chats = dbChats;
        recentChats = chats.map((chat) => chat.title).toList();
      });

      await _loadTips();
    } catch (e) {
      debugPrint("Error loading chats: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadTips() async {
    final fetched = await TipService().getDailyTips(recentChats);

    setState(() {
      tips.clear();
      tips.addAll(fetched);
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Tips"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadTips),
        ],
      ),
      body: SafeArea(
        child:
            _isLoading
                ? const Center(
                  child: CircularProgressIndicator(color: Color(0xff7dd4fb)),
                )
                : tips.isEmpty
                ? const Center(child: Text("No tips available"))
                : Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: tips.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPageIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final tip = tips[index];
                          return _buildTipCard(tip);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: _buildNavControls(),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildTipCard(Tip tip) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: const BoxDecoration(
              color: Color(0xff232729),
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 400,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xff7dd4fb).withOpacity(0.5),
                              const Color(0xff7dd4fb).withOpacity(0.2),
                              const Color(0xff7dd4fb).withOpacity(0.1),
                              Colors.transparent,
                            ],
                            radius: 0.8,
                          ),
                        ),
                      ),
                      Image.asset(
                        tip.imageUrl,
                        height: 400,
                        width: double.maxFinite,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      tip.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      tip.description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton.filledTonal(
          onPressed: () {
            if (_currentPageIndex > 0) {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          style: IconButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor:
                _currentPageIndex > 0
                    ? const Color(0xff7dd4fb).withOpacity(0.5)
                    : const Color(0xff2c3234),
          ),
        ),
        _buildIndicator(tips.length, _currentPageIndex),
        IconButton.filledTonal(
          onPressed: () {
            if (_currentPageIndex < tips.length - 1) {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          icon: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.black,
          ),
          style: IconButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor:
                _currentPageIndex < tips.length - 1
                    ? const Color(0xff7dd4fb).withOpacity(0.5)
                    : const Color(0xff2c3234),
          ),
        ),
      ],
    );
  }

  Widget _buildIndicator(int count, int currentIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 15 / count),
          width: currentIndex == index ? 150 / count : 100 / count,
          height: 6,
          decoration: BoxDecoration(
            color:
                currentIndex == index
                    ? const Color(0xff7dd4fb)
                    : Colors.white24,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
