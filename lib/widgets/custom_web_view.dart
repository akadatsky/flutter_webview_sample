import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_webview_sample/res/colors.dart';
import 'package:flutter_webview_sample/utils/email_utils.dart';
import 'package:flutter_webview_sample/utils/logger.dart';
import 'package:flutter_webview_sample/utils/phone_utils.dart';
import 'package:flutter_webview_sample/widgets/divider.dart';

const redirectApps = [
  'instagram.com',
  'www.instagram.com',
  'youtube.com',
  'www.youtube.com',
  'youtu.be',
  'm.youtube.com',
  'facebook.com',
  'www.facebook.com',
  'm.facebook.com',
  't.me',
  'viber',
];

const linksToIgnore = [
  'https://www.work.ua/mobile-app/',
];

class CustomWebView extends StatefulWidget {
  final CustomWebViewScreenData screenData;
  final Function(
    TargetRedirectScreen destination,
    String? url,
  )? onAppRedirect;
  final bool isShowControls;
  final bool isModalScreen;

  const CustomWebView({
    required this.screenData,
    this.onAppRedirect,
    this.isShowControls = false,
    this.isModalScreen = false,
    Key? key,
  }) : super(key: key);

  @override
  CustomWebViewState createState() => CustomWebViewState();
}

class CustomWebViewScreenData {
  String? initUrl;
  Map<String, String>? headers;
  List<String> history = [];
  int historyPageIndex = 0;

  CustomWebViewScreenData({
    this.initUrl,
    this.headers,
  });
}

class CustomWebViewState extends State<CustomWebView> {
  bool webLoadError = false;
  late InAppWebViewController webView;

  @override
  void initState() {
    super.initState();
    if (widget.screenData.initUrl != null) {
      widget.screenData.history.add(widget.screenData.initUrl!);
    }
  }

