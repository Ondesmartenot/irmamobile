import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmamobile/src/screens/issuance_webview/issuance_webview_screen.dart';
import 'package:irmamobile/src/theme/theme.dart';
import 'package:share/share.dart';

class ExternalLink extends StatelessWidget {
  final String link;
  final String linkText;
  final Widget icon;

  const ExternalLink(this.link, this.linkText, this.icon);

  void _openURL(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return IssuanceWebviewScreen(url);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: IrmaTheme.of(context).defaultSpacing * 3,
          ),
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(
                  left: IrmaTheme.of(context).smallSpacing, right: IrmaTheme.of(context).defaultSpacing),
              child: icon,
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: InkWell(
              onTap: () {
                try {
                  _openURL(
                    context,
                    FlutterI18n.translate(context, link),
                  );
                } on PlatformException catch (e) {
                  debugPrint(e.toString());
                  debugPrint("error on launch of url - probably bad certificate?");
                }
              },
              child: Text(
                FlutterI18n.translate(context, linkText),
                style: TextStyle(color: IrmaTheme.of(context).linkColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class InternalLink extends StatelessWidget {
  final String link;
  final String linkText;
  final Widget icon;

  const InternalLink(this.link, this.linkText, this.icon);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: IrmaTheme.of(context).defaultSpacing * 3,
          ),
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(
                  left: IrmaTheme.of(context).smallSpacing, right: IrmaTheme.of(context).defaultSpacing),
              child: icon,
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, link);
              },
              child: Text(
                FlutterI18n.translate(context, linkText),
                style: TextStyle(color: IrmaTheme.of(context).linkColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ShareLink extends StatelessWidget {
  final String shareText;
  final String displayText;

  final Icon icon;

  const ShareLink(this.shareText, this.displayText, this.icon);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Padding(
            padding:
                EdgeInsets.only(left: IrmaTheme.of(context).smallSpacing, right: IrmaTheme.of(context).defaultSpacing),
            child: icon,
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            child: InkWell(
              onTap: () {
                final RenderBox box = context.findRenderObject() as RenderBox;
                Share.share(shareText, sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
              },
              child: Text(
                FlutterI18n.translate(context, displayText),
                style: TextStyle(color: IrmaTheme.of(context).linkColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}