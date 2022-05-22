/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 */
import 'package:args/command_runner.dart';
import 'package:eb_clean_cli/src/cli/cli.dart';
import '../templates/clean/repository/clean_repository_bundle.dart';
import '../templates/clean/repository/clean_repository_template.dart';
import '../templates/very_good/repository/repository.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';
import 'package:universal_io/io.dart';

class RepositoryCommand extends Command<int> {
  RepositoryCommand(this.logger) {
    argParser.addOption('feature', abbr: 'f', help: 'feature name to create repository');
  }

  final Logger logger;

  @override
  String get description => 'creates repository class in repository packages';

  @override
  String get name => 'repository';

  @override
  String get invocation => 'eb_clean generate repository <name>';

  @override
  String get summary => '$invocation\n$description';

  @override
  Future<int> run() async {
    final packageName = Directory.current.path.split('/').last;
    if (FlutterCli.isVeryGoodProject()) {
      final args = argResults?.rest;
      if (args != null && args.isNotEmpty) {
        final repositoryName = args.first;
        final repositoryTemplate = RepositoryTemplate();
        final repositoryDone = logger.progress('Generating ${repositoryName.pascalCase}Repository class');
        final repositoryGenerator = await MasonGenerator.fromBundle(repositoryBundle);
        var vars = <String, dynamic>{
          'name': repositoryName,
        };
        final cwd = Directory(p.join(Directory.current.path, repositoryTemplate.path));
        await repositoryGenerator.generate(DirectoryGeneratorTarget(cwd), fileConflictResolution: FileConflictResolution.overwrite, vars: vars);
        await repositoryGenerator.hooks.postGen(
          vars: vars,
          onVarsChanged: (v) => vars = v,
          workingDirectory: cwd.path,
        );
        repositoryDone('Generated ${repositoryName.pascalCase}Repository class in ${repositoryTemplate.path}');
        await repositoryTemplate.onGenerateComplete(logger, Directory(p.join(Directory.current.path, 'packages/repositories/')), false);
      } else {
        throw UsageException('please provide repository name', usage);
      }
      return ExitCode.success.code;
    } else {
      final args = argResults?.rest;
      if (args != null && args.isNotEmpty) {
        final repositoryName = args.first;
        if (argResults!['feature'] == null) {
          throw UsageException('please provide feature to create repository in', usage);
        } else {
          final featureName = argResults!['feature'] as String;
          final repositoryTemplate = CleanRepositoryTemplate();
          final repositoryDone = logger.progress('Generating ${repositoryName.pascalCase}Repository\'s abstract and implementation class');
          final repositoryGenerator = await MasonGenerator.fromBundle(cleanRepositoryBundle);
          var vars = <String, dynamic>{
            'name': repositoryName,
            'package_name': packageName,
          };
          final cwd = Directory(p.join(Directory.current.path, repositoryTemplate.path, '$featureName/'));
          await repositoryGenerator.generate(
            DirectoryGeneratorTarget(cwd),
            fileConflictResolution: FileConflictResolution.overwrite,
            vars: vars,
          );
          repositoryDone('Generated ${repositoryName.pascalCase}Repository class in ${cwd.absolute.path}');
          await repositoryTemplate.onGenerateComplete(logger, Directory.current);
        }
      } else {
        throw UsageException('please provide repository name', usage);
      }
      return ExitCode.success.code;
    }
  }
}
