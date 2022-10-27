import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart';

part 'dart_get_up_to_speed.freezed.dart';

// dart pub run build_runner watch --delete-conflicting-outputs
void main(List<String> arguments) {
  part13();
}

Future<void> part13() async {
  part12()
      .map((message) => message.toUpperCase())
      .where((message) => message.length > 5)
      .listen((event) {
    print(event);
  });
}

Stream<String> part12() async* {
  yield 'func1';
  await Future.delayed(Duration(seconds: 1));
  yield 'function2';
  await Future.delayed(Duration(seconds: 1));
  yield 'function3';
  await Future.delayed(Duration(seconds: 1));
}

Future<void> part11() async {
  final myPeriodicStream = Stream.periodic(Duration(seconds: 1));
  final subscription = myPeriodicStream.listen((event) {
    print('a second has passed');
  });
  await Future.delayed(Duration(seconds: 4));
  subscription.cancel();
}

Future<void> part10() async {
  try {
    final result = await Client()
        .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    print(result.body);
  } catch (e) {
    print('error');
  }
  Client()
      .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'))
      .then((response) => print(response.body))
      .catchError((e) => print('error'));
}

void part9() {
  try {
    final myInt = int.parse('source');
    throw MyCustomException();
  } on FormatException catch (e) {
    print(e);
  } finally {
    print('error');
  }
}

class MyCustomError extends Error {}

class MyCustomException implements Exception {}

void part8() {
  final person1 = Person2(name: "test");
  final person2Updated = person1.copyWith(name: "test2");
  const resultSuccess = Result.success(100);
  print(
    resultSuccess.when(
      loading: () {
        return 'wait';
      },
      success: (value) {
        return value;
      },
      failure: (message) {
        return message;
      },
    ),
  );
  print(
    resultSuccess.maybeWhen(
      orElse: () => '',
      failure: (message) {
        return message;
      },
    ),
  );
  print(
    resultSuccess.map(
      loading: (loadingCase) {
        return 'wait';
      },
      success: (successCase) {
        return successCase.value;
      },
      failure: (failureCase) {
        return failureCase.errorMessage;
      },
    ),
  );
  print(
    resultSuccess.maybeMap(
      orElse: () => '',
      loading: (loadingCase) {
        return 'wait';
      },
    ),
  );
}

@freezed
class Person2 with _$Person2 {
  const Person2._();
  const factory Person2({
    required String name,
  }) = _Person2;
}

@freezed
class Result with _$Result {
  const Result._();
  const factory Result.loading() = _Loading;
  const factory Result.success(int value) = _Success;
  const factory Result.failure(String errorMessage) = _Failure;
}

void part7() {
  final x = 'hello'.duplicated;
  print(x);
  final person1 = Person(age: 15);
  // final person1Updated = Person(
  //   age: person1.age+1,
  //   name: person1.name,
  // )
  final person1Updated = person1.copyWith(age: person1.age + 1);
}

@immutable
class Person {
  const Person({
    required this.age,
  });
  factory Person.fromJson(Map<String, Object?> json) {
    return Person(
      age: json['age'] as int,
    );
  }
  final int age;
  Person copyWith({
    int? age,
  }) {
    return Person(
      age: age!,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'age': age,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Person && other.age == age;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      age,
    );
  }
}

extension StringDuplication on String {
  String get duplicated {
    return this + this;
  }

  String duplicate() {
    return 'test';
  }
}

mixin ElevatedClient {
  void sendElevatedMessage(String text) {
    print('Sending a message with an elevated importance: $text');
  }
}

class Admin2 with ElevatedClient {}

class ChatBot with ElevatedClient {}

abstract class DataReader<T> {
  T readData();
}

class IntegerDataReader implements DataReader<int> {
  @override
  int readData() {
    print('performing logic');
    return 12345;
  }
}

void part6() {
  OtherClass as RegularClass;
}

class RegularClass {
  final int myField;
  RegularClass(this.myField);

  int get publicProperty => 123;
  String getSomeString() {
    return 'hello';
  }
}

class OtherClass implements RegularClass {
  @override
  String getSomeString() {
    // TODO: implement getSomeString
    throw UnimplementedError();
  }

  @override
  // TODO: implement myField
  int get myField => throw UnimplementedError();

  @override
  // TODO: implement publicProperty
  int get publicProperty => throw UnimplementedError();
}

abstract class User3 {
  final test;
  User3(this.test);

  void method();
  void method1() {
    print(test);
  }
}

