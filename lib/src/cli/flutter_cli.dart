/*
 * Copyright (c) 2022.
 * Author: Kishor Mainali
 * Company: EB Pearls
 *
 */

part of 'cli.dart';

/// Thrown when `flutter packages get` or `flutter pub get`
/// is executed without a `pubspec.yaml`.
class PubspecNotFound implements Exception {}

/// Flutter CLI
class FlutterCli {
  /// Determine whether flutter is installed.
  static Future<bool> installed() async {
    try {
      await _Cmd.run('flutter', ['--version']);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Install flutter dependencies (`flutter packages get`).
  static Future<void> packagesGet({
    String cwd = '.',
    bool recursive = false,
    void Function([String?]) Function(String message)? progress,
  }) async {
    await _runCommand(
      cmd: (cwd) async {
        final installDone = progress?.call(
          'Running "flutter packages get" in $cwd',
        );

        try {
          await _verifyGitDependencies(cwd);
        } catch (_) {
          installDone?.call();
          rethrow;
        }

        try {
          await _Cmd.run(
            'flutter',
            ['packages', 'get'],
            workingDirectory: cwd,
          );
        } finally {
          installDone?.call();
        }
      },
      cwd: cwd,
      recursive: recursive,
    );
  }

  /// Install dart dependencies (`flutter pub get`).
  static Future<void> pubGet({
    String cwd = '.',
    bool recursive = false,
  }) async {
    await _runCommand(
      cmd: (cwd) => _Cmd.run(
        'flutter',
        ['pub', 'get'],
        workingDirectory: cwd,
      ),
      cwd: cwd,
      recursive: recursive,
    );
  }

  /// run generators (`flutter pub run build_runner build --delete-conflicting-outputs`).
  static Future<void> runBuildRunner({
    String cwd = '.',
    bool recursive = false,
  }) async {
    await _runCommand(
      cmd: (cwd) => _Cmd.run(
        'flutter',
        ['pub', 'run', 'build_runner', 'build', '--delete-conflicting-outputs'],
        workingDirectory: cwd,
      ),
      cwd: cwd,
      recursive: recursive,
    );
  }

  /// generate localized strings (`flutter pub global run intl_utils:generate`).
  static Future<void> runIntlUtils({
    String cwd = '.',
    bool recursive = false,
    required Logger logger,
  }) async {
    final check = logger.progress('Checking intl_utils');
    final res = await _Cmd.run('flutter', ['pub', 'global', 'list'], workingDirectory: cwd);
    if (res.stdout.toString().contains('intl_utils')) {
      check('intl_utils is already activated');
      _generate(logger);
    } else {
      check('intl_utils not yet activated.');
      final activate = logger.progress('Activating intl_utils');
      await _Cmd.run('flutter', ['pub', 'global', 'activate', 'intl_utils']);
      activate('Activated intl_utils');
      _generate(logger);
    }
  }

  static Future<void> removeMainFile(String path) async {
    final mainFile = Directory(p.join(path, 'lib/'));
    final testFile = Directory(p.join(path, 'test/'));
    await _Cmd.run('rm', ['-rf', 'main.dart'], workingDirectory: mainFile.path);
    await _Cmd.run('rm', ['-rf', 'widget_test.dart'], workingDirectory: testFile.path);
  }

  /// Ensures all git dependencies are reachable for the pubspec
  /// located in the [cwd].
  ///
  /// If any git dependencies are unreachable,
  /// an [UnreachableGitDependency] is thrown.
  static Future<void> _verifyGitDependencies(String cwd) async {
    final pubspec = Pubspec.parse(
      await File(p.join(cwd, 'pubspec.yaml')).readAsString(),
    );

    final dependencies = pubspec.dependencies;
    final devDependencies = pubspec.devDependencies;
    final dependencyOverrides = pubspec.dependencyOverrides;
    final gitDependencies = [...dependencies.entries, ...devDependencies.entries, ...dependencyOverrides.entries]
        .where((entry) => entry.value is GitDependency)
        .map((entry) => entry.value)
        .cast<GitDependency>()
        .toList();

    await Future.wait(
      gitDependencies.map((dependency) => Git.reachable(dependency.url)),
    );
  }

  static bool isFlutterProject() {
    final currentDirectory = Directory.current;
    final pubspecFile = File(p.join(currentDirectory.absolute.path, 'pubspec.yaml'));
    return pubspecFile.existsSync();
  }

  static bool isVeryGoodProject() {
    if (isFlutterProject()) {
      final veryGood = File(p.join(Directory.current.absolute.path, 'packages/api', 'pubspec.yaml'));
      return veryGood.existsSync();
    } else {
      return false;
    }
  }

  /// Run a command on directories with a `pubspec.yaml`.
  static Future<List<T>> _runCommand<T>({
    required Future<T> Function(String cwd) cmd,
    required String cwd,
    required bool recursive,
  }) async {
    if (!recursive) {
      final pubspec = File(p.join(cwd, 'pubspec.yaml'));
      if (!pubspec.existsSync()) throw PubspecNotFound();

      return [await cmd(cwd)];
    }

    final processes = _Cmd.runWhere<T>(
      run: (entity) => cmd(entity.parent.path),
      where: _isPubspec,
      cwd: cwd,
    );

    if (processes.isEmpty) throw PubspecNotFound();

    final results = <T>[];
    for (final process in processes) {
      results.add(await process);
    }
    return results;
  }

  static void _generate(Logger logger) async {
    final generate = logger.progress('Running ${lightGreen.wrap('flutter pub global run intl_utils:generate')}');
    _Cmd.run(
      'flutter',
      ['pub', 'global', 'run', 'intl_utils:generate'],
      workingDirectory: '.',
    );
    generate('Successfully generated localized strings');
  }

  static copyEnvs(Logger logger, String path) async {
    final envCopy = logger.progress('Generating .env files for development, staging and production');
    await _Cmd.run('cp', ['.env.example', '.env-production'], workingDirectory: path);
    await _Cmd.run('cp', ['.env.example', '.env-development'], workingDirectory: path);
    await _Cmd.run('cp', ['.env.example', '.env-staging'], workingDirectory: path);
    envCopy('Generated .env files for development, staging and production');
  }
}
