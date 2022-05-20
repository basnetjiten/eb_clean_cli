/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 */
import 'package:args/command_runner.dart';
import 'package:eb_clean_cli/src/cli/cli.dart';
import 'package:eb_clean_cli/src/commands/generate/templates/page/page_template.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';
import 'package:universal_io/io.dart';

class PageCommand extends Command<int> {
  PageCommand(this.logger) {
    argParser
      ..addOption(
        'feature',
        abbr: 'f',
        help: 'feature name to create page',
        mandatory: true,
      )
      ..addOption(
        'type',
        abbr: 't',
        help: 'type of page',
        defaultsTo: 'stateless',
        allowed: ['stateless', 'stateful'],
      );
  }

  final Logger logger;

  @override
  String get description => 'creates page  in specific feature';

  @override
  String get name => 'page';

  @override
  String get invocation => 'eb_clean generate page --feature <feature-name> --type <stateless,stateful> <name>';

  @override
  String get summary => '$invocation\n$description';

  @override
  Future<int> run() async {
    if (argResults!['feature'] == null) {
      throw UsageException('feature is required', usage);
    } else {
      final type = argResults!['type'] as String? ?? 'stateless';
      final args = argResults?.rest;
      if (args != null && args.isNotEmpty) {
        final featureName = argResults!['feature'] as String;
        String template = 'clean';
        final pageName = args.first;
        final pageTemplate = PageTemplate();
        String path = '${pageTemplate.path}/$featureName/presentation/pages/';
        if (FlutterCli.isVeryGoodProject()) {
          path = '${pageTemplate.path}/$featureName/view/';
          template = 'very_good';
        }
        final pageDone = logger.progress('Generating ${pageName.pascalCase}Page class');
        final pageGenerator = await MasonGenerator.fromBundle(pageTemplate.bundle);
        var vars = <String, dynamic>{
          'name': pageName,
          'state': type == 'stateful',
          'template': template,
          'feature': featureName,
        };
        final cwd = Directory(p.join(Directory.current.path, path));
        await pageGenerator.generate(DirectoryGeneratorTarget(cwd),
            fileConflictResolution: FileConflictResolution.overwrite, vars: vars);
        await pageGenerator.hooks.postGen(
          vars: vars,
          onVarsChanged: (v) => vars = v,
          workingDirectory: p.join(Directory.current.path, pageTemplate.path, featureName),
        );
        pageDone('Generated ${pageName.pascalCase}Page class in ${cwd.path}');
      } else {
        throw UsageException('please provide bloc name', usage);
      }
    }

    return ExitCode.success.code;
  }
}
