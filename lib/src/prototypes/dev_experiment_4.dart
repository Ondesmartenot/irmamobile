import 'package:flutter/material.dart';
import 'package:irmamobile/src/data/irma_repository.dart';
import 'package:irmamobile/src/screens/pin/pin_screen.dart';
import 'package:irmamobile/src/theme/theme.dart';

void startDevExperiment4(BuildContext context) {
  // Start this experiment in locked state
  IrmaRepository.get().lock();

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) {
        return PinScreen(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('App unlocked'),
            ),
            body: Center(
              child: Container(
                color: IrmaTheme.of(context).interactionInformation,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("The app is now unlocked"),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}