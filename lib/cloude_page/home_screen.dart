import 'dart:async';
import 'package:flutter/material.dart';
import 'package:freshpickkat/screens/search_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<String> hints = [
    'Search for vegetables',
    'Search for eggs',
    'Search for milk',
    'Search for bread',
  ];

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 2), (timer) {
      _currentIndex = (_currentIndex + 1) % hints.length;
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    // var width = mediaQuery.size.width;
    printTargetResolution(context);
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: [
          // 🔵 HEADER
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
            decoration: const BoxDecoration(color: Color(0xFF1B8A4C)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'milk basket',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Order by Midnight',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Delivery by 7 AM',
                          style: TextStyle(color: Colors.yellow, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 🔍 SEARCH BAR
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SearchScreen()),
                    );
                  },
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.white),
                        const SizedBox(width: 8),

                        // Animated hint text
                        Expanded(
                          child: ClipRect(
                            child: PageView.builder(
                              controller: _pageController,
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: hints.length,
                              itemBuilder: (context, index) {
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    hints[index],
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 🎁 OFFER WIDGET
          Container(
            // margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 12, 82, 42),
              // borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.card_giftcard, color: Colors.white),
                SizedBox(width: 10),
                Expanded(
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "You're eligible for a free membership trial!",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Enjoy free deliveries from your 1st order",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 16),
            height: height * 0.37, // total space including overlap
            width: double.infinity,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                /// 🖼️ BACKGROUND IMAGE
                Container(
                  height: height * 0.37,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'lib/assets/images/grocry_home_banner.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                /// 🧾 OPTIONAL TITLE ON IMAGE
                // Positioned(
                //   top: 30,
                //   left: 16,
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: const [
                //       Text(
                //         'Kitchen Partners',
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 22,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //       SizedBox(height: 4),
                //       Text(
                //         'Grab Cookware, Glassware & more',
                //         style: TextStyle(
                //           color: Colors.white70,
                //           fontSize: 14,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                /// 🧱 HORIZONTAL ITEMS (OVERLAP)
                Positioned(
                  bottom: 7, // 👈 overlap magic
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black45,
                                blurRadius: 6,
                                offset: Offset(0, 4),
                              ),
                            ],
                            image: const DecorationImage(
                              image: AssetImage("lib/assets/images/milk.png"),
                              fit: BoxFit.cover, // 👈 poora box fill karega
                            ),
                          ),
                        );
                      },
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
}

void printTargetResolution(BuildContext context) {
  // 1. Get screen metrics
  final Size logicalSize = MediaQuery.sizeOf(context);
  final double pixelRatio = MediaQuery.devicePixelRatioOf(context);

  // 2. Calculate dimensions (matching your container)
  // Width: double.infinity is the full screen width
  double physicalWidth = logicalSize.width * pixelRatio;

  // Height: 30% of the screen height
  double physicalHeight = (logicalSize.height * 0.3) * pixelRatio;

  // 3. Print the result (rounded to nearest integer)
  print(
    'Your Image Resolution: ${physicalWidth.round()} x ${physicalHeight.round()}',
  );

  // Bonus: Calculate the Aspect Ratio
  double ratio = physicalWidth / physicalHeight;
  print('Aspect Ratio: ${ratio.toStringAsFixed(2)}:1');
}
