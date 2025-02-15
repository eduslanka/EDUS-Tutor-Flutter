import 'package:edus_tutor/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../config/app_size.dart';
import '../screens/fees/fees_student/StudentFeesNew.dart';
import '../utils/CustomAppBarWidget.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class FeeReminderScreen extends StatelessWidget {
  const FeeReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Fee Remider',
        isAcadamic: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.payment,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              'Your fees is overdue. Kindly settle to continue your classes.',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            h16,
            contactUs(),
            const SizedBox(height: 20),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const StudentFeesNew()));
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth(60, context)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Utils.baseBlue),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Settle Dues',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        w8,
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 18,
                        )
                      ],
                    ),
                  ),
                ))
            // ElevatedButton(
            //   onPressed: () {
            //     //

            //   },
            //   child: const Text('Settle Dues'),
            // ),
          ],
        ),
      ),
    );
  }

  Widget contactUs() {
    return Column(
      children: [
        const Text(
          'For further assistance ',
          style: TextStyle(fontSize: 18),
        ),
        h16,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  // var url = Uri.parse('https://wa.me/+94704411717?text=👋 Hi, I would like to join EDUS Classes. Please help me to register as a student.');
                  UrlLauncher.launch(
                      'https://wa.me/+94704411717?text=👋 Hi, I would like to join EDUS Classes. Please help me to register as a student.');
                },
                child: SvgPicture.asset(
                  'assets/config/whats-app-whatsapp-whatsapp-icon-svgrepo-com.svg',
                  height: 30,
                  width: 40,
                )),
            w16,
            GestureDetector(
                onTap: () {
                  UrlLauncher.launch("tel:+94704411717");
                },
                child: SvgPicture.asset(
                  'assets/config/phone-call-svgrepo-com.svg',
                  height: 30,
                  width: 40,
                ))
          ],
        )
      ],
    );
  }
}
