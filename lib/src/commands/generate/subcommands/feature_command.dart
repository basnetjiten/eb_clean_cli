/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 */
import 'package:args/command_runner.dart';
import 'package:eb_clean_cli/src/cli/cli.dart';
import 'package:eb_clean_cli/src/commands/generate/templates/clean/feature/feature.dart';
import 'package:eb_clean_cli/src/commands/generate/templates/very_good/feature/very_good_feature_bundle.dart';
import 'package:eb_clean_cli/src/commands/generate/templates/very_good/feature/very_good_feature_template.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';
import 'package:universal_io/io.dart';

import '../templates/very_good/api/api.dart';
import '../templates/very_good/repository/repository.dart';

class FeatureCommand extends Command<int> {
  FeatureCommand(this.logger) {
    argParser.addOption(
      'client',
      abbr: 'c',
      help: 'client to use as api client',
      allowed: ['dio', 'graphql'],
      defaultsTo: 'graphql',
    );
  }

  final Logger logger;

  @override
  String get description => 'generates full feature';

  @override
  String get name => 'feature';

  @override
  String get invocation => 'eb_clean generate feature --client <dio,graphql> <name>';

  @override
  String get summary => '$invocation\n$description';

  @override
  Future<int> run() async {
    final packageName = Directory.current.path.split('/').last;
    if (!FlutterCli.isVeryGoodProject()) {
      final args = argResults?.rest;
      if (args != null && args.isNotEmpty) {
        final client = argResults!['client'] as String? ?? 'graphql';
        final featureName = args.first;
        final featureTemplate = CleanFeatureTemplate();
        final featureDone = logger.progress('Generating ${featureName.pascalCase} feature');
        final featureGenerator = await MasonGenerator.fromBundle(cleanFeatureBundle);
        var vars = <String, dynamic>{
          'name': featureName,
          'useDio': client == 'dio',
          'package_name': packageName,
        };
        final cwd = Directory(p.join(Directory.current.path, featureTemplate.path));
        await featureGenerator.generate(DirectoryGeneratorTarget(cwd),
            fileConflictResolution: FileConflictResolution.overwrite, vars: vars);
        await featureGenerator.hooks.postGen(
          vars: vars,
          onVarsChanged: (v) => vars = v,
          workingDirectory: p.join(cwd.path, featureName),
        );
        featureDone('Generated ${featureName.pascalCase} feature in ${featureTemplate.path}');
        await featureTemplate.onGenerateComplete(logger, Directory.current);
      } else {
        throw UsageException('please provide feature name', usage);
      }
      return ExitCode.success.code;
    } else {
      final args = argResults?.rest;
      if (args != null && args.isNotEmpty) {
        final client = argResults!['client'] as String? ?? 'graphql';
        final featureName = args.first;
        final featureTemplate = VeryGoodFeatureTemplate();
        final featureDone = logger.progress('Generating ${featureName.pascalCase} feature');
        final featureGenerator = await MasonGenerator.fromBundle(veryGoodFeatureBundle);
        var vars = <String, dynamic>{
          'name': featureName,
          'useDio': client == 'dio',
          'package_name': packageName,
        };
        final cwd = Directory(p.join(Directory.current.path, featureTemplate.path));
        await featureGenerator.generate(DirectoryGeneratorTarget(cwd),
            fileConflictResolution: FileConflictResolution.overwrite, vars: vars);
        await featureGenerator.hooks.postGen(
          vars: vars,
          onVarsChanged: (v) => vars = v,
          workingDirectory: p.join(cwd.path, featureName),
        );
        featureDone('Generated ${featureName.pascalCase} feature in ${featureTemplate.path}');
        await featureTemplate.onGenerateComplete(logger, Directory.current);

        //generating api classes
        final apiTemplate = ApiTemplate();
        final apiDone = logger.progress('Generating ${featureName.pascalCase}Api class');
        final apiGenerator = await MasonGenerator.fromBundle(apiBundle);
        var apiVars = <String, dynamic>{
          'name': featureName,
          'useDio': client == 'dio',
        };
        final apiCwd = Directory(p.join(Directory.current.path, apiTemplate.path));
        await apiGenerator.generate(DirectoryGeneratorTarget(apiCwd),
            fileConflictResolution: FileConflictResolution.overwrite, vars: apiVars);
        await apiGenerator.hooks.postGen(
          vars: apiVars,
          onVarsChanged: (v) => apiVars = v,
          workingDirectory: apiCwd.path,
        );
        apiDone('Generated ${featureName.pascalCase}Api class in ${apiCwd.path}');

        // generating repository classes

        final repositoryTemplate = RepositoryTemplate();
        final repositoryDone = logger.progress('Generating ${featureName.pascalCase}Repository class');
        final repositoryGenerator = await MasonGenerator.fromBundle(repositoryBundle);
        var repoVars = <String, dynamic>{
          'name': featureName,
        };
        final repoCwd = Directory(p.join(Directory.current.path, repositoryTemplate.path));
        await repositoryGenerator.generate(DirectoryGeneratorTarget(repoCwd),
            fileConflictResolution: FileConflictResolution.overwrite, vars: repoVars);
        await repositoryGenerator.hooks.postGen(
          vars: vars,
          onVarsChanged: (v) => repoVars = v,
          workingDirectory: repoCwd.path,
        );
        repositoryDone('Generated ${featureName.pascalCase}Repository class in ${repoCwd.path}');

        await repositoryTemplate.onGenerateComplete(logger, Directory.current);
      } else {
        throw UsageException('please provide feature name', usage);
      }
      return ExitCode.success.code;
    }
  }
}
