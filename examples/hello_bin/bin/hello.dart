import 'package:examples.hello_lib/hello.dart';

main(List<String> args) {
  var greeting = sayHello("world");
  print(greeting);
  print("${args.length} arguments: ${args}");
}
