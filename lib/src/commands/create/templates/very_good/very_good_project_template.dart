/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 *
 */

import 'dart:io';

import 'package:eb_clean_cli/src/cli/cli.dart';
import 'package:eb_clean_cli/src/template.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as p;

import 'very_good.dart';

class VeryGoodProjectTemplate extends Template {
  VeryGoodProjectTemplate()
      : super(
          name: 'very_good',
          bundle: veryGoodProjectBundle,
          help: 'Generate a very good project',
          path: '.',
        );

  @override
  Future<void> onGenerateComplete(Logger logger, Directory outputDirectory, [bool recursive = false]) async {
    await FlutterCli.copyEnvs(logger, p.join(outputDirectory.path, 'packages/api/assets/.env'));
    final pubDone = logger.progress('Running flutter pub get...');
    await FlutterCli.pubGet(cwd: outputDirectory.path, recursive: true);
    pubDone();
    final fixDone = logger.progress('Running ${lightGreen.wrap('dart fix --apply')}');
    await DartCli.applyFixes(cwd: outputDirectory.path, recursive: true);
    fixDone();
    final buildDone = logger.progress('Running ${lightGreen.wrap('flutter pub run build_runner build --delete-conflicting-outputs')}');
    await FlutterCli.runBuildRunner(cwd: outputDirectory.path, recursive: true);
    buildDone();
    await FlutterCli.runIntlUtils(logger: logger, cwd: outputDirectory.path);
  }
}
