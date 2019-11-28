import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:irmamobile/src/models/credential.dart';
import 'package:irmamobile/src/models/irma_configuration.dart';
import 'package:irmamobile/src/widgets/card/backgrounds.dart';
import 'package:irmamobile/src/widgets/card/card_attributes.dart';

class IrmaCard extends StatefulWidget {
  final String lang = ui.window.locale.languageCode;
  final _fullCardHeight = 400.0;

  final Credential attributes;
  final void Function(double) scrollBeyondBoundsCallback;

  IrmaCard({this.attributes, this.scrollBeyondBoundsCallback});

  @override
  _IrmaCardState createState() => _IrmaCardState();
}

class _IrmaCardState extends State<IrmaCard> with SingleTickerProviderStateMixin {
  final _borderRadius = const Radius.circular(15.0);
  final _padding = 16.0;

  // State
  bool isCardReadable = false;
  IrmaCardTheme irmaCardTheme;

  @override
  void initState() {
    irmaCardTheme = calculateIrmaCardColor(widget.attributes.issuer);

    super.initState();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onLongPress: () {
          setState(() {
            isCardReadable = true;
          });
        },
        onLongPressUp: () {
          setState(() {
            isCardReadable = false;
          });
        },
        child: Container(
          height: widget._fullCardHeight,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: irmaCardTheme.bgColorDark,
            gradient: LinearGradient(
                colors: [irmaCardTheme.bgColorDark, irmaCardTheme.bgColorLight],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
            border: Border.all(width: 1.0, color: irmaCardTheme.bgColorLight),
            borderRadius: BorderRadius.all(
              _borderRadius,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x77000000),
                blurRadius: 4.0,
                offset: Offset(
                  0.0,
                  2.0,
                ),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: _padding / 2,
                  left: _padding,
                  bottom: 0,
                ),
                child: Text(
                  widget.attributes.issuer.id,
                  style: Theme.of(context).textTheme.subhead.copyWith(color: irmaCardTheme.fgColor),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(_padding),
                  child: CardAttributes(
                      personalData: widget.attributes,
                      issuer: widget.attributes.issuer,
                      isCardUnblurred: isCardReadable,
                      lang: widget.lang,
                      irmaCardTheme: irmaCardTheme,
                      scrollOverflowCallback: widget.scrollBeyondBoundsCallback),
                ),
              ),
            ],
          ),
        ),
      );

  // Calculate a card color dependent of the issuer id
  //
  // This is to prevent all cards getting a different
  // color when a card is added or removed and confusing
  // the user.
  IrmaCardTheme calculateIrmaCardColor(Issuer issuer) {
    final int strNum = issuer.id.runes.reduce((oldChar, newChar) => (oldChar << 1) ^ newChar);

    return backgrounds[strNum % backgrounds.length];
  }
}