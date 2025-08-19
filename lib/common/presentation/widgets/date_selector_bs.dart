import 'package:flutter/material.dart';

class DateSelectorBS extends StatelessWidget {
  final ValueChanged<DateTime> onDateSelected;

  const DateSelectorBS({super.key, required this.onDateSelected});

  /// Static method to show the bottom sheet
  static Future<void> show(
      BuildContext context, {
        required ValueChanged<DateTime> onDateSelected,
      }) {
    return showModalBottomSheet(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      isScrollControlled: true, // allows taller sheets
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => DateSelectorBS(onDateSelected: onDateSelected),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final List<_DateOption> options = [
      _DateOption("3 Days", now.add(const Duration(days: 3))),
      _DateOption("1 Week", now.add(const Duration(days: 7))),
      _DateOption("1 Month", DateTime(now.year, now.month + 1, now.day)),
      _DateOption("3 Months", DateTime(now.year, now.month + 3, now.day)),
      _DateOption("6 Months", DateTime(now.year, now.month + 6, now.day)),
      _DateOption("1 Year", DateTime(now.year + 1, now.month, now.day)),
      _DateOption("2 Years", DateTime(now.year + 2, now.month, now.day)),
      _DateOption("3 Years", DateTime(now.year + 3, now.month, now.day)),
    ];

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Select Date",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...options.map((opt) => ListTile(
                title: Text(opt.label),
                onTap: () {
                  onDateSelected(opt.date);
                  Navigator.pop(context);
                },
              )),
              ListTile(
                title: const Text("Custom Date"),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: now,
                    firstDate: now,
                    lastDate: now.add(const Duration(days: 365 * 5)),
                  );
                  if (picked != null) {
                    onDateSelected(picked);
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateOption {
  final String label;
  final DateTime date;

  _DateOption(this.label, this.date);
}
