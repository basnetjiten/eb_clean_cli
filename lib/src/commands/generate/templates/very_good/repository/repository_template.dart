/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 */

import 'dart:io';

import 'package:eb_clean_cli/src/commands/generate/templates/very_good/repository/repository.dart';
import 'package:eb_clean_cli/src/template.dart';
import 'package:mason_logger/mason_logger.dart';

class RepositoryTemplate extends Template {
  RepositoryTemplate()
      : super(
          name: 'repository',
          bundle: repositoryBundle,
          help: 'generates repository in very good project',
          path: 'packages/repositories/lib/src/repositories/',
        );

  @override
  Future<void> onGenerateComplete(Logger logger, Directory outputDirectory, [bool recursive = false]) async {
    // final buildDone = logger
    //     .progress('Running ${lightGreen.wrap('flutter pub run build_runner build --delete-conflicting-outputs')}');
    // await FlutterCli.runBuildRunner(cwd: outputDirectory.path, recursive: recursive);
    // buildDone('Successfully generated files');
  }
}
