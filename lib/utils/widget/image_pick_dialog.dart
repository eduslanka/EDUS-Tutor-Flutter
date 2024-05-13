import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ImagePickDialog extends StatelessWidget {
  const ImagePickDialog(
      {Key? key, required this.onCameraTap, required this.onGalleryTap})
      : super(key: key);

  final Function() onCameraTap;
  final Function() onGalleryTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: Get.width - 40,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onCameraTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey)),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.grey,
                  ),
                ),
                10.verticalSpace,
                const Text("Camera",style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),)
              ],
            ),
          ),
          30.horizontalSpace,
          GestureDetector(
            onTap: onGalleryTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey)),
                  child: const Icon(
                    Icons.file_copy_outlined,
                    color: Colors.grey,
                  ),
                ),
                10.verticalSpace,
                const Text("File",style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
