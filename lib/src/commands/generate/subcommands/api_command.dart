/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 */
import 'package:args/command_runner.dart';
import 'package:eb_clean_cli/src/cli/cli.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';
import 'package:universal_io/io.dart';

import '../templates/very_good/api/api.dart';

class ApiCommand extends Command<int> {
  ApiCommand(this.logger) {
    argParser.addOption(
      'client',
      abbr: 'c',
      help: 'uses Dio as api client',
      allowed: ['dio', 'graphql'],
      defaultsTo: 'graphql',
    );
  }

  final Logger logger;

  @override
  String get description => 'creates api class in api packages';

  @override
  String get name => 'api';

  @override
  String get invocation => 'eb_clean generate api --client <dio,graphql> <name>';

  @override
  String get summary => '$invocation\n$description';

  @override
  Future<int> run() async {
    if (FlutterCli.isVeryGoodProject()) {
      final args = argResults?.rest;
      if (args != null && args.isNotEmpty) {
        final client = argResults!['client'] as String? ?? 'graphql';
        final apiName = args.first;
        final apiTemplate = ApiTemplate();
        final apiDone = logger.progress('Generating ${apiName.pascalCase}Api class');
        final apiGenerator = await MasonGenerator.fromBundle(apiBundle);
        var vars = <String, dynamic>{
          'name': apiName,
          'useDio': client == 'dio',
        };
        final cwd = Directory(p.join(Directory.current.path, apiTemplate.path));
        await apiGenerator.generate(DirectoryGeneratorTarget(cwd), fileConflictResolution: FileConflictResolution.overwrite, vars: vars);
        await apiGenerator.hooks.postGen(
          vars: vars,
          onVarsChanged: (v) => vars = v,
          workingDirectory: cwd.path,
        );
        apiDone('Generated ${apiName.pascalCase}Api class in ${cwd.path}');
      } else {
        throw UsageException('please provide api name', usage);
      }
      return ExitCode.success.code;
    } else {
      throw UsageException('api command is available only in project created using very_good template', usage);
    }
  }
}
