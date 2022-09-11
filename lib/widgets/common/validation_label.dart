import 'package:flutter/widgets.dart';

/// A validation label that takes its value from a [Stream].
class ValidationLabel extends StatelessWidget {
  /// The default constructor.
  const ValidationLabel({
    super.key,
    required this.stream,
    required this.style,
    this.mainAxisAlignment = MainAxisAlignment.end,
    this.heightWhenEmpty,
  });

  /// The value constructor accepts a [message] as input.
  ValidationLabel.value({
    Key? key,
    required TextStyle style,
    required String message,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.end,
  }) : this(
          key: key,
          style: style,
          stream: Stream.value(message),
          mainAxisAlignment: mainAxisAlignment,
        );

  /// The [Stream] that provides the input for the [Text] widget.
  final Stream<String> stream;

  /// The alignment for the error message.
  final MainAxisAlignment mainAxisAlignment;

  /// The height that this widget should occupy
  /// when there is no error message to display.
  final double? heightWhenEmpty;

  /// The style for the error message.
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          Flexible(
            child: StreamBuilder<String>(
              stream: stream,
              builder: (_, snapshot) {
                final text = snapshot.data ?? '';

                if (text.isEmpty) {
                  return heightWhenEmpty != null
                      ? SizedBox(height: heightWhenEmpty!)
                      : const SizedBox.shrink();
                }

                return Text(text, style: style);
              },
            ),
          ),
        ],
      ),
    );
  }
}
