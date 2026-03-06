import 'package:flutter/material.dart';

import 'package:my_portfolio/service/download_stub.dart'
    if (dart.library.html) 'package:my_portfolio/service/download_web.dart'
    if (dart.library.io) 'package:my_portfolio/service/download_mobile.dart';

/// Downloads the CV — delegates to the platform-specific implementation.
Future<void> downloadCV(BuildContext context) async {
  await downloadCVPlatform(context);
}
