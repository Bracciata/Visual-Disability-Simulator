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
  String lastUrl = "https://google.com";
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
              initialUrl: lastUrl,
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
                lastUrl=url;
                print('Page finished loading: $url');
              },
            );
          }),
        ),
      ),
    );
  }

  Future<WebViewController> _webViewControllerFuture;

  Widget getFAB() {
    _webViewControllerFuture = _controller.future;
    return FutureBuilder<WebViewController>(
        future: _webViewControllerFuture,
        builder:
            (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
          final bool webViewReady =
              snapshot.connectionState == ConnectionState.done;
          final WebViewController controller = snapshot.data;
          return Column(mainAxisSize: MainAxisSize.min, children: [
            new Container(
                height: 70.0,
                width: 56.0,
                alignment: FractionalOffset.topCenter,
                child: new ScaleTransition(
                    scale: new CurvedAnimation(
                      parent: _aniController,
                      curve: new Interval(0.0, 1.0 - 0 / icons.length / 2.0,
                          curve: Curves.easeOut),
                    ),
                    child: new FloatingActionButton(
                        heroTag: null,
                        backgroundColor: backgroundColor,
                        mini: true,
                        child: new Icon(icons[0], color: foregroundColor),
                        onPressed: !webViewReady
                            ? null
                            : () async {
                                if (await controller.canGoBack()) {
                                  await controller.goBack();
                                } else {
                                  Scaffold.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("No back history item")),
                                  );
                                  return;
                                }
                              }))),
            new Container(
                height: 70.0,
                width: 56.0,
                alignment: FractionalOffset.topCenter,
                child: new ScaleTransition(
                    scale: new CurvedAnimation(
                      parent: _aniController,
                      curve: new Interval(0.0, 1.0 - 1 / icons.length / 2.0,
                          curve: Curves.easeOut),
                    ),
                    child: new FloatingActionButton(
                      heroTag: null,
                      backgroundColor: backgroundColor,
                      mini: true,
                      child: new Icon(icons[1], color: foregroundColor),
                      onPressed: !webViewReady
                          ? null
                          : () {
                              controller.reload();
                            },
                    ))),
            new Container(
                height: 70.0,
                width: 56.0,
                alignment: FractionalOffset.topCenter,
                child: new ScaleTransition(
                    scale: new CurvedAnimation(
                      parent: _aniController,
                      curve: new Interval(0.0, 1.0 - 1 / icons.length / 2.0,
                          curve: Curves.easeOut),
                    ),
                    child: new FloatingActionButton(
                      heroTag: null,
                      backgroundColor: backgroundColor,
                      mini: true,
                      child: new Icon(icons[2], color: foregroundColor),
                      onPressed: !webViewReady
                          ? null
                          : () {
                              _navigateElsewhere(snapshot.data);
                            },
                    ))),
            // Refresh

            new FloatingActionButton(
              heroTag: null,
              child: new AnimatedBuilder(
                animation: _aniController,
                builder: (BuildContext context, Widget child) {
                  return new Transform(
                    transform: new Matrix4.rotationZ(
                        _aniController.value * 0.5 * math.pi),
                    alignment: FractionalOffset.center,
                    child: new Icon(_aniController.isDismissed
                        ? Icons.language
                        : Icons.close),
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
          ]);
        });
  }

  TextEditingController urlTextController = new TextEditingController();
  Future<void> _navigateElsewhere(WebViewController controller) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select assignment'),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () {},
                  child: TextFormField(
                    controller: urlTextController,
                    decoration: InputDecoration(labelText: 'Enter the website'),
                  )),
              SimpleDialogOption(
                  onPressed: () {
                    // DO NOTHING
                  },
                  child: RaisedButton(
                    child: Text('Submit'),
                    onPressed: () async {
                      // submit
                      await controller.loadUrl(urlTextController.text);
                                          },
                  )),
            ],
          );
        });
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
