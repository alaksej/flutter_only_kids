import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

showToast(String text, {Duration? duration}) {
  showOverlay(
    (context, t) {
      return Opacity(
        opacity: t,
        child: OnlyKidsToast(text),
      );
    },
    duration: duration,
  );
}

class OnlyKidsToast extends StatelessWidget {
  OnlyKidsToast(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => OverlaySupportEntry.of(context)?.dismiss(),
      child: SafeArea(
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment(0, 0.618),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Colors.black87,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: Text(text),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
