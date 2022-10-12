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
  });

  /// The delegate that manages the excluded terms.
  final ExcludedTermsDelegate excludedTermsDelegate;

  void _onEditingComplete(BuildContext context) {
    final formState = Form.of(context);

    if (formState == null || !formState.validate()) {
      return;
    }

    // Add a term by saving the form and reset the form afterwards.
    formState.save();
    formState.reset();
  }

  void _onSaved(String? value) {
    if (value == null) {
      return;
    }

    excludedTermsDelegate.addTerm(value);
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
              decoration: InputDecoration(hintText: translator.AddKeyword),
              keyboardType: TextInputType.text,
              onEditingComplete: () => _onEditingComplete(context),
              onSaved: _onSaved,
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
              keyboardType: TextInputType.text,
              maxLines: 1,
              onEditingComplete: () => _onEditingComplete(context),
              onSaved: _onSaved,
              // The excluded terms have a 15 margin on their border.
              padding: const EdgeInsetsDirectional.fromSTEB(15, 6, 6, 6),
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
