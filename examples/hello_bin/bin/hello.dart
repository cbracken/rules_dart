import 'package:examples.hello_lib/hello.dart';
import 'package:examples.goodbye_lib/goodbye.dart';

main(List<String> args) {
  print(sayHello("world"));
  print("${args.length} arguments: ${args}");
  print(sayGoodbye("world"));
}
