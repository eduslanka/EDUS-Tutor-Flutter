// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:shimmer/shimmer.dart';

class ShimmerList extends StatelessWidget {
  final int? itemCount;
  final double? height;

  const ShimmerList({Key? key, this.itemCount,this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: ListView.builder(
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
                child: Container(
                  width: 50,
                  height: height,
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100);
          }),
    );
  }
}
