String uidGenerator(String email, String type, DateTime now) {
  final uid = "$type-$email-${now.microsecondsSinceEpoch.toString()}";
  return uid;
}
