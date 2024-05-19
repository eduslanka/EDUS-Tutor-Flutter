import 'package:edus_tutor/utils/widget/Line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../config/app_size.dart';
import '../utils/CustomAppBarWidget.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:flutter_svg/flutter_svg.dart';

class HelpDeskMenu extends StatelessWidget {
  final String stName;
  final String stId;
  const HelpDeskMenu({super.key, required this.stName, required this.stId});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Help Desk',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          _contactRow('Head of Academics','+94706940523'),
          _contactRow('Academic Coordinator (Group Classes)','+94707771609'),
          _contactRow('Academic Coordinator (Individual Classes)','+94704411717'),
          _contactRow('Technical Support','+94701677488'),
          _contactRow('Student Consultant','+94774487774'),
          
        ],),
      ),
    );
  }

  Widget _contactRow(String role,String number) {
    return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Expanded(
                flex: 5,
                child: Text(role,style: TextStyle(color: Colors.black,fontSize: 18),maxLines: 2,)), Expanded(
                  flex: 2,
                  child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    GestureDetector(
                      onTap: (){
                              // var url = Uri.parse('https://wa.me/+94774487774?text=👋 Hi, I would like to join EDUS Classes. Please help me to register as a student.');
                              UrlLauncher.launch('https://wa.me/$number?text=👋 Hi! My name is $stName, and my admission number is $stId. I\'m reaching out because I need your support. 📑 Can you please assist me?');
                      },
                      child: SvgPicture.asset('assets/config/whats-app-whatsapp-whatsapp-icon-svgrepo-com.svg',height: 30,width: 40,)),
                    w16,
                    GestureDetector(
                      onTap: (){
                              UrlLauncher.launch("tel:$number");
                      },
                      child: SvgPicture.asset('assets/config/phone-call-svgrepo-com.svg',height: 30,width: 40,))
                  ],),
                )
            ],),
        h8, BottomLine()  ],
        );
  }
}