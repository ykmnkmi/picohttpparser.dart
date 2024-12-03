import 'package:logging/logging.dart';
import 'package:native_assets_cli/native_assets_cli.dart';
import 'package:native_toolchain_c/native_toolchain_c.dart';

Future<void> main(List<String> arguments) async {
  await build(arguments, builder);
}

Future<void> builder(BuildConfig config, BuildOutputBuilder output) async {
  var packageName = config.packageName;

  var cBuilder = CBuilder.library(
      name: packageName,
      assetName: '$packageName.dart',
      sources: <String>['src/$packageName.c']);

  await cBuilder.run(
    config: config,
    output: output,
    logger: Logger('')
      ..level = Level.ALL
      ..onRecord.listen(onRecord),
  );
}

void onRecord(LogRecord record) {
  // ignore: avoid_print
  print(record.message);
}