  TargetRedirectScreen? _checkRedirectNeeded(String? url) {
    if (url?.isEmpty ?? false) {
      return null;
    }
    final uri = Uri.parse(url!);
    if (redirectApps.contains(uri.host.toLowerCase()) ||
        redirectApps.contains(uri.scheme.toLowerCase())) {
      return TargetRedirectScreen.thirdPartyApp;
    }
    if (url.startsWith('tel') &&
        PhoneUtils.validatePhone(url.replaceAll('tel:', ''))) {
      return TargetRedirectScreen.openPhone;
    } else if (url.startsWith('mailto') &&
        EmailUtils.validateEmail(url.replaceAll('mailto:', ''))) {
      return TargetRedirectScreen.openEmail;
    }
    if (url.startsWith('https://www.google.com/recaptcha') ||
        url.startsWith('https://vars.hotjar.com/') ||
        url.startsWith('https://accounts.google.com/o/')) {
      return TargetRedirectScreen.doNothing;
    } else {
      // TODO
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        webLoadError
            ? Flexible(
                child: Container(
                  color: AppColors.white,
                  child: const Text('No internet'),
                ),
              )
            : Flexible(
                child: WillPopScope(
                  onWillPop: Platform.isIOS
                      ? null
                      : () async {
                          if (widget.screenData.historyPageIndex > 0) {
                            await webView.loadUrl(
                              urlRequest: URLRequest(
                                url: Uri.tryParse(
                                  widget.screenData.history[
                                      widget.screenData.historyPageIndex - 1],
                                ),
                                headers: widget.screenData.headers,
                              ),
                            );
                            widget.screenData.historyPageIndex--;
                            return false;
                          } else {
                            return true;
                          }
                        },
                  child: InAppWebView(
                    gestureRecognizers: widget.isModalScreen
                        ? <Factory<OneSequenceGestureRecognizer>>{
                            Factory<VerticalDragGestureRecognizer>(
                              () => VerticalDragGestureRecognizer(),
                            ),
                          }
                        : <Factory<OneSequenceGestureRecognizer>>{},
                    androidOnPermissionRequest:
                        (controller, origin, resources) async {
                      return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT,
                      );
                    },
                    initialUrlRequest: URLRequest(
                      url: Uri.tryParse(widget.screenData.initUrl ?? ''),
                      headers: widget.screenData.headers,
                    ),
                    initialOptions: InAppWebViewGroupOptions(
                      ios: IOSInAppWebViewOptions(
                        disallowOverScroll: widget.isModalScreen ? true : false,
                      ),
                      android: AndroidInAppWebViewOptions(
                        useHybridComposition: true,
                      ),
                      crossPlatform: InAppWebViewOptions(
                        useShouldOverrideUrlLoading: true,
                        clearCache: true,
                        mediaPlaybackRequiresUserGesture: false,
                        userAgent: widget.screenData.initUrl!
                                .contains('youtube')
                            ? 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36'
                            : '',
                      ),
                    ),
                    onLoadStart: (controller, url) {
                      Log().d(
                        tag: 'CustomWebView -> onLoadStart -> url',
                        message: url,
                      );
                      setState(() {
                        webView = controller;
                        webLoadError = false;
                      });
                    },
                    onLoadHttpError: (controller, url, code, message) async {
                      Log().d(
                        tag: 'CustomWebView -> onLoadHttpError -> url',
                        message: url,
                      );
                      Log().d(
                        tag: 'CustomWebView -> onLoadHttpError -> code',
                        message: '$code',
                      );
                      Log().d(
                        tag: 'CustomWebView -> onLoadHttpError -> message',
                        message: message,
                      );
                      if (code == 403) {
                        // TODO
                      } else {
                        setState(() {
                          webView = controller;
                          webLoadError = true;
                        });
                      }
                    },
                    onLoadError: (controller, url, code, message) {
                      Log().d(
                        tag: 'CustomWebView -> onLoadError -> url',
                        message: url?.toString(),
                      );
                      Log().d(
                        tag: 'CustomWebView -> onLoadError -> code',
                        message: '$code',
                      );
                      Log().d(
                        tag: 'CustomWebView -> onLoadError -> message',
                        message: message,
                      );
                      if ((!(url?.toString().contains('t.me') ?? false)) &&
                          (!(url?.toString().contains('tg:') ?? false))) {
                        setState(() {
                          webView = controller;
                          webLoadError = true;
                        });
                      }
                    },
                    onWebViewCreated: (InAppWebViewController controller) {
                      webView = controller;
                    },
                    shouldOverrideUrlLoading: (controller, request) async {
                      Log().d(
                        tag: 'CustomWebView -> shouldOverrideUrlLoading -> url',
                        message: request.request.url,
                      );
                      final currentUrl = (await controller.getUrl()).toString();
                      final requestUrl = request.request.url?.toString() ?? '';
                      if (currentUrl.contains('youtube') &&
                          requestUrl.contains('youtube')) {
                        if (!currentUrl.contains('embed') ||
                            !requestUrl.contains('embed') ||
                            currentUrl != requestUrl) {
                          return NavigationActionPolicy.CANCEL;
                        } else {
                          return NavigationActionPolicy.ALLOW;
                        }
                      }
                      if (linksToIgnore.contains(requestUrl) ||
                          linksToIgnore.contains(currentUrl)) {
                        return NavigationActionPolicy.CANCEL;
                      }
                      if (Platform.isIOS && requestUrl.contains('t.me')) {
                        return NavigationActionPolicy.ALLOW;
                      }
                      if (requestUrl == 'about:blank') {
                        return NavigationActionPolicy.CANCEL;
                      }
                      final destination = _checkRedirectNeeded(requestUrl);
                      if (destination != null) {
                        if (destination == TargetRedirectScreen.thirdPartyApp) {
                          if (request.isForMainFrame) {
                            widget.onAppRedirect!(
                              destination,
                              requestUrl,
                            );
                            return NavigationActionPolicy.CANCEL;
                          } else {
                            return NavigationActionPolicy.ALLOW;
                          }
                        }
                        if (destination != TargetRedirectScreen.doNothing) {
                          widget.onAppRedirect!(
                            destination,
                            request.request.url?.toString(),
                          );
                          return NavigationActionPolicy.CANCEL;
                        }
                      } else if (!(request.request.headers ??
                              <String, String>{})
                          .containsKey('X-Authentication')) {
                        if (widget.screenData.historyPageIndex ==
                                (widget.screenData.history.length - 1) &&
                            (currentUrl != requestUrl)) {
                          widget.screenData.history.add(requestUrl);
                          widget.screenData.historyPageIndex++;
                        } else {
                          if (widget.screenData.history[
                                  widget.screenData.historyPageIndex + 1] !=
                              request.request.url?.toString()) {
                            widget.screenData.history =
                                widget.screenData.history.sublist(
                              0,
                              widget.screenData.historyPageIndex + 1,
                            );
                            widget.screenData.history.add(requestUrl);
                            widget.screenData.historyPageIndex++;
                          } else {
                            widget.screenData.historyPageIndex++;
                          }
                        }

                        if (currentUrl == requestUrl ||
                            requestUrl.contains('/comment/add/')) {
                          return NavigationActionPolicy.ALLOW;
                        }

                        await controller.loadUrl(
                          urlRequest: URLRequest(
                            url: Uri.tryParse(requestUrl),
                            headers: widget.screenData.headers,
                          ),
                        );
                        return NavigationActionPolicy.CANCEL;
                      }
                      return NavigationActionPolicy.ALLOW;
                    },
                    onCreateWindow: (
                      InAppWebViewController controller,
                      CreateWindowAction createWindowAction,
                    ) async {
                      await controller.loadUrl(
                        urlRequest: URLRequest(
                          url: createWindowAction.request.url,
                          headers: widget.screenData.headers,
                        ),
                      );
                      return true;
                    },
                  ),
                ),
              ),
        if (widget.isShowControls) ...{
          const SimpleDivider(
            AppColors.lightGray,
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom > 0.0 ? 18.0 : 0.0,
            ),
            child: SizedBox(
              height: 56,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    child: IconButton(
                      icon: const Icon(Icons.navigate_before),
                      onPressed: () async {
                        if (widget.screenData.historyPageIndex > 0) {
                          await webView.loadUrl(
                            urlRequest: URLRequest(
                              url: Uri.tryParse(
                                widget.screenData.history[
                                    widget.screenData.historyPageIndex - 1],
                              ),
                              headers: widget.screenData.headers,
                            ),
                          );
                          widget.screenData.historyPageIndex--;
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: const Icon(Icons.navigate_next),
                      onPressed: () async {
                        if (widget.screenData.historyPageIndex <
                            (widget.screenData.history.length - 1)) {
                          await webView.loadUrl(
                            urlRequest: URLRequest(
                              url: Uri.tryParse(
                                widget.screenData.history[
                                    widget.screenData.historyPageIndex + 1],
                              ),
                              headers: widget.screenData.headers,
                            ),
                          );
                          widget.screenData.historyPageIndex++;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        }
      ],
    );
  }
}

enum TargetRedirectScreen {
  doNothing,
  openEmail,
  openPhone,
  thirdPartyApp,
}
