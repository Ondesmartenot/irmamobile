import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'package:irmamobile/src/models/credential.dart';
import 'package:irmamobile/src/widgets/card/card.dart';
import 'package:irmamobile/src/screens/wallet/widgets/wallet_button.dart';
import 'package:irmamobile/src/theme/theme.dart';

class Wallet extends StatefulWidget {
  final List<Credential> credentials; // null when pending
  final VoidCallback qrCallback;
  final VoidCallback helpCallback;

  const Wallet({this.credentials, this.qrCallback, this.helpCallback});

  @override
  _WalletState createState() => _WalletState();

  void updateCard() {
    debugPrint("update card");
  }

  void removeCard() {
    debugPrint("remove card");
  }

  void addCard() {
    debugPrint("add card");
  }
}

class _WalletState extends State<Wallet> with TickerProviderStateMixin {
  final _padding = 15.0;
  final _animationDuration = 250;
  final _walletAspectRatio = 87 / 360; // wallet.svg
  final _cardTopBorderHeight = 10;
  final _cardTopHeight = 40;
  final _cardsMaxExtended = 5;
  final _dragTipping = 50;
  final _scrollOverflowTipping = 40;
  final _screenTopOffset = 110; // Might need tweaking depending on screen size
  final _walletShrinkTween = Tween<double>(begin: 0.0, end: 1.0);
  final _walletIconHeight = 60;
  final double dragDownFactor = 1.5;

  int drawnCardIndex = 0;
  AnimationController drawController;
  Animation<double> drawAnimation;
  WalletState cardInStackState = WalletState.halfway;
  WalletState oldState = WalletState.halfway;
  WalletState currentState = WalletState.minimal;
  double dragOffset = 0;

