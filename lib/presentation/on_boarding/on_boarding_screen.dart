import 'package:barista/presentation/home/home.dart';
import 'package:barista/shared/components/default_text.dart';
import 'package:barista/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _controller;
  int currentPage = 0;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onClick() async {
    await CacheHelper.init();
    await CacheHelper.saveData(key: "onboarding", value: true);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (value) {
              setState(() {
                currentPage = value;
              });
            },
            children: [
              introPage(
                  "Bienvenue",
                  ""),
              introPage(
                "Nous sommes ravis de vous accueillir !.",
                "",
              ),
              introPage(
                "Bienvenue dans votre expérience !",
                "",
              ),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.90),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () => _controller.jumpToPage(2),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DefaultText(
                      text: 'Passer',
                      textSize: 18,
                      weight: FontWeight.w600,
                      textColor: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                ),
                InkWell(
                  onTap: () {
                    if (currentPage == 2) {
                      onClick();
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DefaultText(
                      text: currentPage == 2 ? 'Fini' : 'Suivant',
                      textSize: 18,
                      weight: FontWeight.w600,
                      textColor: Theme.of(context).colorScheme.inversePrimary,
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

  Widget introPage(String text, String image) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Image.asset(
            'assets/images/welcome.png',
          ),
          const SizedBox(
            height: 80,
          ),
          DefaultText(
            text: text,
            textAlign: TextAlign.center,
            textSize: 18,
          ),
        ],
      ),
    );
  }
}
