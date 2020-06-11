import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/editRideBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/provider/rideProvider.dart';
import 'package:weforza/repository/rideRepository.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/pages/editRide/editRideSubmit.dart';
import 'package:weforza/widgets/platform/cupertinoFormErrorFormatter.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class EditRidePage extends StatefulWidget {
  @override
  _EditRidePageState createState() => _EditRidePageState(EditRideBloc(
      InjectionContainer.get<RideRepository>(), RideProvider.selectedRide));
}

class _EditRidePageState extends State<EditRidePage> {
  _EditRidePageState(this._bloc) : assert(_bloc != null) {
    _titleController = TextEditingController(text: _bloc.titleInput);
    _departureController = TextEditingController(text: _bloc.departureInput);
    _destinationController =
        TextEditingController(text: _bloc.destinationInput);
    _distanceController = TextEditingController(
        text: _bloc.distanceInput == 0.0 ? "" : "${_bloc.distanceInput}");
  }

  final EditRideBloc _bloc;

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
        translator.EditRideTitleMaxLength("${_bloc.titleMaxLength}");
    _titleWhitespaceMessage = translator.EditRideTitleWhitespace;
    _distanceInvalidMessage = translator.EditRideDistanceInvalid;
    _distancePositiveMessage = translator.EditRideDistancePositive;
    _distanceMaximumMessage =
        translator.EditRideDistanceMaximum("${_bloc.maxDistanceInKm}");
    _addressWhitespaceMessage = translator.EditRideAddressWhitespace;
    _addressMaxLengthMessage =
        translator.EditRideAddressMaxLength("${_bloc.addressMaxLength}");
    _addressInvalidMessage = translator.EditRideAddressInvalid;
  }

  @override
  Widget build(BuildContext context) {
    _initStrings(context);
    return PlatformAwareWidget(
      android: () => _buildAndroidLayout(context),
      ios: () => _buildIOSLayout(context),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
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
    final titleValid = _bloc.validateTitle(_titleController.text, _titleWhitespaceMessage, _titleMaxLengthMessage) == null;
    final departureValid = _bloc.validateDepartureAddress(
        _departureController.text,
        _addressWhitespaceMessage,
        _addressMaxLengthMessage,
        _addressInvalidMessage) == null;
    final destinationValid = _bloc.validateDestinationAddress(
        _destinationController.text,
        _addressWhitespaceMessage,
        _addressMaxLengthMessage,
        _addressInvalidMessage) == null;
    final distanceValid = _bloc.validateDistance(
      _distanceController.text,
      _distanceInvalidMessage,
      _distancePositiveMessage,
      _distanceMaximumMessage) == null;
    return titleValid && departureValid && destinationValid && distanceValid;
  }

  Widget _buildAndroidLayout(BuildContext context) {
    final ride = RideProvider.selectedRide;
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
                      Text(ride.getFormattedDate(context, false),
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16)),
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
                  validator: (value) => _bloc.validateTitle(
                      value, _titleWhitespaceMessage, _titleMaxLengthMessage),
                  autovalidate: _bloc.autoValidateTitle,
                  onChanged: (value) => setState(() {
                    _bloc.autoValidateTitle = true;
                  }),
                  onFieldSubmitted: (value) {
                    _focusChange(context, _titleFocusNode, _departureFocusNode);
                  },
                ),
                SizedBox(height: 5),
                TextFormField(
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
                  validator: (value) => _bloc.validateDepartureAddress(
                      value,
                      _addressWhitespaceMessage,
                      _addressMaxLengthMessage,
                      _addressInvalidMessage),
                  autovalidate: _bloc.autoValidateDepartureAddress,
                  onChanged: (value) => setState(() {
                    _bloc.autoValidateDepartureAddress = true;
                  }),
                  onFieldSubmitted: (value) {
                    _focusChange(
                        context, _departureFocusNode, _destinationFocusNode);
                  },
                ),
                SizedBox(height: 5),
                TextFormField(
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
                  validator: (value) => _bloc.validateDestinationAddress(
                      value,
                      _addressWhitespaceMessage,
                      _addressMaxLengthMessage,
                      _addressInvalidMessage),
                  autovalidate: _bloc.autoValidateDestinationAddress,
                  onChanged: (value) => setState(() {
                    _bloc.autoValidateDestinationAddress = true;
                  }),
                  onFieldSubmitted: (value) {
                    _focusChange(
                        context, _destinationFocusNode, _distanceFocusNode);
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
                  validator: (value) => _bloc.validateDistance(
                    value,
                    _distanceInvalidMessage,
                    _distancePositiveMessage,
                    _distanceMaximumMessage,
                  ),
                  autovalidate: _bloc.autoValidateDistance,
                  onChanged: (value) => setState(() {
                    _bloc.autoValidateDistance = true;
                  }),
                  onFieldSubmitted: (value) {
                    _distanceFocusNode.unfocus();
                  },
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                  child: Center(
                    child: EditRideSubmit(_bloc.stream, () async {
                      if (_formKey.currentState.validate()) {
                        await _bloc.editRide((Ride updatedRide) {
                          RideProvider.reloadRides = true;
                          RideProvider.selectedRide = updatedRide;
                          Navigator.pop(context);
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
    final ride = RideProvider.selectedRide;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        middle: Text(S.of(context).EditRidePageTitle),
      ),
      child: SafeArea(
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
                            Text(ride.getFormattedDate(context, false),
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
                            _bloc.validateTitle(value, _titleWhitespaceMessage,
                                _titleMaxLengthMessage);
                          });
                        },
                        onSubmitted: (value) {
                          _focusChange(
                              context, _titleFocusNode, _departureFocusNode);
                        },
                      ),
                      Text(
                          CupertinoFormErrorFormatter.formatErrorMessage(
                              _bloc.titleError),
                          style: ApplicationTheme.iosFormErrorStyle),
                      SizedBox(height: 5),
                      CupertinoTextField(
                        focusNode: _departureFocusNode,
                        textInputAction: TextInputAction.next,
                        controller: _departureController,
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                        placeholder: _departureLabel,
                        onChanged: (value) {
                          setState(() {
                            _bloc.validateDepartureAddress(
                                value,
                                _addressWhitespaceMessage,
                                _addressMaxLengthMessage,
                                _addressInvalidMessage);
                          });
                        },
                        onSubmitted: (value) {
                          _focusChange(
                              context, _departureFocusNode, _destinationFocusNode);
                        },
                      ),
                      Text(
                          CupertinoFormErrorFormatter.formatErrorMessage(
                              _bloc.departureError),
                          style: ApplicationTheme.iosFormErrorStyle),
                      SizedBox(height: 5),
                      CupertinoTextField(
                        focusNode: _destinationFocusNode,
                        textInputAction: TextInputAction.next,
                        controller: _destinationController,
                        placeholder: _destinationLabel,
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          setState(() {
                            _bloc.validateDestinationAddress(
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
                              _bloc.destinationError),
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
                            _bloc.validateDistance(
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
                              _bloc.distanceError),
                          style: ApplicationTheme.iosFormErrorStyle),
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              child: Center(
                child: EditRideSubmit(_bloc.stream,() async {
                  if(iosAllFormInputValidator()){
                    await _bloc.editRide((Ride updatedRide) {
                      RideProvider.reloadRides = true;
                      RideProvider.selectedRide = updatedRide;
                      Navigator.pop(context);
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
