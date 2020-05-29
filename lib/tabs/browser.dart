import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'dart:math' as math;

class BrowserTab extends StatefulWidget {
  const BrowserTab({Key key}) : super(key: key);

  @override
  BrowserScreenState createState() => BrowserScreenState();
}

class BrowserScreenState extends State<BrowserTab>
    with TickerProviderStateMixin {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool launching = true;
  AnimationController _aniController;
  List<String> pastUrls = new List(30);
  static const List<IconData> icons = const [
    Icons.arrow_back,
    Icons.refresh,
    Icons.navigate_next
  ];

  @override
  void initState() {
    _aniController = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
  }

  Color backgroundColor;
  Color foregroundColor;
  @override
  Widget build(BuildContext context) {
    backgroundColor = Theme.of(context).cardColor;
    foregroundColor = Theme.of(context).accentColor;
    return Scaffold(
      backgroundColor: Colors.red,
      floatingActionButton: getFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: Container(
        child: Center(
          child: Builder(builder: (BuildContext context) {
            return WebView(
              initialUrl: 'https://flutter.dev',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                if (launching) {
                  _controller.complete(webViewController);
                  launching = false;
                }
              },

              // ignore: prefer_collection_literals
              javascriptChannels: <JavascriptChannel>[
                _toasterJavascriptChannel(context),
              ].toSet(),
              navigationDelegate: (NavigationRequest request) {
                /* if (request.url.startsWith('https://www.youtube.com/')) {
                  print('blocking navigation to $request}');
                  return NavigationDecision.prevent;
                }*/
                print('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {
                print('Page started loading: $url');
              },
              onPageFinished: (String url) {
                print('Page finished loading: $url');
                if (pastUrls.length == 30) {
                  print('Removing Last');
                  pastUrls.removeLast();
                }
                if (pastUrls.first != url) {
                  pastUrls.add(url);
                }
              },
            );
          }),
        ),
      ),
    );
  }

  Widget getFAB() {
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: new List.generate(icons.length, (int index) {
        Widget child = new Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: new ScaleTransition(
            scale: new CurvedAnimation(
              parent: _aniController,
              curve: new Interval(0.0, 1.0 - index / icons.length / 2.0,
                  curve: Curves.easeOut),
            ),
            child: new FloatingActionButton(
              heroTag: null,
              backgroundColor: backgroundColor,
              mini: true,
              child: new Icon(icons[index], color: foregroundColor),
              onPressed: () {
                switch (index) {
                  case 0:
                    // Go Back
                    return;
                  case 1:
                  // Refresh
                    return;
                  default:
                  // Navigate to a new page
                    return;
                }
              },
            ),
          ),
        );
        return child;
      }).toList()
        ..add(
          new FloatingActionButton(
            heroTag: null,
            child: new AnimatedBuilder(
              animation: _aniController,
              builder: (BuildContext context, Widget child) {
                return new Transform(
                  transform: new Matrix4.rotationZ(
                      _aniController.value * 0.5 * math.pi),
                  alignment: FractionalOffset.center,
                  child: new Icon(
                      _aniController.isDismissed ? Icons.share : Icons.close),
                );
              },
            ),
            onPressed: () {
              if (_aniController.isDismissed) {
                _aniController.forward();
              } else {
                _aniController.reverse();
              }
            },
          ),
        ),
    );
  }
}

JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
  return JavascriptChannel(
      name: 'Toaster',
      onMessageReceived: (JavascriptMessage message) {
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(message.message)),
        );
      });
}
