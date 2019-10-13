
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/addMemberBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';

///This [Widget] represents the form for adding a member.
class AddMemberPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddMemberPageState(InjectionContainer.get<AddMemberBloc>());

}

///This is the [State] class for [AddMemberPage].
class _AddMemberPageState extends State<AddMemberPage> implements PlatformAwareWidget {
  _AddMemberPageState(this._bloc);

  ///The key for the form.
  final _formKey = GlobalKey<FormState>();
  ///The BLoC in charge of the form.
  final AddMemberBloc _bloc;

  ///The input labels.
  String _firstNameLabel;
  String _lastNameLabel;
  String _phoneLabel;

  ///Error messages.
  String _firstNameRequiredMessage;
  String _lastNameRequiredMessage;
  String _phoneRequiredMessage;
  String _firstNameMaxLengthMessage;
  String _firstNameIllegalCharactersMessage;
  String _lastNameMaxLengthMessage;
  String _lastNameIllegalCharactersMessage;
  String _phoneIllegalCharactersMessage;
  String _phoneMinLengthMessage;
  String _phoneMaxLengthMessage;


  ///Initialize localized strings for the form.
  ///This requires a [BuildContext] for the lookup.
  void _initStrings(BuildContext context){
    final S translator = S.of(context);
    _firstNameLabel = translator.PersonFirstNameLabel;
    _lastNameLabel = translator.PersonLastNameLabel;
    _phoneLabel = translator.PersonTelephoneLabel;

    _firstNameRequiredMessage = translator.ValueIsRequired(_firstNameLabel);
    _lastNameRequiredMessage = translator.ValueIsRequired(_lastNameLabel);
    _phoneRequiredMessage = translator.ValueIsRequired(_phoneLabel);

    _firstNameMaxLengthMessage = translator.FirstNameMaxLength("${_bloc.firstNameMaxLength}");
    _firstNameIllegalCharactersMessage = translator.FirstNameIllegalCharacters;

    _lastNameMaxLengthMessage = translator.LastNameMaxLength("${_bloc.lastNameMaxLength}");
    _lastNameIllegalCharactersMessage = translator.LastNameIllegalCharacters;

    _phoneIllegalCharactersMessage = translator.PhoneIllegalCharacters;
    _phoneMinLengthMessage = translator.PhoneMinLength("${_bloc.phoneMinLength}");
    _phoneMaxLengthMessage = translator.PhoneMaxLength("${_bloc.phoneMaxLength}");
  }

  @override
  Widget build(BuildContext context){
    _initStrings(context);
    return PlatformAwareWidgetBuilder.buildPlatformAwareWidget(context, this);
  }

  ///Layout
  ///
  ///A form for the person's first/last name and telephone number.
  @override
  Widget buildAndroidWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).AddMemberTitle),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    labelText: _firstNameLabel,
                  ),
                  controller: _bloc.firstNameController,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  validator: (value) => _bloc.validateFirstName(value,_firstNameRequiredMessage,_firstNameMaxLengthMessage,_firstNameIllegalCharactersMessage),
                  autovalidate: _bloc.autoValidateFirstName,
                  onChanged: (value)=> setState(() => _bloc.autoValidateFirstName = true),
                ),
                SizedBox(height: 5),
                TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    labelText: _lastNameLabel,
                  ),
                  controller: _bloc.lastNameController,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  validator: (value) => _bloc.validateLastName(value, _lastNameRequiredMessage, _lastNameMaxLengthMessage,_lastNameIllegalCharactersMessage),
                  autovalidate: _bloc.autoValidateLastName,
                  onChanged: (value)=> setState(() => _bloc.autoValidateLastName = true),
                ),
                SizedBox(height: 5),
                TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    labelText: _phoneLabel,
                  ),
                  controller: _bloc.phoneController,
                  autocorrect: false,
                  keyboardType: TextInputType.phone,
                  validator: (value) => _bloc.validatePhone(value,_phoneRequiredMessage,_phoneIllegalCharactersMessage,_phoneMinLengthMessage,_phoneMaxLengthMessage),
                  autovalidate: _bloc.autoValidatePhone,
                  onChanged: (value)=> setState(() => _bloc.autoValidatePhone = true),
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                ),
                SizedBox(height: 5),
                Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(S.of(context).AddMemberSubmit,style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        if(_formKey.currentState.validate())
                        {
                            //TODO save person with bloc
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///Layout
  ///
  ///A form for the person's first/last name and telephone number.
  ///A section for showing a list of devices + a button for scanning.
  @override
  Widget buildIosWidget(BuildContext context) {
    // TODO: implement buildIosWidget
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).AddMemberTitle),
        transitionBetweenRoutes: false,
      ),
      child: Container(),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }


}