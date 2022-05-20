/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 */
import 'dart:io';

import 'package:eb_clean_cli/src/commands/generate/templates/model/model_bundle.dart';
import 'package:eb_clean_cli/src/template.dart';
import 'package:mason_logger/mason_logger.dart';

class ModelTemplate extends Template {
  ModelTemplate()
      : super(
          name: 'model',
          bundle: modelBundle,
          help: 'generates model',
          path: 'models/',
        );

  @override
  Future<void> onGenerateComplete(Logger logger, Directory outputDirectory, [bool recursive = false]) async {}
}
