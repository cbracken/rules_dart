import 'dart:html';
import 'package:examples.web_app/hello.dart';
import 'util.dart';
import 'generated.dart';

void main() {
  print(sayHello('Julio'));
  print(sayGoodbyeDeferred('Julio'));
  print(generatedFunc());
  print(add(3, 2));
  querySelector('#output').text = 'Your Dart app is running.';
}