class Admin1 extends User3 {
  Admin1({
    required String test,
  }) : super(test);
  @override
  void method() {
    print(true);
  }
}

void part5() {
  final admin = Admin(
    firstName: 'John',
    lastName: 'Doe',
    specialAdminField: 123,
  );
  final user = admin as User2;
  print(user.fullName);
  print(user is! Admin);
  if (user is Admin) {
    user.specialAdminField;
  }
  final user1 = User2.admin(true);
}

class User2 {
  final String _firstName;
  final String _lastName;

  User2(this._firstName, this._lastName);

  factory User2.admin(bool admin) {
    if (admin) {
      return Admin(specialAdminField: 123, firstName: 'a', lastName: 'b');
    } else {
      return User2('c', 'd');
    }
  }

  String get fullName => '$_firstName $_lastName';

  @mustCallSuper
  void signOut() {
    print('sign out');
  }
}

class Admin extends User2 {
  final double specialAdminField;
  Admin({
    required this.specialAdminField,
    required String firstName,
    required String lastName,
  }) : super(firstName, lastName);

  @override
  String get fullName => 'admin:${super.fullName}';

  @override
  void signOut() {
    print('Performing admin specific sign out steps');
    super.signOut();
  }
}

void part4() {
  final user = User1(
    firstName: 'john',
    lastName: 'doe',
    email: 'test@email.com',
  );
  user.fullName;
  user.firstName;
}

class User1 {
  final String firstName;
  final String lastName;
  late String _email;

  User1({
    required this.firstName,
    required this.lastName,
    required String email,
  }) {
    this.email = email;
  }
  // method should perform actual work
  String getFullName() => '$firstName $lastName';
  // properties
  String get fullName => '$firstName $lastName';

  String get email => _email ?? 'Email not present';

  set email(String value) {
    if (value.contains('@')) {
      _email = value;
    } else {
      _email = '';
    }
  }

  void setEmail(String value) {
    if (value.contains('@')) {
      _email = value;
    } else {
      _email = '';
    }
  }
}

void part3() {
  final x = Example(1, 2);
  x._private;
}

class Example {
  int public;
  int _private;

  Example(this.public, this._private);

  Example.namedConstructor({
    required this.public,
    required int privateParameter,
  }) : _private = privateParameter;

  void myMethod() {
    _private;
  }
}

class NonInstantiable {
  NonInstantiable._();
}

void part2() {
  User myUser = User(
    firstName: 'John',
    lastName: 'Doe',
    photo: 'photo',
  );
}

class User {
  late String name;
  String photo;
  User({
    required String firstName,
    required String lastName,
    required this.photo,
  }) {
    name = '$firstName $lastName';
  }

  // User({
  //   required String firstName,
  //   required String lastName,
  //   required this.photo,
  // }) : name = '$firstName $lastName';

  bool hasLongName() {
    return name.length > 10;
  }
}

// Lesson 1
void part1() {
  int plusFive(int x) {
    return x + 5;
  }

  final twicePlusFive = twice(plusFive);
  // final twicePlusFive = twice((x) {
  //   return x + 5;
  // });
  // final twicePlusFive = twice((x)=>x+5);

  final result = twicePlusFive(3);
  print(result);

  List<int> myList = [1, 2, 3];
  final firstElement = myList[0];
  final myList2 = [1, 2, 3];
  Map<String, dynamic> myMap = {'name': 'John doe'};
  final name = myMap['name'];

  final names = ['john', 'jane'];
  names.map((e) => null);
  // map return iterable which cant access value by index
  final nameLengths = names.map((name) => name.length).toList();
  final namesFiltered = names.where((name) => name.length < 4).toList();
  print(nameLengths);

  namesFiltered.forEach((element) {
    print(element);
  });

  namesFiltered.forEach(print);

  bool isSignedIn = true;
  <String>[
    'This is a fake content',
    if (isSignedIn) 'Sign Out' else 'Sign In',
  ];

  final x = <String>[
    for (int i = 0; i < 5; i++) i.toString(),
    for (final number in [1, 2, 3]) number.toString(),
  ];
}

void positionalParam(int x, String greeting) {}
void optionalParam(int x, [String? greeting]) {}

int Function(int) twice(int Function(int) f) {
  return (int x) {
    return f(f(x));
  };
}

// typedef IntTransformer = int Function(int);
// IntTransformer twice(int Function(int) f) {
//   return (int x) {
//     return f(f(x));
//   };
// }

