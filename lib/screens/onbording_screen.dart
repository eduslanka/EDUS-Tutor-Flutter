import 'package:dots_indicator/dots_indicator.dart';
import 'package:edus_tutor/config/app_size.dart';
import 'package:edus_tutor/screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/widgets.dart';

class OnbordingScreen extends StatefulWidget {
  const OnbordingScreen({Key? key}) : super(key: key);

  @override
  State<OnbordingScreen> createState() => _OnbordingScreenState();
}

class _OnbordingScreenState extends State<OnbordingScreen> {
  List<String> images = [
    'assets/images/Chair with pen in hand with book on table (Chilling).png',
    'assets/images/Frame 7.png',
    'assets/images/Frame 95.png',
    'assets/images/Frame 96.png'
  ];
  List<String> heading = [
    'Certified & Verified online tutors',
    'Quality Assured  Classes',
    'Results are guaranteed',
    'Join now, unlock your full potential!'
  ];
  List<Widget> subtitle = [
   
   
    
   
  ];
Widget getWidget(int index){
  if(index==0){
    return  const Text(
      'Qualified, verified tutors for high-quality, effective online learning sessions.',
      style: TextStyle(
          fontWeight: FontWeight.w400, fontSize: 16, color: Colors.black45),
      textAlign: TextAlign.center,
    );
  }else if(index==1){return  const Text(
      'Qualified, verified tutors for high-quality, effective online learning sessions.',
      style: TextStyle(
          fontWeight: FontWeight.w400, fontSize: 16, color: Colors.black45),
      textAlign: TextAlign.center,
    );}else if(index==2){
      return const Text(
      'Qualified, verified tutors for high-quality, effective online learning sessions.',
      style: TextStyle(
          fontWeight: FontWeight.w400, fontSize: 16, color: Colors.black45),
      textAlign: TextAlign.center,
    );
    }else{
      return  loginButton();
    }
}
  final SwiperController _swiperController = SwiperController();

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              h8,
              leaniarBar(),
              h8,
              Expanded(
                child: Swiper(
                  itemCount: images.length,
                  loop: false,
                  controller: _swiperController,
                  onIndexChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return centerContainer(
                        images[index], heading[index], getWidget(index));
                  },
                ),
              ),
              const SizedBox(height: 16),
              DotsIndicator(
                dotsCount: images.length,
                position: _currentIndex,
                decorator: DotsDecorator(
                  color: Colors.grey,
                  activeColor: Colors.black,
                  size: const Size.square(9.0),
                  activeSize: const Size(18.0, 9.0),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginButton() {
    return GestureDetector(
      onTap: (){
        Route route;
          route = MaterialPageRoute(builder: (context) => const LoginScreen());
            Navigator.pushReplacement(context, route);
      },
      child: Container(
        width: screenWidth(380, context),
        height: screenHeight(50, context),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24),color: const Color(0xff053EFF)),
        child: const Center(child: Text('Log in',style: TextStyle(color: Colors.white),)),
      ),
    );
  }

  Widget centerContainer(String image, String heading, Widget sub) {
    return Container(
      width: screenWidth(380, context),
      height: screenHeight(700, context),
      child: Column(
        children: [
          h16,
          h16,
          Container(
            width: screenWidth(287, context),
            height: screenHeight(360, context),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.contain,
              ),
            ),
          ),
          h16,
          SizedBox(
            width: screenWidth(380, context),
            child: Text(
              heading,
              style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 32,
                  color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),h16,
          SizedBox(
            width: screenWidth(380, context),
            child: sub,
          ),
        ],
      ),
    );
  }

  Widget leaniarBar() {
    return Stack(
      children: [
        Container(
          width: screenWidth(380, context),
          height: 6,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.black12),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: screenWidth((380 / 4)*(_currentIndex+1), context),
          height: 6,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.black),
        )
      ],
    );
  }
}
