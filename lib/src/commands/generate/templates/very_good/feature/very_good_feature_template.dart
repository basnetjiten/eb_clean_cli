/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 */

import 'dart:io';

import 'very_good_feature_bundle.dart';
import 'package:eb_clean_cli/src/template.dart';
import 'package:mason_logger/mason_logger.dart';

class VeryGoodFeatureTemplate extends Template {
  VeryGoodFeatureTemplate()
      : super(
          name: 'very_good_feature',
          help: 'generates very good feature',
          bundle: veryGoodFeatureBundle,
          path: 'lib/src/features/',
        );

  @override
  Future<void> onGenerateComplete(Logger logger, Directory outputDirectory, [bool recursive = false]) async {}
}
