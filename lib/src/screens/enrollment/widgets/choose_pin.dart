import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmamobile/src/screens/enrollment/models/enrollment_bloc.dart';
import 'package:irmamobile/src/screens/enrollment/models/enrollment_state.dart';
import 'package:irmamobile/src/screens/enrollment/widgets/cancel_button.dart';
import 'package:irmamobile/src/screens/enrollment/widgets/welcome.dart';
import 'package:irmamobile/src/theme/theme.dart';
import 'package:irmamobile/src/widgets/error_message.dart';
import 'package:irmamobile/src/widgets/pin_field.dart';

class ChoosePin extends StatelessWidget {
  static const String routeName = 'choose_pin';

  final void Function(BuildContext, String) submitPin;
  final void Function() cancel;

  const ChoosePin({@required this.submitPin, @required this.cancel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: IrmaTheme.of(context).grayscale85,
        leading: CancelButton(routeName: Welcome.routeName, cancel: cancel),
        title: Text(
          FlutterI18n.translate(context, 'enrollment.choose_pin.title'),
        ),
      ),
      body: BlocBuilder<EnrollmentBloc, EnrollmentState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: IrmaTheme.of(context).largeSpacing),
              child: Column(
                children: [
                  if (state.showPinValidation && !state.pinConfirmed) ...[
                    const ErrorMessage(message: 'enrollment.choose_pin.error'),
                    SizedBox(height: IrmaTheme.of(context).defaultSpacing)
                  ],
                  Text(
                    FlutterI18n.translate(context, 'enrollment.choose_pin.insert_pin'),
                    style: Theme.of(context).textTheme.body1,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: IrmaTheme.of(context).defaultSpacing),
                  PinField(maxLength: 5, onSubmit: (pin) => submitPin(context, pin)),
                  SizedBox(height: IrmaTheme.of(context).defaultSpacing),
                  Text(
                    FlutterI18n.translate(context, 'enrollment.choose_pin.instruction'),
                    style: Theme.of(context).textTheme.body1,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
