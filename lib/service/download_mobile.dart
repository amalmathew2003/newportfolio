import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:my_portfolio/data/social_links.dart';

Future<void> downloadCVPlatform(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF00FFA3),
        strokeWidth: 4,
      ),
    ),
  );

  try {
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
    await dio.download(SocialLinks.cvDownloadUrl, filePath);

    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('CV downloaded to: $filePath')));
    debugPrint('✅ CV saved at: $filePath');
  } catch (e) {
    debugPrint('❌ Error downloading CV: $e');
    if (Navigator.canPop(context)) Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Error downloading CV: $e')));
  }
}
