import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/excluded_terms_delegate.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the input field for adding an excluded term.
class AddExcludedTermInputField extends StatelessWidget {
  const AddExcludedTermInputField({
    super.key,
    required this.excludedTermsDelegate,
    required this.textEditingController,
  });

  /// The delegate that manages the excluded terms.
  final ExcludedTermsDelegate excludedTermsDelegate;

  /// The controller for the text field.
  final TextEditingController textEditingController;

  void _onEditingComplete(BuildContext context) {
    final formState = Form.of(context);

    if (formState == null || !formState.validate()) {
      return;
    }

    excludedTermsDelegate.addTerm(textEditingController.text);
    textEditingController.clear();

    // Reset the form, otherwise the empty text field shows a validation error.
    formState.reset();
  }

  @override
  Widget build(BuildContext context) {
    final translator = S.of(context);

    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Builder(
        builder: (context) {
          return PlatformAwareWidget(
            android: () => TextFormField(
              controller: textEditingController,
              decoration: InputDecoration(hintText: translator.AddKeyword),
              keyboardType: TextInputType.text,
              onEditingComplete: () => _onEditingComplete(context),
              maxLength: excludedTermsDelegate.maxLength,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              maxLines: 1,
              textInputAction: TextInputAction.done,
              validator: (value) => excludedTermsDelegate.validateTerm(
                value,
                translator,
              ),
            ),
            ios: () => CupertinoTextFormFieldRow(
              controller: textEditingController,
              keyboardType: TextInputType.text,
              maxLines: 1,
              onEditingComplete: () => _onEditingComplete(context),
              padding: const EdgeInsetsDirectional.fromSTEB(20, 6, 6, 6),
              placeholder: translator.AddKeyword,
              textInputAction: TextInputAction.done,
              validator: (value) => excludedTermsDelegate.validateTerm(
                value,
                translator,
              ),
            ),
          );
        },
      ),
    );
  }
}
