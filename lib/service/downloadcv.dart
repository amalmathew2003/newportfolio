import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// For web
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

// For mobile/desktop
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

Future<void> downloadCV(BuildContext context) async {
  const url =
      'https://drive.google.com/uc?export=download&id=1IHv9wvUS_4hLGwYae-wX0sOlYwpYr1cx';

  try {
    if (kIsWeb) {
      // Show loader
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Colors.blueAccent),
        ),
      );

      await Future.delayed(const Duration(seconds: 2)); // fake wait

      // ✅ Trigger download
      html.AnchorElement anchorElement = html.AnchorElement(href: url)
        ..setAttribute("download", "AmalMathewCV.pdf")
        ..click();

      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('CV download started')));
    } else {
      // ✅ Mobile/Desktop download
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: Colors.blueAccent,
            strokeWidth: 4,
          ),
        ),
      );

      Directory dir;
      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory();
      } else {
        dir = await getDownloadsDirectory() ?? await getTemporaryDirectory();
      }

      final filePath = '${dir.path}/AmalMathewCV.pdf';
      final dio = Dio();

      await dio.download(url, filePath);

      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('CV downloaded to: $filePath')));
      debugPrint('✅ CV saved at: $filePath');
    }
  } catch (e) {
    debugPrint('❌ Error downloading CV: $e');
    if (Navigator.canPop(context)) Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Error downloading CV: $e')));
  }
}
