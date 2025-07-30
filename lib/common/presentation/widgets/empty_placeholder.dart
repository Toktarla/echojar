import 'package:flutter/material.dart';

class EmptyPlaceholder extends StatelessWidget {
  final String message;

  const EmptyPlaceholder({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0), // Fixed padding
        child: Column(
          mainAxisSize: MainAxisSize.min, // Take minimum vertical space
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.sentiment_dissatisfied, // A common "empty" icon
              size: 64.0,
              color: Colors.grey, // Fixed color for the icon
            ),
            const SizedBox(height: 16.0), // Fixed space between icon and text
            // Fixed Text styling
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.grey, // Fixed color for the text
              ),
            ),
          ],
        ),
      ),
    );
  }
}