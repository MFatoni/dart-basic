library first_library;

import 'dart:math' as math;

part 'second_library.dart';
part 'third_library.dart';

const int _privateTopLevel = 15;
const int publicTopLevel = 12;

void _privateTopLevelFunction() {}
void publicTopLevelFunction() {}

class A {
  final int _privateField = 5;
  void _privateMethod() {}

  final int publicField = 10;
  void publicMethod() {}
}

void randomFunction() {
  var a = A();
  a._privateField;
  a._privateMethod();
}
