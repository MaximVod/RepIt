import 'package:flutter/material.dart';

/// Error widget, when error state comes from BLoC
class ErrorState extends StatelessWidget {
  ///Error text
  final String errorText;

  ///Action on try again button
  final VoidCallback onTryAgain;

  ///Creates Error State Widget
  const ErrorState({
    required this.errorText,
    required this.onTryAgain,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_sharp),
            const SizedBox(
              height: 20,
            ),
            Text(
              errorText,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 15,
            ),
            OutlinedButton(
              onPressed: () => onTryAgain(),
              child: Text(
                "Please try again",
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
      );
}
