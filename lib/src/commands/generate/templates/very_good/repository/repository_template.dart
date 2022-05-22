/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 */

import 'dart:io';

import 'repository.dart';
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
  Future<void> onGenerateComplete(Logger logger, Directory outputDirectory, [bool recursive = false]) async {}
}
