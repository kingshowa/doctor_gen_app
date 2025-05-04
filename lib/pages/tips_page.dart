import 'package:doctor_gen_app/data/tips.dart';
import 'package:flutter/material.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({super.key});

  @override
  State<TipsPage> createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  late PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
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
          IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: Column(
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
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xff232729),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(18),
                            ),
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
                                            Color(0xff7dd4fb).withOpacity(0.5),
                                            Color(0xff7dd4fb).withOpacity(0.2),
                                            Color(0xff7dd4fb).withOpacity(0.1),
                                            Colors.transparent,
                                          ],
                                          radius: 0.8,
                                        ),
                                      ),
                                    ),
                                    Image.asset(
                                      tip.imageUrl!,
                                      height: 400,
                                      width: double.maxFinite,
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 20,
                                  left: 10,
                                  right: 10,
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    tip.title!,
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
                                    tip.description!,
                                    style: TextStyle(
                                      color: const Color(0xffffffff),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton.outlined(
                              onPressed: () {},
                              icon: const Icon(Icons.thumb_up_alt_outlined),
                            ),
                            const SizedBox(width: 10),
                            IconButton.outlined(
                              onPressed: () {},
                              icon: const Icon(Icons.thumb_down_alt_outlined),
                            ),
                            const Spacer(),
                            IconButton.outlined(
                              onPressed: () {},
                              icon: const Icon(Icons.check),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 55,
                    height: 55,
                    child: IconButton.filledTonal(
                      onPressed: () {
                        if (_currentPageIndex > 0) {
                          _pageController.previousPage(
                            duration: Duration(milliseconds: 300),
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
                                ? Color(0xff7dd4fb).withOpacity(0.5)
                                : Color(0xff2c3234),
                      ),
                      color: Colors.white, // optional: tint the icon
                    ),
                  ),
                  const SizedBox(width: 10),
                  _buildIndicator(tips.length, _currentPageIndex),
                  const SizedBox(width: 10),

                  SizedBox(
                    width: 55,
                    height: 55,
                    child: IconButton.filledTonal(
                      onPressed: () {
                        if (_currentPageIndex < tips.length - 1) {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
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
                                ? Color(0xff7dd4fb).withOpacity(0.5)
                                : Color(0xff2c3234),
                      ),
                      color: Colors.white, // optional: tint the icon
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
            color: currentIndex == index ? Color(0xff7dd4fb) : Colors.white24,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
