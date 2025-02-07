import 'package:twizzy/core/res/styles/colours.dart';
import 'package:twizzy/core/res/styles/text.dart';
import 'package:flutter/material.dart';

/// A stateless widget that displays a message when there is no data.
///
/// The [EmptyData] widget takes a [data] string to display and an optional [padding].
/// It centers the text and applies a specific text style and color.
///
/// Example usage:
/// ```dart
/// EmptyData('No items found')
/// ```
class EmptyData extends StatelessWidget {
  /// Creates an [EmptyData] widget.
  ///
  /// The [data] parameter must not be null.
  /// The [padding] parameter is optional and defaults to horizontal padding of 10.
  const EmptyData(this.data, {super.key, this.padding});

  final String data;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          data,
          textAlign: TextAlign.center,
          style: TextStyles.headingBold.copyWith(
            color: Colours.lightThemeSecondaryTextColour.withOpacity(.6),
          ),
        ),
      ),
    );
  }
}
