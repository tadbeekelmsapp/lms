import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebView extends StatefulWidget {
  const WebView({ Key? key, required this.uri, this.appBar }) : super(key: key);

  final Uri uri;
  final PreferredSizeWidget? appBar;

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      body: Stack(
        children: [
          Positioned(
            child: InAppWebView(
             onLoadHttpError: (controller, url, statusCode, description) {
                print('description....');
                print(description);
              },
              initialUrlRequest: URLRequest(url: widget.uri),
              initialOptions: InAppWebViewGroupOptions(
                android: AndroidInAppWebViewOptions(
                  useHybridComposition: true,
                ),
              ),
              onLoadStart: (controller, _uri) {
                setState(() {
                  _isLoading = true;
                });
                print('loading started');
              },
              onLoadStop: (controller, _uri) {
                print('loading stopped');
                setState(() {
                  _isLoading = false;
                });
              },
            ),
          ),
          _isLoading ? Positioned(
            child: Center(child: CircularProgressIndicator())
          ) : const SizedBox.shrink(),
        ],
      )
    );
  }
}