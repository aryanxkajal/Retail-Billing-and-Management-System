

import 'package:flutter/material.dart';


import 'package:webview_flutter/webview_flutter.dart';

class Whatsapp1 extends StatefulWidget {
  const Whatsapp1({super.key});

  @override
  State<Whatsapp1> createState() => _Whatsapp1State();
}

class _Whatsapp1State extends State<Whatsapp1> {
   

 WebViewController? _controller;

  @override
  void initState() {
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
      ..loadRequest(Uri.parse('https://www.youtube.com/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        body: WebViewWidget(controller: _controller!));
  }



  
}


// ignore: must_be_immutable










/*

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp/whatsapp.dart';

import 'package:http/http.dart' as http;

class Whatsapp1 extends StatefulWidget {
  const Whatsapp1({super.key});

  @override
  State<Whatsapp1> createState() => _Whatsapp1State();
}

class _Whatsapp1State extends State<Whatsapp1> {


  WhatsApp whatsapp = WhatsApp();
  int phoneNumber = 919466275764;
  @override
  void initState() {
    whatsapp.setup(
      accessToken: "YOUR_ACCESS_TOKEN_HERE",
      fromNumberId: 000000000000000,
    );
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: TextButton(onPressed: () async {
             try {
      final response = await whatsapp.messagesTemplate(
        to: phoneNumber,
        templateName: "hello_world",
      );
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {
      print('Error: $e');
    }
            } ,child: Text('press')),
    );
  }
}*/