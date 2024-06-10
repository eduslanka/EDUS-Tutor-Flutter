import 'package:auto_size_text/auto_size_text.dart';
import 'package:edus_tutor/app_service/app_service.dart';
import 'package:edus_tutor/config/app_size.dart';
import 'package:edus_tutor/model/today_class_model.dart';
import 'package:edus_tutor/utils/Utils.dart';
import 'package:edus_tutor/webview/launch_webview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class TodayClassScreen extends StatefulWidget {
  final TodayClassResponse response;
  const TodayClassScreen({super.key, required this.response});

  @override
  State<TodayClassScreen> createState() => _TodayClassScreenState();
}

class _TodayClassScreenState extends State<TodayClassScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.response.classes.length == 0
          ? Container(
              height: 40,
              child: const Center(
                  child: Text(
                'No Today Classes',
                style: TextStyle(color: Colors.black),
              )))
          : Padding(
             padding:
                        const EdgeInsets.only(left: 24.0, right: 24, top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                                          'Today Classes',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                          minFontSize: 8,
                                          maxFontSize: 14,
                                          maxLines: 1,
                                        ),
                    ),
                Container(
                  decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       
                        ListView.builder(
                            itemCount: widget.response.classes?.length ?? 0,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: ((context, index) {
                              final classes = widget.response.classes[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 239, 239, 239),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: AutoSizeText(
                                            classes.classSec,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                            minFontSize: 8,
                                            maxFontSize: 14,
                                            maxLines: 1,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: AutoSizeText(
                                            classes.startTime,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                            minFontSize: 10,
                                            maxFontSize: 14,
                                            maxLines: 1,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: GestureDetector(
                                            onTap:(){
                                              if(classes.status=='Join'){
                                             launchUrl(Uri.parse(classes.meetLink));
                        
                                              }
                                            },
                                            child: Container(
                                              width: screenWidth(100, context),
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  color: classes.status=='Join'? Utils.baseBlue:Colors.white,
                                                  borderRadius: BorderRadius.circular(15)),
                                              child: Center(
                                                  child: SizedBox(
                                                    width: screenWidth(60, context),
                                                    child: Center(
                                                      child: AutoSizeText(
                                                                                              classes.cancelOrRescheduleStatus == 'false'
                                                        ? classes.status
                                                        :classes.status=='Join'? classes.status: classes.cancelOrRescheduleStatus,
                                                                                              style:  TextStyle(
                                                        color:classes.cancelOrRescheduleStatus == 'false'
                                                        ? classes.status=='Join'?  Colors.white:Colors.black:classes.status=='Join'?Colors.white: Colors.red,
                                                      
                                                        fontWeight: FontWeight.w600),
                                                                                              minFontSize: 6,
                                                                                              maxFontSize: 14,
                                                                                              maxLines: 1,
                                                                                            ),
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