  @override
  void initState() {
    drawController = AnimationController(duration: Duration(milliseconds: _animationDuration), vsync: this);
    drawAnimation = CurvedAnimation(parent: drawController, curve: Curves.easeInOut)
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          if (oldState == WalletState.halfway || oldState == WalletState.full) {
            cardInStackState = oldState;
          }
          oldState = currentState;
          drawController.reset();
          dragOffset = 0;
        }
      });
    super.initState();
  }

  @mustCallSuper
  @protected
  @override
  void didUpdateWidget(Wallet oldWidget) {
    if (oldWidget.credentials == null && widget.credentials != null) {
      setNewState(WalletState.halfway);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: drawAnimation,
      builder: (BuildContext buildContext, Widget child) {
        final size = MediaQuery.of(buildContext).size;
        final walletTop = size.height - (size.width - 2 * _padding) * _walletAspectRatio - _screenTopOffset;

        int index = 0;
        double cardTop;

        return Stack(children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: _padding * 2, horizontal: _padding * 2),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: _padding),
                    child: SvgPicture.asset(
                      'assets/wallet/wallet_illustration.svg',
                      width: size.width / 2,
                    ),
                  ),
                  Text(
                    FlutterI18n.translate(context, 'wallet.caption'),
                    textAlign: TextAlign.center,
                    style: IrmaTheme.of(context).textTheme.body1,
                  ),
                  GestureDetector(
                    onTap: widget.addCard,
                    child: Text(
                      FlutterI18n.translate(context, 'wallet.add_data'),
                      textAlign: TextAlign.center,
                      style: IrmaTheme.of(context).hyperlinkTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SvgPicture.asset(
              'assets/wallet/wallet_back.svg',
              width: size.width,
            ),
          ),
          ...widget.credentials != null
              ? widget.credentials.map((credential) {
                  final double walletShrinkInterpolation = _walletShrinkTween.evaluate(drawAnimation);

                  // TODO for performance: positions can be cached
                  final double oldTop = calculateCardPosition(
                      state: oldState,
                      size: size,
                      index: index,
                      drawnCardIndex: drawnCardIndex,
                      dragOffset: dragOffset);

                  final double newTop = calculateCardPosition(
                      state: currentState, size: size, index: index, drawnCardIndex: drawnCardIndex, dragOffset: 0);

                  cardTop = interpolate(oldTop, newTop, walletShrinkInterpolation);

                  return (int _index) {
                    return Positioned(
                      left: 0,
                      right: 0,
                      top: walletTop - cardTop,
                      child: GestureDetector(
                        onTap: () {
                          cardTapped(_index, credential, size);
                        },
                        onVerticalDragStart: (DragStartDetails details) {
                          setState(() {
                            drawnCardIndex = _index;
                            dragOffset = details.localPosition.dy - _cardTopHeight / 2;
                          });
                        },
                        onVerticalDragUpdate: (DragUpdateDetails details) {
                          setState(() {
                            dragOffset = details.localPosition.dy - _cardTopHeight / 2;
                          });
                        },
                        onVerticalDragEnd: (DragEndDetails details) {
                          if ((dragOffset < -_dragTipping && currentState != WalletState.drawn) ||
                              (dragOffset > _dragTipping && currentState == WalletState.drawn)) {
                            cardTapped(_index, credential, size);
                          } else if (dragOffset > _dragTipping && currentState == WalletState.full) {
                            setNewState(WalletState.halfway);
                          } else {
                            drawController.forward();
                          }
                        },
                        child: IrmaCard(attributes: credential, scrollBeyondBoundsCallback: scrollBeyondBound),
                      ),
                    );
                  }(index++);
                })
              : [Align(alignment: Alignment.center, child: Text(FlutterI18n.translate(context, 'ui.loading')))],
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: <Widget>[
                IgnorePointer(
                    ignoring: true,
                    child: SvgPicture.asset(
                      'assets/wallet/wallet_front.svg',
                      width: size.width,
                      height: size.width * _walletAspectRatio,
                    )),
                Positioned(
                  left: 16,
                  bottom: ((size.width - 2 * _padding) * _walletAspectRatio - _walletIconHeight) / 2,
                  child: WalletButton(
                      svgFile: 'assets/wallet/btn_help.svg',
                      accessibleName: "wallet.help",
                      clickStreamSink: widget.helpCallback),
                ),
                Positioned(
                  right: 16,
                  bottom: ((size.width - 2 * _padding) * _walletAspectRatio - _walletIconHeight) / 2,
                  child: WalletButton(
                      svgFile: 'assets/wallet/btn_qrscan.svg',
                      accessibleName: "wallet.scan_qr_code",
                      clickStreamSink: widget.qrCallback),
                ),
              ],
            ),
          )
        ]);
      });

  void cardTapped(int index, Credential credential, Size size) {
    if (currentState == WalletState.drawn) {
      setNewState(cardInStackState);
    } else {
      if (isStackedClosely(currentState, index)) {
        setNewState(WalletState.full);
      } else {
        drawnCardIndex = index;
        setNewState(WalletState.drawn);
      }
    }
  }

  // Is the card in the area where cards are stacked closely together
  bool isStackedClosely(WalletState newState, int index) =>
      newState == WalletState.halfway &&
      widget.credentials.length >= _cardsMaxExtended &&
      index < _cardTopHeight / _cardTopBorderHeight;

  // When there are many attributes, the contents will scroll. When scrolled beyond the bottom bound,
  // a drag down will be triggered.
  void scrollBeyondBound(double y) {
    if (y > _scrollOverflowTipping && currentState == WalletState.drawn) {
      setNewState(cardInStackState);
    }
  }

  void setNewState(WalletState newState) {
    setState(() {
      oldState = currentState;
      currentState = newState;
      drawController.forward();
    });
  }

  double calculateCardPosition({WalletState state, Size size, int index, int drawnCardIndex, double dragOffset}) {
    double cardPosition;

    switch (state) {
      case WalletState.drawn:
        if (index == drawnCardIndex) {
          cardPosition = getWalletTop(size);
          cardPosition -= dragOffset;
        } else {
          cardPosition = -(index + 1) * _cardTopBorderHeight.toDouble();
          if (cardPosition < -_cardTopHeight) {
            cardPosition = -_cardTopHeight.toDouble();
          }
        }
        break;

      case WalletState.minimal:
        cardPosition = -(index + 1) * _cardTopBorderHeight.toDouble();
        if (cardPosition < -_cardTopHeight) {
          cardPosition = -_cardTopHeight.toDouble();
        }
        break;

      case WalletState.halfway:
        final double top = (widget.credentials.length - 1 - index).toDouble();

        // Many cards
        if (widget.credentials.length >= _cardsMaxExtended) {
          // Top small border cards
          if (index < _cardTopHeight / _cardTopBorderHeight) {
            cardPosition = (_cardsMaxExtended - _cardTopHeight / _cardTopBorderHeight + 2) * _cardTopHeight -
                index * _cardTopBorderHeight;

            // Other cards
          } else {
            cardPosition = (_cardsMaxExtended + 1 - index) * _cardTopHeight.toDouble();
          }

          // Dragging top small border cards
          if (drawnCardIndex < _cardTopHeight / _cardTopBorderHeight && index != drawnCardIndex) {
            cardPosition -= dragOffset;
          }

          // Few cards
        } else {
          cardPosition = top * _cardTopHeight.toDouble();
        }

        // Drag drawn card
        if (index == drawnCardIndex) {
          cardPosition -= dragOffset;
        }

        // Bottom cards are deeper in wallet
        if (cardPosition < 0) {
          cardPosition *= 2;
        }

        break;

      case WalletState.full:
        final top = min(getWalletTop(size), (widget.credentials.length - 1) * _cardTopHeight.toDouble());
        cardPosition = top - index * _cardTopHeight;
        // Active card
        if (index == drawnCardIndex) {
          cardPosition -= dragOffset;

          // Drag down
        } else if (dragOffset > _cardTopHeight - _cardTopBorderHeight) {
          if (index > drawnCardIndex) {
            cardPosition -= dragOffset *
                    ((drawnCardIndex - index) *
                            (1 / dragDownFactor - 1) /
                            (drawnCardIndex - (widget.credentials.length - 1)) +
                        1 / dragDownFactor) *
                    dragDownFactor -
                (_cardTopHeight - _cardTopBorderHeight);
          } else {
            cardPosition -= dragOffset - (_cardTopHeight - _cardTopBorderHeight);
          }
        }
        break;
    }

    return cardPosition;
  }

  // Get top position relative to the wallet
  double getWalletTop(Size size) => size.height - size.width * _walletAspectRatio - _screenTopOffset;

  double interpolate(double x1, double x2, double p) => x1 + p * (x2 - x1);
}

enum WalletState { drawn, halfway, full, minimal }