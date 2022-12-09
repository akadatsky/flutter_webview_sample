import 'package:flutter/material.dart';
import 'package:flutter_webview_sample/widgets/custom_web_view.dart';
import 'package:url_launcher/url_launcher.dart';

class WebviewPage extends StatelessWidget {
  final CustomWebViewScreenData screenData;
  final BuildContext context;
  final bool isShowControls;
  final bool isModalScreen;
  final bool rootNavigator;
  final String title;

  const WebviewPage({
    required this.screenData,
    required this.context,
    required this.isShowControls,
    required this.isModalScreen,
    required this.rootNavigator,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back),
      )),
      body: CustomWebView(
        screenData: screenData,
        onAppRedirect: (destination, url) {
          if ((destination == TargetRedirectScreen.openEmail ||
                  destination == TargetRedirectScreen.openPhone ||
                  destination == TargetRedirectScreen.thirdPartyApp) &&
              url != null) {
            launch(url);
          } else {
            Navigator.of(context, rootNavigator: rootNavigator).pop();
            _onAppRedirect(destination, context);
          }
        },
        isShowControls: isShowControls,
        isModalScreen: isModalScreen,
      ),
    );
  }

  void _onAppRedirect(TargetRedirectScreen destination, BuildContext context) {
    if (destination != TargetRedirectScreen.doNothing) {
      Navigator.of(context).popUntil((route) {
        return route.settings.name == '/';
      });
    }
    // TODO
  }
}
