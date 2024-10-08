import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WhatsAppWebView extends StatefulWidget {
  final String url; // WhatsApp URL to open

  WhatsAppWebView({required this.url});

  @override
  _WhatsAppWebViewState createState() => _WhatsAppWebViewState();
}

class _WhatsAppWebViewState extends State<WhatsAppWebView> {
   WebViewController? _controller;

  @override
 /* void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://github.com/bahrie127'));
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Github Code with Bahri"),
          actions: const [],
        ),
        body: Container()
        //WebViewWidget(controller: _controller!)
        );
  }
}
