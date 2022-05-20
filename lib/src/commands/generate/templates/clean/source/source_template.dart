/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 */
import 'dart:io';

import 'package:eb_clean_cli/src/commands/generate/templates/clean/source/source_bundle.dart';
import 'package:eb_clean_cli/src/template.dart';
import 'package:mason_logger/mason_logger.dart';

class SourceTemplate extends Template {
  SourceTemplate()
      : super(name: 'source', bundle: sourceBundle, help: 'generates source class', path: 'lib/src/features/');

  @override
  Future<void> onGenerateComplete(Logger logger, Directory outputDirectory, [bool recursive = false]) async {}
}
