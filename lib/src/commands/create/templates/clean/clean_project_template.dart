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

import 'clean.dart';

class CleanProjectTemplate extends Template {
  CleanProjectTemplate()
      : super(
          name: 'clean',
          bundle: cleanProjectBundle,
          help: 'Generates a clean project',
          path: '.',
        );

  @override
  Future<void> onGenerateComplete(Logger logger, Directory outputDirectory, [bool recursive = false]) async {
    await FlutterCli.copyEnvs(logger, outputDirectory.path);
    final pubDone = logger.progress('Running flutter pub get in ${outputDirectory.path}');
    await FlutterCli.pubGet(cwd: outputDirectory.path);
    pubDone('flutter pub get done');
    final buildDone = logger
        .progress('Running ${lightGreen.wrap('flutter pub run build_runner build --delete-conflicting-outputs')}');
    await FlutterCli.runBuildRunner(cwd: outputDirectory.path);
    buildDone('Successfully generated files');
    await FlutterCli.runIntlUtils(logger: logger);
  }
}
