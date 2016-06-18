import 'package:examples.proto_lib/device.pb.dart';
import 'package:examples.proto_lib/person.pb.dart';
import 'package:examples.proto_bin/review.pb.dart';

String format(Review review) {
  var date = new DateTime.fromMillisecondsSinceEpoch(review.date);

  var buf = new StringBuffer();
  buf.writeln('Review of ${review.device.brand} ${review.device.model}');
  buf.writeln('by ${review.person.firstname} ${review.person.lastname}, $date');
  buf.writeln('\n${review.text}');
  return buf.toString();
}

Review fetchReview() {
  var fred = new Person()
    ..firstname = 'Fred'
    ..lastname = 'Fhqwhgads';
  var motoX = new Device()
    ..brand = 'Motorola'
    ..model = 'Moto X';
  var review = new Review()
    ..person = fred
    ..device = motoX
    ..date = new DateTime(2016, 01, 31).millisecondsSinceEpoch
    ..text = 'Hello, proto!';
  return review;
}

main() {
  var review = fetchReview();
  var displayText = format(review);
  print(displayText);
}
