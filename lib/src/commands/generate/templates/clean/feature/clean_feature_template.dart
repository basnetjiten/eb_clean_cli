/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 */

import 'dart:io';

import 'package:eb_clean_cli/src/cli/cli.dart';
import 'clean_feature_bundle.dart';
import 'package:eb_clean_cli/src/template.dart';
import 'package:mason_logger/mason_logger.dart';

class CleanFeatureTemplate extends Template {
  CleanFeatureTemplate()
      : super(
          name: 'clean_feature',
          bundle: cleanFeatureBundle,
          help: 'Generates full feature',
          path: 'lib/src/features/',
        );

  @override
  Future<void> onGenerateComplete(Logger logger, Directory outputDirectory, [bool recursive = false]) async {
    final buildDone = logger.progress('Running ${lightGreen.wrap('flutter pub run build_runner build --delete-conflicting-outputs')}');
    await FlutterCli.runBuildRunner(cwd: outputDirectory.path);
    buildDone('Successfully generated files');
  }
}
