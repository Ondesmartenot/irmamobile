// This code is not null safe yet.
// @dart=2.11

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:irmamobile/src/theme/theme.dart';
import 'package:irmamobile/src/widgets/irma_themed_button.dart';

class IrmaButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final VoidCallback onPressedDisabled;
  final TextStyle textStyle;
  final IrmaButtonSize size;
  final double minWidth;
  final IconData icon;
  final Color color;

  const IrmaButton({
    Key key,
    @required this.label,
    @required this.onPressed,
    this.onPressedDisabled,
    this.textStyle,
    this.size,
    this.minWidth = 232,
    this.icon,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IrmaThemedButton(
      label: label,
      onPressed: onPressed,
      onPressedDisabled: onPressedDisabled,
      textStyle: textStyle,
      size: size,
      minWidth: minWidth,
      icon: icon,
      color: color ?? IrmaTheme.of(context).primaryBlue,
      disabledColor: IrmaTheme.of(context).disabled,
      textColor: IrmaTheme.of(context).grayscaleWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    );
  }
}
