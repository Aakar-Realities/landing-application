import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

const _websiteUrl = 'https://landingpage-v1-six.vercel.app/';
const _brandColor = Color(0xFF153B35);

void main() {
  runApp(const AakarRealitiesApp());
}

class AakarRealitiesApp extends StatelessWidget {
  const AakarRealitiesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aakar Realities',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _brandColor),
        useMaterial3: true,
      ),
      home: const WebsiteScreen(),
    );
  }
}

class WebsiteScreen extends StatefulWidget {
  const WebsiteScreen({super.key});

  @override
  State<WebsiteScreen> createState() => _WebsiteScreenState();
}

class _WebsiteScreenState extends State<WebsiteScreen> {
  late final WebViewController _controller;
  bool _canGoBack = false;
  bool _hasLoaded = false;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (!_hasLoaded) {
              setState(() => _isLoading = true);
            }
          },
          onPageFinished: _onPageFinished,
          onHttpError: (error) {
            if ((error.response?.statusCode ?? 0) >= 500) {
              _showError();
            }
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame == true) {
              _showError();
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(_websiteUrl));
  }

  Future<void> _onPageFinished(String _) async {
    final canGoBack = await _controller.canGoBack();
    if (!mounted) return;

    setState(() {
      _canGoBack = canGoBack;
      _hasLoaded = true;
      _isLoading = false;
      _hasError = false;
    });
  }

  void _showError() {
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _hasError = true;
    });
  }

  Future<void> _retryLoading() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    await _controller.reload();
  }

  Future<void> _handlePopInvoked(bool didPop, Object? result) async {
    if (didPop) return;

    final canGoBack = await _controller.canGoBack();
    if (!mounted) return;
    if (!canGoBack) {
      setState(() => _canGoBack = false);
      return;
    }

    await _controller.goBack();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: !_canGoBack,
      onPopInvokedWithResult: _handlePopInvoked,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: [
                WebViewWidget(controller: _controller),
                if (_isLoading)
                  const ColoredBox(
                    color: Colors.white,
                    child: Center(
                      child: CircularProgressIndicator(color: _brandColor),
                    ),
                  ),
                if (_hasError)
                  _LoadErrorView(onRetry: _retryLoading),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadErrorView extends StatelessWidget {
  const _LoadErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Unable to load Aakar Realities',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _brandColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Check your internet connection and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF52615D), fontSize: 15),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: onRetry,
                style: FilledButton.styleFrom(
                  backgroundColor: _brandColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
