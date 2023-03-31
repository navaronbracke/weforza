import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/editRideBloc.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/pages/editRide/editRideSubmit.dart';
import 'package:weforza/widgets/platform/cupertinoFormErrorFormatter.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/providers/reloadDataProvider.dart';
import 'package:weforza/widgets/providers/selectedItemProvider.dart';

class EditRidePage extends StatefulWidget {
  @override
  _EditRidePageState createState() => _EditRidePageState();
}

class _EditRidePageState extends State<EditRidePage> {

  EditRideBloc bloc;

  ///The key for the form.
  final _formKey = GlobalKey<FormState>();

  TextEditingController _titleController;
  TextEditingController _departureController;
  TextEditingController _destinationController;
  TextEditingController _distanceController;

  String _titleLabel;
  String _departureLabel;
  String _destinationLabel;
  String _distanceLabel;

  String _titleMaxLengthMessage;
  String _titleWhitespaceMessage;
  String _distanceInvalidMessage;
  String _distancePositiveMessage;
  String _distanceMaximumMessage;
  String _addressWhitespaceMessage;
  String _addressMaxLengthMessage;
  String _addressInvalidMessage;

  FocusNode _titleFocusNode = FocusNode();
  FocusNode _departureFocusNode = FocusNode();
  FocusNode _destinationFocusNode = FocusNode();
  FocusNode _distanceFocusNode = FocusNode();

  ///Initialize localized strings for the form.
  ///This requires a [BuildContext] for the lookup.
  void _initStrings(BuildContext context) {
    final S translator = S.of(context);
    _titleLabel = translator.EditRideTitleLabel;
    _departureLabel = translator.EditRideDepartureLabel;
    _destinationLabel = translator.EditRideDestinationLabel;
    _distanceLabel = translator.EditRideDistanceLabel;
    _titleMaxLengthMessage =
        translator.EditRideTitleMaxLength("${Ride.titleMaxLength}");
    _titleWhitespaceMessage = translator.EditRideTitleWhitespace;
    _distanceInvalidMessage = translator.EditRideDistanceInvalid;
    _distancePositiveMessage = translator.EditRideDistancePositive;
    _distanceMaximumMessage =
        translator.EditRideDistanceMaximum("${bloc.maxDistanceInKm}");
    _addressWhitespaceMessage = translator.EditRideAddressWhitespace;
    _addressMaxLengthMessage =
        translator.EditRideAddressMaxLength("${bloc.addressMaxLength}");
    _addressInvalidMessage = translator.EditRideAddressInvalid;
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: () => _buildAndroidLayout(context),
      ios: () => _buildIOSLayout(context),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = EditRideBloc(
      ride: SelectedItemProvider.of(context).selectedRide.value,
      repository: InjectionContainer.get<RideRepository>()
    );
    _titleController = TextEditingController(text: bloc.titleInput);
    _departureController = TextEditingController(text: bloc.departureInput);
    _destinationController = TextEditingController(text: bloc.destinationInput);
    _distanceController = TextEditingController(
        text: bloc.distanceInput == 0.0 ? "" : "${bloc.distanceInput}"
    );
    _initStrings(context);
  }

  @override
  void dispose() {
    bloc.dispose();
    _titleController.dispose();
    _destinationController.dispose();
    _departureController.dispose();
    _distanceController.dispose();
    _titleFocusNode.dispose();
    _departureFocusNode.dispose();
    _destinationFocusNode.dispose();
    _distanceFocusNode.dispose();
    super.dispose();
  }

  void _focusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  ///Validate all current form input for IOS.
  bool iosAllFormInputValidator(){
    final titleValid = bloc.validateTitle(_titleController.text, _titleWhitespaceMessage, _titleMaxLengthMessage) == null;
    final departureValid = bloc.validateDepartureAddress(
        _departureController.text,
        _addressWhitespaceMessage,
        _addressMaxLengthMessage,
        _addressInvalidMessage) == null;
    final destinationValid = bloc.validateDestinationAddress(
        _destinationController.text,
        _addressWhitespaceMessage,
        _addressMaxLengthMessage,
        _addressInvalidMessage) == null;
    final distanceValid = bloc.validateDistance(
      _distanceController.text,
      _distanceInvalidMessage,
      _distancePositiveMessage,
      _distanceMaximumMessage) == null;
    return titleValid && departureValid && destinationValid && distanceValid;
  }

