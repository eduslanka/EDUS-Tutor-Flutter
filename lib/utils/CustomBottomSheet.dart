import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomSheet extends StatefulWidget {
  final String? title;
  final List<Widget>? children;
  final double initialChildSize;
  const CustomBottomSheet({Key? key, 
    this.title,
    this.children,
    this.initialChildSize = 0.5,
  }) : super(key: key);
  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: SizedBox.expand(
        child: DraggableScrollableSheet(
          initialChildSize: widget.initialChildSize,
          minChildSize: 0.5,
          maxChildSize: 0.85,
          expand: true,
          snap: false,
          builder: (BuildContext context, scrollController) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: Scaffold(
                backgroundColor: Colors.white,
                resizeToAvoidBottomInset: false,
                body: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          width: 40,
                          height: 5,
                          decoration: const BoxDecoration(
                            color: Color(0xffDADADA),
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        '${widget.title}'.tr,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ...?widget.children,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
