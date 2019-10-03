
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/addPersonBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';

///This [Widget] represents the form for adding a person.
class AddPersonPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddPersonPageState(InjectionContainer.get<AddPersonBloc>());

}

///This is the [State] class for [AddPersonPage].
class _AddPersonPageState extends State<AddPersonPage> implements PlatformAwareWidget {
  _AddPersonPageState(this._bloc);

  ///The key for the form.
  final _formKey = GlobalKey<FormState>();
  ///The BLoC in charge of the form.
  final AddPersonBloc _bloc;

  ///The input labels.
  String _firstNameLabel;
  String _lastNameLabel;
  String _phoneLabel;

  ///Error messages.
  String _firstNameRequiredMessage;
  String _lastNameRequiredMessage;
  String _phoneRequiredMessage;
  String _firstNameMinLengthMessage;
  String _lastNameMinLengthMessage;

  ///Minimum input lengths.
  final int _firstNameMinLength = 2;
  final int _lastNameMinLength = 2;


  ///Initialize localized strings for the form.
  ///This requires a [BuildContext] for the lookup.
  void _initStrings(BuildContext context){
    final S translator = S.of(context);
    _firstNameLabel = translator.PersonFirstNameLabel;
    _lastNameLabel = translator.PersonLastNameLabel;
    _firstNameRequiredMessage = translator.ValueIsRequired(_firstNameLabel);
    _lastNameRequiredMessage = translator.ValueIsRequired(_lastNameLabel);
    _firstNameMinLengthMessage = translator.FirstNameMinLength("$_firstNameMinLength");
    _lastNameMinLengthMessage = translator.FirstNameMinLength("$_lastNameMinLength");
    _phoneLabel = translator.PersonTelephoneLabel;
    _phoneRequiredMessage = translator.ValueIsRequired(_phoneLabel);
  }

  @override
  Widget build(BuildContext context){
    _initStrings(context);
    return PlatformAwareWidgetBuilder.buildPlatformAwareWidget(context, this);
  }

  ///Layout
  ///
  ///A form for the person's first/last name and telephone number.
  ///A section for showing a list of devices + a button for scanning.
  @override
  Widget buildAndroidWidget(BuildContext context) {
    // TODO: implement buildAndroidWidget
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).AddPersonTitle),
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
                  validator: (value) => _bloc.validateFirstName(value, _firstNameRequiredMessage, _firstNameMinLengthMessage),
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
                  validator: (value) => _bloc.validateLastName(value, _lastNameRequiredMessage, _lastNameMinLengthMessage),
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
                  validator: (value) => _bloc.validatePhone(value, _phoneRequiredMessage),
                  autovalidate: _bloc.autoValidatePhone,
                  onChanged: (value)=> setState(() => _bloc.autoValidatePhone = true),
                ),
                SizedBox(height: 5),
                Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(S.of(context).AddPersonSubmit,style: TextStyle(color: Colors.white)),
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
        middle: Text(S.of(context).AddPersonTitle),
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