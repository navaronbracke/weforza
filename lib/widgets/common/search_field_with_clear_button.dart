import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents a search field that has a clear button at the end if there is text in the search field.
class SearchFieldWithClearButton extends StatelessWidget {
  const SearchFieldWithClearButton({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.placeholder,
    super.key,
  });

  /// The controller for the text field.
  final TextEditingController controller;

  /// The focus node for the text field.
  final FocusNode focusNode;

  /// The function that is called when the text field value changes.
  final void Function(String value) onChanged;

  /// The placeholder label for the text field.
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: (context) => TextField(
        focusNode: focusNode,
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.text,
        autocorrect: false,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          labelText: placeholder,
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, child) {
              return value.text.isEmpty
                  ? const Icon(Icons.search)
                  : IconButton(onPressed: controller.clear, icon: const Icon(Icons.clear));
            },
          ),
        ),
      ),
      ios: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: CupertinoSearchTextField(
          focusNode: focusNode,
          controller: controller,
          onChanged: onChanged,
          autocorrect: false,
          placeholder: placeholder,
        ),
      ),
    );
  }
}
