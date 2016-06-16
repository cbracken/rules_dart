import 'dart:io';
import 'package:examples.goodbye_lib/goodbye.dart';

main() async {
  var runfilesDir = Platform.environment['RUNFILES'];
  var scriptPath = [runfilesDir, 'examples', 'dart', 'hello_bin', 'hello_bin']
      .join(Platform.pathSeparator);

  print('Script runfiles: $runfilesDir');
  print('Running: $scriptPath...');
  var p = await Process.run(scriptPath, []);
  print('----------');
  stdout.write(p.stdout);
  print('----------');
  print(sayGoodbye('world'));
}
