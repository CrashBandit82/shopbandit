import 'package:flutter/material.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:go_router/go_router.dart';

import 'widgets.dart';

/// QR scanner (zxing-cpp, no Google ML Kit). Pops with the scanned text.
class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _done = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.t.scanInvite)),
      body: ReaderWidget(
        codeFormat: Format.qrCode,
        showGallery: false,
        showToggleCamera: false,
        tryHarder: true,
        onScan: (code) {
          final text = code.text;
          if (_done || !code.isValid || text == null) return;
          _done = true;
          context.pop(text);
        },
      ),
    );
  }
}
