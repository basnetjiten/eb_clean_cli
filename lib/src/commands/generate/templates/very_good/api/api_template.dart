/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 */

import 'dart:io';

import 'api_bundle.dart';
import 'package:eb_clean_cli/src/template.dart';
import 'package:mason_logger/mason_logger.dart';

class ApiTemplate extends Template {
  ApiTemplate()
      : super(
          name: 'api',
          bundle: apiBundle,
          help: 'Creates API class in api package',
          path: 'packages/api/lib/src/apis/',
        );

  @override
  Future<void> onGenerateComplete(Logger logger, Directory outputDirectory, [bool recursive = false]) async {}
}
