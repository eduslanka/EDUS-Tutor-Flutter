import 'package:edus_tutor/config/app_size.dart';
import 'package:flutter/material.dart';

class CustomBottomSheetDropdown extends StatelessWidget {
  final List<dynamic> items;
  final String? selectedValue;
  final Function(String?) onChanged;
  final String hintText;

  const CustomBottomSheetDropdown({
    Key? key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.hintText = 'Select an option',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBottomSheet(context),
      child: Container(
        width: screenWidth(390, context),
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedValue ?? hintText,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          // padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              h16,
              Center(
                child: Text(
                  'Select an Option',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              h8,
              Divider(),
              const SizedBox(height: 10),
              // List of Items
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: items.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1, color: Colors.black26),
                    itemBuilder: (BuildContext context, int index) {
                      final item = items[index];
                      return ListTile(
                        title: Text(
                          item,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        trailing: item == selectedValue
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                        onTap: () {
                          onChanged(item);
                          Navigator.pop(context); // Close the bottom sheet
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
