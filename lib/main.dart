import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/utils/webview_initializer_mobile.dart'
    if (dart.library.js_util) 'core/utils/webview_initializer_web.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  registerWebViewWeb();
  
  runApp(const ShopifyApp());
}
