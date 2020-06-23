import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weforza/blocs/addDeviceBloc.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/repository/deviceRepository.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/custom/deviceTypeCarousel/deviceTypeCarousel.dart';
import 'package:weforza/widgets/platform/cupertinoFormErrorFormatter.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/providers/selectedItemProvider.dart';

class AddDevicePage extends StatefulWidget {
  @override
  _AddDevicePageState createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {

  AddDeviceBloc bloc;

  GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController _deviceNameController = TextEditingController(text: "");

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = AddDeviceBloc(
      repository: InjectionContainer.get<DeviceRepository>(),
      ownerId: SelectedItemProvider.of(context).selectedMember.value.uuid
    );
  }

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => _buildAndroidWidget(context),
    ios: () => _buildIosWidget(context),
  );

  Widget _buildAndroidWidget(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(S.of(context).AddDeviceTitle),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: <Widget>[
          _buildTypeCarousel(),
          Flexible(
            flex: 6,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                child: TextFormField(
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  controller: _deviceNameController,
                  validator: (value) => bloc.validateNewDeviceInput(
                      value,
                      S.of(context).ValueIsRequired(S.of(context).DeviceNameLabel),
                      S.of(context).DeviceNameMaxLength("${bloc.deviceNameMaxLength}")
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                    labelText: S.of(context).DeviceNameLabel,
                    helperText: " ",
                  ),
                  autovalidate: bloc.autoValidateNewDeviceName,
                  onChanged: (value) => setState((){
                    bloc.autoValidateNewDeviceName = true;
                  }),
                ),
              ),
            ),
          ),
          //TODO add device button
        ],
      ),
    );
  }

  Widget _buildIosWidget(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        middle: Text(S.of(context).AddDeviceTitle),
        automaticallyImplyLeading: true,
        transitionBetweenRoutes: false,
      ),
      child: Column(
        children: <Widget>[
          _buildTypeCarousel(),
          Flexible(
            flex: 6,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                child: Column(
                  children: <Widget>[
                    CupertinoTextField(
                      textInputAction: TextInputAction.done,
                      controller: _deviceNameController,
                      placeholder: S.of(context).DeviceNameLabel,
                      autocorrect: false,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() {
                          bloc.validateNewDeviceInput(
                              value,
                              S.of(context).ValueIsRequired(S.of(context).DeviceNameLabel),
                              S.of(context).DeviceNameMaxLength("${bloc.deviceNameMaxLength}")
                          );
                        });
                      },
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                            CupertinoFormErrorFormatter.formatErrorMessage(bloc.addDeviceError),
                            style: ApplicationTheme.iosFormErrorStyle
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          //TODO add device button
        ],
      ),
    );
  }

  Widget _buildTypeCarousel(){
    return Flexible(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
        child: DeviceTypeCarousel(
          controller: bloc.pageController,
          onPageChanged: bloc.onDeviceTypeChanged,
          currentPageStream: bloc.currentTypeStream,
        ),
      ),
    );
  }
}
