import 'package:digipath_ircs/Global/Toast.dart';
import 'package:digipath_ircs/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  const WebViewPage({Key? key, required this.url}) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState(url);
}

class _WebViewPageState extends State<WebViewPage> {

  _WebViewPageState(this.url);

  late String url;
  late final WebViewController _controller;

  // _loadHtmlFromAssets() async {
  //   String file = await rootBundle.loadString('assets/index.html');
  //   _controller.loadUrl(Uri.dataFromString(
  //       file,
  //       mimeType: 'text/html',
  //       encoding: Encoding.getByName('utf-8')).toString());
  // }

  void readResponse() async{

    print('enter responce:::');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: url,
        onWebViewCreated: (WebViewController webViewController) {
          setState(() {
            _controller = webViewController;
            // _loadHtmlFromAssets();
          });
        },
        javascriptMode: JavascriptMode.unrestricted,
        gestureNavigationEnabled: true,
        javascriptChannels: {
          JavascriptChannel(
              name: 'getMessage',
              onMessageReceived: (JavascriptMessage message) {
                String data =  message.message;
                print('Response after call url is::: $data');
                if(data == 'OK'){
                  showToast('Payment Successfully');
                  Get.offAll(const HomePage());
                }
                else if(data == 'FAIL'){
                  showToast('Payment Fail');
                }
              })
        },
        onPageFinished: (String url) async {
          // await _controller.runJavascriptReturningResult('your js code');
          print('enter finished:::');
        },
      ),
    );
  }
}