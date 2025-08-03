import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TestFetchImageFromGoogle extends StatefulWidget {
  const TestFetchImageFromGoogle({super.key});

  @override
  State<TestFetchImageFromGoogle> createState() =>
      _TestFetchImageFromGoogleState();
}

class _TestFetchImageFromGoogleState extends State<TestFetchImageFromGoogle> {
  late final WebViewController _webViewController;
  String? selectedImageUrl;

  @override
  void initState() {
    super.initState();

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'ImageChannel',
        onMessageReceived: (message) {
          setState(() {
            selectedImageUrl = message.message;
            debugPrint('Image clicked: $selectedImageUrl');
          });
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(onPageFinished: (_) => _injectClickListener()),
      );

    _loadSearchResult("cat"); // load default keyword
  }

  void _loadSearchResult(String keyword) {
    final encoded = Uri.encodeComponent(keyword);
    final searchUrl = 'https://www.google.com/search?tbm=isch&q=$encoded';
    _webViewController.loadRequest(Uri.parse(searchUrl));
  }

  Future<void> _injectClickListener() async {
    await _webViewController.runJavaScript('''
      function attachClickHandlers() {
        document.querySelectorAll('img').forEach(img => {
          if (!img.hasAttribute('data-listener')) {
            img.setAttribute('data-listener', 'true');
            img.onclick = () => {
              let url = img.getAttribute('data-src') || 
                        img.getAttribute('data-iurl') || 
                        img.src;
              if (url) {
                ImageChannel.postMessage(url);
              }
            };
          }
        });
      }

      attachClickHandlers();
      const observer = new MutationObserver(() => attachClickHandlers());
      observer.observe(document.body, { childList: true, subtree: true });
    ''');
  }

  Widget _buildImagePreview() {
    if (selectedImageUrl == null) return const SizedBox.shrink();

    if (selectedImageUrl!.startsWith('data:image')) {
      try {
        final base64Str = selectedImageUrl!.split(',').last;
        final bytes = base64Decode(base64Str);
        return Image.memory(
          bytes,
          height: 200,
          width: 200,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Text("Invalid base64 image"),
        );
      } catch (_) {
        return const Text("Invalid base64 format");
      }
    }

    return Image.network(
      selectedImageUrl!,
      height: 200,
      width: 200,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Text("Failed to load image"),
    );
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image Search with WebView")),
      body: Column(
        children: [
          Expanded(
            child: WebViewWidget(controller: _webViewController),
          ),
          if (selectedImageUrl != null) const Divider(),
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.amberAccent,
            alignment: Alignment.center,
            child: _buildImagePreview(),
          ),
        ],
      ),
    );
  }
}
