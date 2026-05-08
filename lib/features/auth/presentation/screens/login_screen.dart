import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/api/endpoints.dart';
import '../bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final WebViewController _controller;
  final _shopController = TextEditingController();
  bool _isLoading = false;
  bool _showWebView = false;

  @override
  void initState() {
    super.initState();
    
    // webview_flutter does not support Windows/Linux/MacOS
    final isSupported = kIsWeb || defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;
    
    if (isSupported) {
      _controller = WebViewController();
      
      if (!kIsWeb) {
        _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
        final delegate = NavigationDelegate(
          onPageStarted: (url) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (url) {
            if (mounted) setState(() => _isLoading = false);
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('token=')) {
              final uri = Uri.parse(request.url);
              final token = uri.queryParameters['token'];
              final refreshToken = uri.queryParameters['refresh_token'];
              
              if (token != null) {
                context.read<AuthBloc>().add(AuthEvent.tokenRefreshed(
                  accessToken: token,
                  refreshToken: refreshToken,
                ));
                return NavigationDecision.prevent;
              }
            }
            return NavigationDecision.navigate;
          },
        );
        _controller.setNavigationDelegate(delegate);
      }
    }
  }

  void _startLogin() {
    final shop = _shopController.text.trim();
    if (shop.isEmpty || !shop.contains('.myshopify.com')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid .myshopify.com domain')),
      );
      return;
    }

    setState(() {
      _showWebView = true;
      _isLoading = true;
    });

    final url = Uri.parse('${Endpoints.baseUrl}/auth/install').replace(
      queryParameters: {'shop': shop},
    );
    
    _controller.loadRequest(url);
  }

  @override
  Widget build(BuildContext context) {
    final isSupported = kIsWeb || defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;

    if (!isSupported) {
      return Scaffold(
        appBar: AppBar(title: const Text('Shopify Merchant Login')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.computer, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'WebView is not supported on Windows.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please use an Android Emulator, iOS Simulator, or Chrome to log in.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (!_showWebView) {
      return Scaffold(
        appBar: AppBar(title: const Text('Shopify Merchant Login')),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.storefront, size: 80, color: Color(0xFF95BF47)),
              const SizedBox(height: 24),
              const Text(
                'Enter your Shopify store URL',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _shopController,
                decoration: const InputDecoration(
                  labelText: 'Store Domain',
                  hintText: 'example.myshopify.com',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.link),
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _startLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF95BF47),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Connect Store', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_shopController.text),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => _showWebView = false),
        ),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
