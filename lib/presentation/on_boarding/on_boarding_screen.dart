
import 'package:barista/presentation/home/home.dart';
import 'package:barista/shared/components/default_text.dart';
import 'package:barista/shared/network/local/cache_helper.dart';
import 'package:barista/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      backgroundColor: kPrimaryColor,
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
              introPage("Welcome to Barista", "1.png"),
              introPage(
                "Browse our selection of coffee, pastries, and more, right at your fingertips.",
                "3d-realistic-cup-coffee-beans.png",
              ),
              introPage(
                "Enjoy seamless internet access with our easy-to-use WiFi connection feature.",
                "omb3.jpeg",
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
                      text: 'Skip',
                      textSize: 18,
                      weight: FontWeight.w600,
                      textColor: Colors.white,
                    ),
                  ),
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  effect: const ExpandingDotsEffect(
                    dotColor: Colors.white,
                    activeDotColor: kSecondaryColor,
                    dotHeight: 10,
                    dotWidth: 10,
                  ),
                  count: 3,
                ),
                InkWell(
                  onTap: () {
                    if (currentPage == 2) {
                      onClick();
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
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
                      text: currentPage == 2 ? 'Done' : 'Next',
                      textSize: 18,
                      weight: FontWeight.w600,
                      textColor: Colors.white,
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double value = 1.0;
        if (_controller.position.haveDimensions) {
          value = _controller.page! - currentPage;
          value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
        }
        return Opacity(
          opacity: value,
          child: Transform(
            transform: Matrix4.identity()..scale(value, value),
            alignment: Alignment.center,
            child: Container(
              color: kPrimaryColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    CircleAvatar(
                      backgroundImage: AssetImage(
                        'assets/images/$image',
                      ),
                      radius: 160,
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                        color: kSecondaryColor,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}