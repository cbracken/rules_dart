library hello;

import 'goodbye.dart' deferred as byeLib;

String sayHello(String name) => 'Hello, $name!';

Future<String> sayGoodbyeDeferred(String name) async {
  await byeLib.loadLibrary();
  return byeLib.sayGoodbye(name);
}
