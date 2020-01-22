import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmamobile/src/screens/enrollment/widgets/welcome.dart';
import 'package:irmamobile/src/theme/irma_icons.dart';

class CancelButton extends StatelessWidget {
  final String routeName;
  final void Function() cancel;

  const CancelButton({@required this.routeName, this.cancel});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(IrmaIcons.arrowBack, semanticLabel: FlutterI18n.translate(context, "accessibility.back")),
      iconSize: 20.0,
      onPressed: () {
        if (cancel != null) {
          cancel();
        }
        Navigator.of(context)
            .popUntil((route) => route.settings.name == routeName || route.settings.name == Welcome.routeName);
      },
      tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
    );
  }
}
