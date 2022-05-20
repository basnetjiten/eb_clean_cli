# eb_clean

#### The complete Command Line Interface for creating clean architecture on flutter inspired by very_good_cli

### installation
```shell
   dart pub global activate eb_clean_cli
```



```shell
eb_clean --help

EB Clean Command Line Interface

Usage: eb_clean <command> [arguments]

Global options:
-h, --help       Print this usage information.
    --version    Print the current version.

Run "eb_clean help <command>" for more information about a command.
```

### Available commands

- ### create

```shell
Creates a new flutter project.

Usage: eb_clean create <output directory>
-h, --help                     Print this usage information.
-d, --desc                     The description for this new project
                               (defaults to "A Clean Architecture Project Template for Flutter.")
    --org                      The package name for this new project. Default is com.ebpearls
                               (defaults to "com.ebpearls")
-t, --template                 The template used to generate this new project.

          [clean] (default)    Creates a new clean project
          [very_good]          Creates new project inspired from very_good_cli
```

- ### generate

```shell
Generates features and specific classes
Usage: eb_clean generate <subcommand>
-h, --help    Print this usage information.

Available subcommands:
  api          eb_clean generate api --client <dio,graphql> <name>
               creates api class in api packages
  bloc         eb_clean generate bloc --feature <feature-name> <name>
               creates bloc class in specific feature
  cubit        eb_clean generate cubit --feature <feature-name> <name>
               creates cubit class in specific feature
  feature      eb_clean generate feature --client <dio,graphql> <name>
               generates full feature
  page         eb_clean generate page --feature <feature-name> --type <stateless,stateful> <name>
               creates page  in specific feature
  repository   eb_clean generate repository <name>
               creates repository class in repository packages
  source       eb_clean generate source --client <dio,graphql> <name>
               generates source class in specific feature

Run "eb_clean help" to see global options.
```

- ### packages

```shell
runs packages commands

Usage: eb_clean packages <subcommand>
-h, --help    Print this usage information.

Available subcommands:
  build_runner   eb_clean packages build_runner
                 Runs flutter pub run build_runner build --delete-conflicting-outputs in current directory
  get            eb_clean packages get
                 runs flutter pub get in current directory

Run "eb_clean help" to see global options.
```