  Widget _buildAndroidLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).EditRidePageTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.calendar_today, size: 30),
                      SizedBox(width: 4),
                      Text(bloc.ride.getFormattedDate(context, false),
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16
                          )
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  focusNode: _titleFocusNode,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    labelText: _titleLabel,
                    helperText:
                    " ", //Prevent popping up and down during validation
                  ),
                  controller: _titleController,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  validator: (value) => bloc.validateTitle(
                      value, _titleWhitespaceMessage, _titleMaxLengthMessage
                  ),
                  autovalidate: bloc.autoValidateTitle,
                  onChanged: (value) => setState(() {
                    bloc.autoValidateTitle = true;
                  }),
                  onFieldSubmitted: (value) {
                    _focusChange(
                        context,
                        _titleFocusNode,
                        _departureFocusNode
                    );
                  },
                ),
                SizedBox(height: 5),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  focusNode: _departureFocusNode,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    labelText: _departureLabel,
                    helperText:
                    " ", //Prevent popping up and down during validation
                  ),
                  controller: _departureController,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  validator: (value) => bloc.validateDepartureAddress(
                      value,
                      _addressWhitespaceMessage,
                      _addressMaxLengthMessage,
                      _addressInvalidMessage
                  ),
                  autovalidate: bloc.autoValidateDepartureAddress,
                  onChanged: (value) => setState(() {
                    bloc.autoValidateDepartureAddress = true;
                  }),
                  onFieldSubmitted: (value) {
                    _focusChange(
                        context,
                        _departureFocusNode,
                        _destinationFocusNode
                    );
                  },
                ),
                SizedBox(height: 5),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  focusNode: _destinationFocusNode,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    labelText: _destinationLabel,
                    helperText:
                    " ", //Prevent popping up and down during validation
                  ),
                  controller: _destinationController,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  validator: (value) => bloc.validateDestinationAddress(
                      value,
                      _addressWhitespaceMessage,
                      _addressMaxLengthMessage,
                      _addressInvalidMessage
                  ),
                  autovalidate: bloc.autoValidateDestinationAddress,
                  onChanged: (value) => setState(() {
                    bloc.autoValidateDestinationAddress = true;
                  }),
                  onFieldSubmitted: (value) {
                    _focusChange(
                        context,
                        _destinationFocusNode,
                        _distanceFocusNode
                    );
                  },
                ),
                SizedBox(height: 5),
                TextFormField(
                  focusNode: _distanceFocusNode,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    labelText: _distanceLabel,
                    suffixText: S.of(context).DistanceKm,
                    helperText:
                    " ", //Prevent popping up and down during validation
                  ),
                  controller: _distanceController,
                  autocorrect: false,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => bloc.validateDistance(
                    value,
                    _distanceInvalidMessage,
                    _distancePositiveMessage,
                    _distanceMaximumMessage,
                  ),
                  autovalidate: bloc.autoValidateDistance,
                  onChanged: (value) => setState(() {
                    bloc.autoValidateDistance = true;
                  }),
                  onFieldSubmitted: (value) {
                    _distanceFocusNode.unfocus();
                  },
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                  child: Center(
                    child: EditRideSubmit(bloc.stream, () async {
                      if (_formKey.currentState.validate()) {
                        await bloc.editRide().then((updatedRide){
                          ReloadDataProvider.of(context).reloadRides.value = true;
                          SelectedItemProvider.of(context).selectedRide.value = updatedRide;
                          Navigator.pop(context);
                        },onError: (error){
                          //the submit will handle the 'actual' error
                        });
                      }
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIOSLayout(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Text(S.of(context).EditRidePageTitle),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 4,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.calendar_today, size: 30),
                            SizedBox(width: 4),
                            Text(bloc.ride.getFormattedDate(context, false),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16)),
                          ],
                        ),
                      ),
                      CupertinoTextField(
                        focusNode: _titleFocusNode,
                        textInputAction: TextInputAction.next,
                        controller: _titleController,
                        placeholder: _titleLabel,
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          setState(() {
                            bloc.validateTitle(
                                value,
                                _titleWhitespaceMessage,
                                _titleMaxLengthMessage
                            );
                          });
                        },
                        onSubmitted: (value) {
                          _focusChange(
                              context, _titleFocusNode, _departureFocusNode);
                        },
                      ),
                      Text(
                          CupertinoFormErrorFormatter.formatErrorMessage(
                              bloc.titleError
                          ),
                          style: ApplicationTheme.iosFormErrorStyle),
                      SizedBox(height: 5),
                      CupertinoTextField(
                        textCapitalization: TextCapitalization.words,
                        focusNode: _departureFocusNode,
                        textInputAction: TextInputAction.next,
                        controller: _departureController,
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                        placeholder: _departureLabel,
                        onChanged: (value) {
                          setState(() {
                            bloc.validateDepartureAddress(
                                value,
                                _addressWhitespaceMessage,
                                _addressMaxLengthMessage,
                                _addressInvalidMessage);
                          });
                        },
                        onSubmitted: (value) {
                          _focusChange(
                              context,
                              _departureFocusNode,
                              _destinationFocusNode
                          );
                        },
                      ),
                      Text(
                          CupertinoFormErrorFormatter.formatErrorMessage(
                              bloc.departureError
                          ),
                          style: ApplicationTheme.iosFormErrorStyle),
                      SizedBox(height: 5),
                      CupertinoTextField(
                        textCapitalization: TextCapitalization.words,
                        focusNode: _destinationFocusNode,
                        textInputAction: TextInputAction.next,
                        controller: _destinationController,
                        placeholder: _destinationLabel,
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          setState(() {
                            bloc.validateDestinationAddress(
                                value,
                                _addressWhitespaceMessage,
                                _addressMaxLengthMessage,
                                _addressInvalidMessage);
                          });
                        },
                        onSubmitted: (value) {
                          _focusChange(
                              context, _destinationFocusNode, _distanceFocusNode);
                        },
                      ),
                      Text(
                          CupertinoFormErrorFormatter.formatErrorMessage(
                              bloc.destinationError
                          ),
                          style: ApplicationTheme.iosFormErrorStyle),
                      SizedBox(height: 5),
                      CupertinoTextField(
                        focusNode: _distanceFocusNode,
                        textInputAction: TextInputAction.done,
                        controller: _distanceController,
                        placeholder: _distanceLabel,
                        suffix: Text("${S.of(context).DistanceKm} "),
                        autocorrect: false,
                        keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                        onChanged: (value) {
                          setState(() {
                            bloc.validateDistance(
                              value,
                              _distanceInvalidMessage,
                              _distancePositiveMessage,
                              _distanceMaximumMessage,
                            );
                          });
                        },
                        onSubmitted: (value) {
                          _distanceFocusNode.unfocus();
                        },
                      ),
                      Text(
                          CupertinoFormErrorFormatter.formatErrorMessage(
                              bloc.distanceError
                          ),
                          style: ApplicationTheme.iosFormErrorStyle),
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              child: Center(
                child: EditRideSubmit(bloc.stream,() async {
                  if(iosAllFormInputValidator()){
                    await bloc.editRide().then((updatedRide){
                      ReloadDataProvider.of(context).reloadRides.value = true;
                      SelectedItemProvider.of(context).selectedRide.value = updatedRide;
                      Navigator.pop(context);
                    },onError: (error){
                      //the submit will handle the 'actual' error
                    });
                  }
                }),
              )
            ),
          ],
        ),
      ),
    );
  }
}
