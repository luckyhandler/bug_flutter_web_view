import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  // it should be the first line in main method
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final ChromeSafariBrowser _browser;
  String _text = "Press the button below to open the browser";

  @override
  void initState() {
    _browser = CloseAwareChromeSafariBrowser(
      onBrowserClosed: () {
        setState(() {
          _text = "Browser closed!";
        });
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    if (_browser.isOpened()) {
      _browser.close();
    }
    super.dispose();
  }

  Future<void> _openBrowser() async {
    setState(() {
      _text = "Opened browser!";
    });
    await _browser.open(
      settings: ChromeSafariBrowserSettings(
        noHistory: true,
        isSingleInstance: true,
        showTitle: false,
        enableUrlBarHiding: true,
        barCollapsingEnabled: true,
      ),
      url: WebUri.uri(
        Uri.parse('https://www.flutter.dev'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(_text),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openBrowser,
        child: const Icon(Icons.open_in_browser),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CloseAwareChromeSafariBrowser extends ChromeSafariBrowser {
  CloseAwareChromeSafariBrowser({
    required this.onBrowserClosed,
  });

  final VoidCallback onBrowserClosed;

  @override
  void onClosed() {
    super.onClosed();
    onBrowserClosed();
  }
}
