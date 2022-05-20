/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 */

import 'dart:io';

import 'package:eb_clean_cli/src/commands/generate/templates/clean/repository/clean_repository_bundle.dart';
import 'package:eb_clean_cli/src/template.dart';
import 'package:mason_logger/mason_logger.dart';

class CleanRepositoryTemplate extends Template {
  CleanRepositoryTemplate()
      : super(
          name: 'clean_repository',
          bundle: cleanRepositoryBundle,
          help: 'generates repository in specific feature',
          path: 'lib/src/features/',
        );

  @override
  Future<void> onGenerateComplete(Logger logger, Directory outputDirectory, [bool recursive = false]) async {
    logger.info('created');
  }
}
