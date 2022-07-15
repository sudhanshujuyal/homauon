
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Constant/constant.dart';
import 'Repository/app_repository.dart';
import 'model/appinfo.dart';

class Webview extends StatefulWidget {
  const Webview({Key? key}) : super(key: key);

  @override
  State<Webview> createState() => _WebviewState();
}

class _WebviewState extends State<Webview>
{
  late Future<AppInfo> appInfo;
  var iosVersion="1";
  var androidVersion="1";
  bool isChanged=false;
  bool skipupdate = false;
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  double progress = 0;
  final urlController = TextEditingController();


  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    appInfo=AppRepository.getAppInfo();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );

  }

  Future<bool> _goBack(BuildContext context) async {
    if (await webViewController!.canGoBack()) {
      webViewController!.goBack();
      return Future.value(false);
    } else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title:const Text(Constants.exit,style: TextStyle(fontSize: 16),),

            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child:const Text(Constants.cancel),
              ),
              ElevatedButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child:const Text(Constants.yes),
              ),
            ],
          ));
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:FutureBuilder<AppInfo>(
        future: appInfo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            if(int.parse(snapshot.data!.message![0].iosAppVersionCode) > int.parse(iosVersion))
            {
              if(skipupdate){
                return WillPopScope(
                  onWillPop: () => _goBack(context),
                  child: Scaffold(

                    body: Container(
                      margin: const EdgeInsets.only(top: 32),

                      child: InAppWebView(
                        key: webViewKey,
                        initialUrlRequest:
                        URLRequest(url: Uri.parse(snapshot.data!.message![0].appLink.toString())),
                        initialOptions: options,
                        pullToRefreshController: pullToRefreshController,
                        onWebViewCreated: (controller) {
                          webViewController = controller;
                        },
                        onLoadStart: (controller, url) {
                          setState(() {
                            url = Uri.parse(snapshot.data!.message![0].appLink.toString());
                            urlController.text = url.toString();
                          });
                        },
                        androidOnPermissionRequest: (controller, origin, resources) async {
                          return PermissionRequestResponse(
                              resources: resources,
                              action: PermissionRequestResponseAction.GRANT);
                        },
                        shouldOverrideUrlLoading: (controller, navigationAction) async {
                          var uri = navigationAction.request.url!;

                          if (![ "http", "https", "file", "chrome",
                            "data", "javascript", "about"].contains(uri.scheme)) {

                          }

                          return NavigationActionPolicy.ALLOW;
                        },
                        onLoadStop: (controller, url) async {
                          pullToRefreshController.endRefreshing();
                          setState(() {
                            url = Uri.parse(snapshot.data!.message![0].appLink.toString());
                            urlController.text = url.toString();
                          });
                        },
                        onLoadError: (controller, url, code, message) {
                          pullToRefreshController.endRefreshing();
                        },
                        onProgressChanged: (controller, progress) {
                          if (progress == 100) {
                            pullToRefreshController.endRefreshing();
                          }
                          setState(() {
                            this.progress = progress / 100;
                          });
                        },
                        onUpdateVisitedHistory: (controller, url, androidIsReload) {
                          setState(() {
                            url = Uri.parse(snapshot.data!.message![0].appLink.toString());
                            urlController.text = url.toString();
                          });
                        },
                        onConsoleMessage: (controller, consoleMessage) {
                          print(consoleMessage);
                        },
                      ),
                    ),
                  ),

                );
              }else{
                return _showMyDialog(snapshot);
              }
              // iosVersion=snapshot.data!.message![0].iosAppVersionCode;


            } else {
              return WillPopScope(
                onWillPop: () => _goBack(context),
                child: Scaffold(

                  body: Container(
                    margin: const EdgeInsets.only(top: 32),

                    child: InAppWebView(
                      key: webViewKey,
                      initialUrlRequest:
                      URLRequest(url: Uri.parse(snapshot.data!.message![0].appLink.toString())),
                      initialOptions: options,
                      pullToRefreshController: pullToRefreshController,
                      onWebViewCreated: (controller) {
                        webViewController = controller;
                      },
                      onLoadStart: (controller, url) {
                        setState(() {
                          url = Uri.parse(snapshot.data!.message![0].appLink.toString());
                          urlController.text = url.toString();
                        });
                      },
                      androidOnPermissionRequest: (controller, origin, resources) async {
                        return PermissionRequestResponse(
                            resources: resources,
                            action: PermissionRequestResponseAction.GRANT);
                      },
                      shouldOverrideUrlLoading: (controller, navigationAction) async {
                        var uri = navigationAction.request.url!;

                        if (![ "http", "https", "file", "chrome",
                          "data", "javascript", "about"].contains(uri.scheme)) {

                        }

                        return NavigationActionPolicy.ALLOW;
                      },
                      onLoadStop: (controller, url) async {
                        pullToRefreshController.endRefreshing();
                        setState(() {
                          url = Uri.parse(snapshot.data!.message![0].appLink.toString());
                          urlController.text = url.toString();
                        });
                      },
                      onLoadError: (controller, url, code, message) {
                        pullToRefreshController.endRefreshing();
                      },
                      onProgressChanged: (controller, progress) {
                        if (progress == 100) {
                          pullToRefreshController.endRefreshing();
                        }
                        setState(() {
                          this.progress = progress / 100;
                        });
                      },
                      onUpdateVisitedHistory: (controller, url, androidIsReload) {
                        setState(() {
                          url = Uri.parse(snapshot.data!.message![0].appLink.toString());
                          urlController.text = url.toString();
                        });
                      },
                      onConsoleMessage: (controller, consoleMessage) {
                        print(consoleMessage);
                      },
                    ),
                  ),
                ),

              );
            }

          }
          // return Text(snapshot.data!.message.toString());

          else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return Center(child: Scaffold(
            body: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Image.asset("Assets/logo.png"),
              ),
            ),
          ));
        },
      ),
    );
  }

  Widget _showMyDialog([AsyncSnapshot<AppInfo>? snapshot])
  {
    return  Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey,
      child: CupertinoAlertDialog(

        title: const Text("Update Available"),
        content: Text("New Version : ${snapshot!.data!.message![0].appName}"),
        actions: <Widget>[
          CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: (){
                _launchURL(snapshot.data!.message![0].appStoreLink.toString());
              },
              child: const Text("Yes")
          ),
          CupertinoDialogAction(
              textStyle: const TextStyle(color: Colors.red),
              isDefaultAction: true,
              onPressed: () async {
                setState(() {
                  skipupdate = true;
                });
              },
              child: const Text("Skip")
          ),
        ],
      ),
    );

  }

  void _launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }
}
