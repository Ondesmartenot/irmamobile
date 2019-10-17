import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmamobile/src/theme/theme.dart';

class ErrorMessage extends StatelessWidget {
  final String message;

  ErrorMessage({
    @required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(IrmaTheme.of(context).spacing),
        margin: EdgeInsets.only(top: IrmaTheme.of(context).spacing, bottom: IrmaTheme.of(context).spacing),
        color: IrmaTheme.of(context).interactionInvalid,
        child: Text(
          FlutterI18n.translate(context, message),
          style: Theme.of(context).textTheme.headline.copyWith(color: Colors.white),
        ));
  }
}
