```
command
 dart run
command with param
 dart run console_full_project 1 2

devtools
 dart run --observe --pause-isolates-on-start

structure
 dart packages - .dart_tools, .package, pubspec
 vscode run configuration - .vscode
 cmd apps - bin
 libraries - lib
 dart testing - test
 dart linting - analysis_options

dart packages - main component of the dart ecosystem
 application package - a package that wont be uploaded to pub.dev
 library package - a package that will be uploaded to pub.dev
manage by pub package manager
dependency is written on pubspec

publishing to pub.dev require implementation on lib/src folder

dart linting
 static check relies on lint rule
```
![LINT](assets/lint.png?raw=true "LINT")
```
dart test
 dart test

-programming phase

development phase
 fast & stable development workflow
 quick analyzer & reformatting tools
 fast compilation & recompilation
 code optimization rechniques
 intuitive debugging tools
  aiding the dev process
  providing useful development tools
  hot reload
  
production phase
 focused primaryly on the user experiece
 fast startup time
 userfulness, reliability, stability
 good-lookingnes, interactiviy
 testing in real world scenario
  removing developer features
  providing fast startup builds
  optimizing the app

source - raw state - running state - running machine

dart vm - collection of componenets aiding toward natively executing dart code
 the runtime system
 development experiece components
  debugging
  hot reload
 jit & aot compilation pipelines

dart vm - provide execution env for dart programming, native machine code inside production phase also run in a stripped version of a dart vm without debugging support and hot reload. anything running in vm is isolated.
 isolated dart universe
  dev code / native code
   heap - memory - garbage collector
   helper mutator thread - each isolate has a single mutator thread which executes the dart code.
   helper thread - multiple helper thread handle vm internal task

dart vm can execute dart apps in 2 ways
 from source using jit / aot
 from snapshot (jit, aot, kernel)

the differences lies on when and how vm convert dart source code to executable code. 

-running source using jit

dart vm doesnt have the ability to execute raw dart code instead it expect some kernel binaries also called dll files which contain serialized kernel abstract syntax tree as known as kernel ast
the dart kernel is a small high-level intermediary language derived from dart. therefore kernel ast actually based on this intermediary language
the task of translating dart source code into kernel ast is handled by a dart package called the common front end (cfe). it is using euclidean algorithm to generated abstract syntax tree.

dart compile kernel .\bin\console_full_project.dart

code -> cfe -> kernel binary -> vm 

once the kernel binary is loaded into vm it is being parsed to create object representing various program entities like classes and libraries. It parses basic information of these entities. each entity keeps a pointer back to the kernel binary so that it can be accessed if needed later. jit fully deserialized when the runtime needed. only the signatures are deserialized at the first stage. entities lies inside the vm heap. when function is compiled it happen sub optimally (the compiler goes and retrieves the function body from the kernel binary converts it into intermediate language and then the intermediate language is lowered directly without optimization into pure machine code), the next time the function called it will use optimized code (the optimized compiler based on the information gathered from the sub-optimal run proceed to optimized translate the unoptimized intermediate language through a sequence of classical dart specific optimizations like inlining, range analysis, type propagation etc) and it will lowered into machine code and run by the vm.

-running source using aot

relate when compile in exe. 

jit compilation not possible -> aot compilation

jit
 slow startup time
 peak performance
 compiles code at runtime
 suite of debugging tools
 hot reload
 designed for development phase
 command: dart run 
 compile/run time: 1s 124ms/670ms

aot
 fast startup times
 consistent performance
 compiles code before runtime
 no debugging tools
 testing real-world performance
 designed for production phase
 command: dart compile exe
 compile/run time: 3s 125ms / 27ms

iot compiler must have access to executable code for each and every function that could be invokoed during application execeution. aot compilation does global static analysis called type flow analyses or tfa to determine which part of the app are reachable from the set of entry points based on this analysis it will remove unreachable methods, the code and the virtualized method calls. the virtualization is compiler optimization that replaces indirect or virtual function calls with direct calls. the analyses rely on how correct and optimized of the code meanwhile jit rely on the side of performance because it can always optimize deoptimize and re optimized the code

aot compilation tool chain is based on jit

```
![JIT AOT](assets/jit_aot_scheme.png?raw=true "JIT AOT")

```
-dart snapshot

dart snapshot contains an efficeient representation of all those entities allocated on the dart vm heap entities which are needed to start execution process. this heap is traversed and just before calling the main function all objects from inside of it are serializezd into a simple file called snapshot. snapshot is optimized for startup times so that instead of parsing the same dart source all over again while gradually creating vm data entities all this specific process is contained into the snapshot file. vm can immediately deserialize and run.

 jit snapshot
  include all the parse classes and compile code. it doesnt need to parse or compile entities.
   compare stock jit and jit snapshot
    time (dart run)
    time (dart compile jit-snapshot bin/console_full_project.dart)
  standard aot
   dart compile exe
   standalone platform-specific executable file with dart runtime
   output an aout snaphot and combine it with a dart vm runtime
   dart compile exe bin/console_full_project.dart
  aot snapshot
   dart compile aot-snapshot
   standalone platfom-specific executable file with no dart runtime
   outputs a plain aot-snapshot, can be run with dartaotruntime
   dart compile aot-snapshot bin/console_full_project.dart
   dartaotruntime bin/console_full_project.aot
 aot snapshot
  no training run
  it wont run the app before creating the snapshot 
  compiling the entire program and get the snapshot
 kernel snapshot
  contain binary form of the kernel abstract syntax tree. only contain code that has been parsed into the intermediary format.
   no parsed classes, function
   no architecture specific code
   portable around all architecture
   dart vm will need to compile it from scratch

-sound null safety

sound
 if type system determines that something is not null, then that thing can never be null

null safety 
 not having null values where we dont expect them
 throws no null refference errores, if we are using null safety with no explicitly unsafe features
 smaller binaries, faster execution

it is unsafe to have one or multiple null values flowing untracked in an application
errores related to the safety of null should be shown at edit-time, and not at run time, where it may be too late

null safety changes
 type in your code are non-nullable by default = variables cant contain null, unless we say they can
 runtime null errores turn into edit-time analysis errors = fastest way to observe and fix the any issues
 null safety's goal is not to eliminate the null from the equation
  null will still exist in every dart program
  null highlights the absence of a value
  the issue is not null itself, but rather having null where we dont expect it
 null safety's goal is to have control into where, how, and when null can flow through your program
 type are made nullable by postfixing them with the question mark (?)
 implicit downcast removed
 
    void main(List<String> args){
      Object obj = 'Pre Null Safe Dart';
      showString(obj);
    }

    void showString(String s){
      print(s.toUpperCase());
    }

    void main(List<String> args){
      Object? obj = 'Pre Null Safe Dart';
      showString(obj as String);
    }

    void showString(String s){
      print(s.toUpperCase());
    }
    
 you cant access the base type props or methods with its nullalbe type
 the only props available for nullable type are toString(), == & hasCode
 in null safety, an object of any type is of type object?
 the never type was added at the bottom of the type tree and can be used to interrupt the flow of an application, by throwing an exception
 non-void non-nullable function must always return the correct non-nullable type
 non-nullable top level variable & static fields must always be initialized when declared
 non-nullable class fields must be initialized before the constructor body
 non-nullable optional parameters must be initialized in the parameters list
 previous 4 changes can be ommited if we switch from a non-nullable type toa a nullable one
 in null safety, dart analyzer abality to scan te running flow on an application has been drastically enhanced
 a nullable type can be promoted to its non-nullable type in several ways e.g int?->int, String?->String, double?->double
  reachability analysis following return, break, throw paths
  type promotion on null checks
  explicitly by using the null assertion operator(!)
flow-based type promotions dont apply to fields from inside classes
flow analysis can now scan if a final variable has been initialized before use; as a result final types dont need to be initialized at declaration anymore
rhe late modifier lets you tel the analyzer that the variable is safe and will be 100% assigned to the right value before it's used
it also give you lazy initialized fields
named non-nullable paramters we dont want to be initialized with a default value can be set as being required => named mandatory
 void namedMandatory({required int a, required int b})()

-dart type system

before 
object
iterable - num
list | double - int
null

after 
object || null
iterable - num
list | double - int

    void main(List<String> arguments){
      double a = 5.0;
      double b = 4.0;
      print(a+b);

      double? c;
      double? d;
      print(c+d);

      double e = 5.0;
      double? f;

      intersection of functions available for both types
      print(a.toString());
      print(b.toString());
      print(a==a);
      print(b==b);
      print(a.hashCode);
      print(b.hashCode);

      other function are not available for double?
      print(a.floorToDouble());
      print(b.floorToDouble());
    }

after 
object?
object - null
iterable - num
list | double - int
never

    // User data class
    class User {
      final String email;
      final String password;
      const User({
        required this.email,
        required this.password,
      });
      @override
      String toString() => 'User {email: $email, password: $password}';
    }
    // Helper function for required field validation
    Never isRequired(String property) {
      throw ArgumentError('$property is required.');
    }
    void main() {
      String? email;
      String? password;
      // ...
      // Some code to get email and password
      // ...
      if (email == null || email.isEmpty) isRequired('email');
      if (password == null || password.isEmpty) isRequired('password');
      final user = User(email: email, password: password);
      // ...
      // Do something with the user data
      // ...
    }

what happens when a variable isnt initialized?

top level variable or static can be accessed anywhere

    int a=5;
    class A{
      static int b=10;
    }
    int? nullable;

    non nullable field must have a value before reaching constructor body

    int z;
    RandomClass({
      required this.z,
    }) : x = 5{
      print('Constructor body);
    }

optional paramater must also have a default value

    void optionalParam([int beta=25]){}

the value of non nullable local variable must only assign before it is used.

error showed if we dont return anything from non-void function.
throw ArgumentError(); returning a Never value.
flow analysis run to check the existance of return non-void function

dart enhanced control flow analysis
 reachability analysis
  type promotion
    bool isEmptyList(Object object){
      if(object is! List){
        return false;
      } else {
        return object.isEmpty;
        // return object as list
      }
    }
flow based type promotion doesnt apply to fields from inside classes

    class Coffee{
      String? _temperature;
      void heat(){_temperature='hot';}
      void chill(){_temperature='iced'}
      void checkTemp(){
        if(_temperature != null){
          print('ready to serve'+ _temperature!);
        }
      }
      String serve()=>_temperature!+ ' coffee';
      //static analysis cant prove that the field value doesnt change between the point so it is required to put !
    }

declaring final var and not initializing it would have ended up in an error (immutable) 

flow analysis can promote nullable to non nullable

    String makeCommand(String executable, [List<String>? arguments]){
      var result = executable;
      if(arguments != null){
        result += ' ' + arguments.join(' ');
        //result += ' ' + (arguments as List<String>).join(' ');
        flow analysis promote to corresponding data type
      }
      return result;
    }

null assertion operator

    class HttpResponse {
      final int code;
      final String? error;
      HttpResponse.ok() : code = 200, error = null;
      HttpResponse.notFound() : code = 404, error = 'Not found';

      @override
      String toString(){
        //if code == 200, then error is null
        if (code ==200) return 'ok';

        //otherwise error is not null and can tell the toUpperCase method
        return 'ERROR $code $(error!.toUpperCase())';
        return 'ERROR $code $((error as String).toUpperCase())';
      }
    }

late variable

    class Car {
      //int _speed; error
      //int? _speed;
      late int _speed;
      void accelerate(){
        _speed=50;
      }
      void brake(){
        _speed=0;
      }
      //int steer()=>_speed-=15; error
      //int steer()=> _speed = _speed!-15;
      int steer()=>_speed-=15;
    }

    void main(List<String> arguments){
      var car = Car();
      car.accelerate();
      car.steer();
    }

late can also use on field that also has an initializer

    int readThermometer = 25;

    class Weaather{
      late int temperature = readThermometer();
      //late final int temperature = readThermometer();
    }

    void main(List<String> arguments){
      var w = Weather();
      //w.temperature = 25;
      print(w.temperature+25);
    }

required named parameter
 positional mandatory
 
    void positionMandatory(int a, int b){}
    positionalMandatory(2,3)
    
  mandatory, order matters
  
 positional optional
 
    void positionalOptional(int? a, int? b){}
    positionalOptional(null,3);
    
  optional, order matters
  
 named mandatory
 
    namedMandatory(required int a, required int b){}
    namedMandatory(b:3,a:2);
  
  mandatory, order doesnt matter
  
 named optional
 
    namedOptional(int a=4, int b=10){}
    namedOptional(b:3,a:2);
  
  optional, order doesnt matter

null safety activate since dart sdk ^2.12.0
dart is oop
 mostly everything in dart is a class, and objects are instances of these clases
 1.2.0,'example',[1,2,3],test(), null are objects
 int a = 5; // int(value:5);
everything you place inside a dart variable is an object => an instance of a class
dart is a strongly typed language meaning that everything has atype
explicit type annotations are optional, dart is able to infer types
 var keyword @compile time, dynamic keyword @run time
 
   var a = 5;
   dynamic b = 5;
   print(b.runtimeType);
   
dart is a sound typed system, it cant never evaluate into an unknown state
variable cant contain null, unless you say they can

   int a; int? a;
   int? nullableButNotNull=2; int a = nullableButNotNull!;
   
dart is an ecosystem based on packages
dart packages can depend on another
dart packages use libraries to share code with another
libraries are stored inside the lib folder
file outside lib folder are not shared with other packages

-keyword

should avoid using dart reserved keyword as identifer
under some circumstances, we could use keyword with 1,2,3 as identifiers
 contextual keywords - have meaning only in specific places from inside the code
    try{
     var d = 2 ~/ 0;
     print(d);
    } on IntegerDivisionByZeroException catch(_){
     print('Exception: you divided by zero!');
    }

    class Car{
     final bool on;
     Car(this.on)
    }
 built in identifier - it cant be used as a class type, name or import prefixes

   import 'dart:math' as math;
   void main(List<String> arguments){
    print(math.sqrt(4));
   }

 async support - reserved as async topic

   future asyncMethod1() async{
    final yield = 2;
   }
   Stream asyncMethod2() async* {
    final await = 3;
   }
   Iterable asyncMethod3() sync* {
    final await = 4;
   }
   
the rest of the keyword are reserved and cant be used as identifier
```
![KEYWORD](assets/keyword.png?raw=true "KEYWORD")
```
-dart variable
top-level
 can declare a variable that is not linked to any class or object and that can be accessed from anywhere
static
instance
local

  dart_variables.dart
  //top-level variable
  int t=5;

  class A {
    //static variable
    static int s=12;

    //instance variable(field/property)
    double i=25;
  }
  void randomFunction(){
    //local variable
    int i=4;
  }
  void main(List<String> arguments){
    t=8;
  }
  another_file.dart
  import 'dart_variables.dart';
  void another_function(){
    t=15;
  }

String car = 'BMW';
variable type, variable name (identifer), assignment operator, value

dart store references to an object therefore the car variable is just a reference to a string value of bmw that is located on dart internal memory
if no assignment operation then dart will assign default value (null) so on nullable variables must be initalized before being accessed or used

top-level
can be left unassigned at declaration and will

    int t=5;
    int? nullableTopLevel;
    //int? nullableTopLevel = null;
    late int nonNullableTopLevel;
    //int nonNullableTopLevel-5;
    class A{
      //static variable
      //variable that can be accessed without having to instantiate an object from the class it was placed
      //we cant initialize a static variable in a constructor of a class
      //nullable can be assigned later
      static int s=12;
      static int? nullableStatic;
      //static int nonNullableStatic = 15;
      static late int nonNullableStatic;

      //instance variable
      //can be left unassigned and they will be assigned a value of null
      double i=25;
      double? nullableInstance;
      //double nonNullableInstance;
      late double nonNullableInstance;

      //A({
      //  required this.i,
      //  required this.nullableInstance,
      //  required this.nonNullableInstance,
      //});

      //initialization list
      //A({
      //  required this.i,,
      //}) : nullableInstance=4{}

      //initialization list
      //A({
      //  required this.i,,
      //}) : nonNullableInstance=4{}

      A({
        required this.i,,
      }) {
        nullableInstance=4;
        nonNullableInstance=30;
      }
    }
    void randomFunction(){
      //local variable
      var i=4;

      int? nullableLocal;
      int nonNullableLocal;

      nullableLocal=5;
      nonNullableLocal=5;
      print(nullableLocal.isEven);
      print(nonNullableLocal.isEven);
    }

    void main(List<String> arguments){
      nullableTopLevel=5;
      nonNullableTopLevel=10;
      print(nullableTopLevel!.isEven);
      print(nonNullableTopLevel.isEven);
      print(A.s);
      A.nullableStatic=12;
      A.nonNullableStatic=15;
      var alfa = A(i:10)..nullableInstance=20;
      print(alfa.nullableInstance);
      var beta = A(i:20)..nonNullableInstance=40;
      print(beta.nonNullableInstance);
    }
```
![VARIABLE](assets/variable.png?raw=true "VARIABLE")
```
if variable with late keyword assigned a value, the value will be initialized once it is used

    class WeatherStation{
      late in temperature=readTemperature();
      int readTemperature()=>25;
    }

    void main(List<String> arguments){
      //the temperature field is not initialized here
      var weatherStation = WeatherStation();

      //but rateher here, lazily when it is accessed for the first time
      print(weatherStation.temperature);
    }

var (compile time), dynamic (runtime)
var without value will be set to dynamic and the value become null
dynamic is type of nullable

dynamic - var - final - const

dynamic
can change variable type, variable can be reassigned to another value(the type or not)

var 
cant change variable type, variable can be reassigned to another value (the same type)

final
cant change variable type, variable cant be reassigned to another value
final will have a value known at runtime

const
cant change variable typem variable cant be reassigned to another value
const vars will have a value known at compilation

    final list4 = const[1,2,3];
    const lists =  [1,2,3];

    final alfa(A());
    alfa.a=10;
    print(alfa.a);

    class B{
      static const b=5;
    }

    class C {
      final List<int> list;
      const C({
        required this.list,
      })
    }

    var c1 = const C(list:[1,2,3]);
    var c2 = const C(list:[1,2,3]);

    print(c1.hashCode);
    print(c1.hashCode);

-built in type
num int double String bool List Set Map Runes Null Object Future Stream Iterable Never dynamic void

Numbers(num,int, double)
num 
int-double
methods from inside the num class are completely accessible to both int and double types
int and double are special enough to reimplement some of num's existing methods, by bringing some abstraction and extra functionalities to base num class
the num type, can host both int and double values, the operatores and methods inside will work at the same time on both int and double types.

string to num using .parse
num to string using .toString

~/ truncenate operator

String
   String s1='hello';
   String s2="h'ello";
   String s3='h\'ello';

   double temperature = 25.4;
   String celcius = 'celcius;
   String s4='there are $temperature degrees ${celcius.toUpperCase()}';

   String intro = "hello \n world";
   String intro2 = '''hello
   world''';

   String rawString = r'hello \n world';
   String unicodeExample = "\u{1F339}";

Lists 
ordered grup of object
    List<int> list=[1,2,3];
    List<A> listOfAObjects=[A(),A(),A()];

    class A{}

    List<num> listOfIntegersAndNumbers=[2,3.0,5];
    List<dynamic> listOfIntegersNumbersAndString=[2,3.0,5,"asd"];
    List<Object?> complexList=[2,3.0,5,"asd"];

    var integerValue = complexList[0] as int;

    List<int> a=[1,2,3];
    List<int?> b=[1,2,null];
    List<int>? c=[1,2,3];
    List<int?>? d=[1,2,null];

init list with specific length
    List<int> a = [];
    List<int> a = [];
    List<int> a = List.filled(3,3);
    List<int> a = List.empty(growable:true);
    List<int> a = List.generate(3,(index)=>index);

spread operator
    List<int> a =[1,2,3];
    List<int> b =[...a];

dot operator
. & ?.
    int a=5;
    print(a.isEven);

    int? a=null;
    print(a!.isEven);
    will be run when null
    print(a?.isEven);

cascade operator
.. & ?..
    List<int> list1 = [1,0,2];
    list1.sort();
    list1=slist1.reversed.toList();
    list1.addAll([5,3,4]);
    list1.sort();
    list1=list1.map((e)=>e+1).toList();
    print(list1);

    List<int> list2=[1,0,2];
    ..sort()
    ..reversed
    ..addAll([5,3,4])
    ..sort()
    ..map((e)=>e+1);
    print(list2);

    List<int> list2=(([1,0,2]..sort()).reversed.toList()
    ..addAll([5,3,4])
    ..sort())
    ..map((e)=>e+1).toList();
    print(list2);

  ... & ...? spread operator
    var a=[1,2,3];
    var b=null;
    var c=[...a,..?b];

    bool salesActive=true;
    var salesMenu=[
      'Offers1',
      'Offers2',
    ]

    List<String> menu = [
      'Home',
      'Store',
      'About',
      'Search',
      if(salesActive) for (var item in salesMenu) item,
    ]

    void main(List<String> arguments){
      List<int> list1=const[1,2,3];
      List<int> list2=const[1,2,3];
      print(list1.hashCode);
      print(list2.hashCode);
    }

sets
sets-collection containing unordered unique objects
list-collections containing ordered non-unique objects

    var list=[];
    list.add(1);
    list.add(1);

    var set = <int>{};
    set.add(1);
    set.add(1);

    var set1=Set();
    print(set1);
    Set<String> set2={'hey','wckd'};
    print(set2);

    var set3={1,2,3};
    print(set3);

    var set4=<int>{};

this is a set
    var set5={1,2,3};
this is a map
    var map5={}

maps 
object that associate with key and value

    var map1={};
    var map2={1:1,2:2};
    var map3=Map();

    map3['wckd']='yay';

    print(map2[6]!.isOdd);

    map1.addEntries([const MapEntry(1,2)]);
    var map3={...map2};

Runes
collection containing all decimal unicode code points of a String
integer value uniqurely identifying a gicen unicode character from inside a String

String - a sequence of utf-16 code units. the unit of storage of an encoded code point

code point of unicode character has been encoded to a 16 bit code unit (hexadecimal code point)

    String s = 'H';
0048
String is a list of heximal code

    Runes runes = Runes('H');
utf16 code point decimal

    var runes = Runes('H')
    .map(
      (e)=>e.toRadixString(16).padLeft(4,0),
    )
    .toList();
    
change to hexa and make 4 length and fill it with zero if empty

    print(runes);
    String hello = '\u{0048}';
    print(hello);

-function
can be assign to a variable

    void main(List<String> arguments){
      function functionObject=first;
      //it will give the value to variable
      //function functionObject=first();
      second(functionObject,5);
      //lambda
      second((int a)=>a,5);
    }

    void second(int function(int) f, int a){
      print(f.call(5));
      print(f(a));
    }

    int first(int a){
      return a;
    }

    int first(int a)=>a.isOdd?1:0;

lambda

    void main(List<String> arguments){
      //closure
      var list = ['hello'].map((e)=>null);
      var list = ['hello'].map((String s){return s.toUpperCase()}).toList();
      var list = ['hello'].map((String s)=> s.toUpperCase()).toList();
      var list = ['hello'].map(applyUpperCaseChanges);
    }

    String applyUpperCaseChanges(String s){
      return s.toUpperCase();
    }

function parameter
order matter
required positional parameters

     void requiredPositional(int a, int b)=>print('$a $b');
     requiredPositional(0,1);
     
optional positional parameters

     void optionalPositional({int a=5, int? b})=>print('$a $b');
     optionalPositional(12);

order not matter
required named parameters

     void requiredNamed(required int a, required int b)=>print('$a $b');
     requiredNamed(a:20,b:30);
     
optional named parameters

     void optionalNamed(int a=5, int b=10)=>print('$a $b');
     optionalNamed(a:20,b:30);

     void nameHybrid({required int a, int b=10}) => print('$a $b');

     void mixOfParams(int a, int b, {int c=5})=>('$a $b $c');

lexical scope

     void main(List<String> arguments){
       topLevel=6;
       void a(){
         topLevel=7
         var aVar=0;
         void b(){
           aVar=1;
         }
       }
     }

lexical closure

      void main(List<String> arguments){
        var car=makeCar('BMW');
        print(car('MS));
      }

      String function(String) makeCar(String make){
        var engine = '4.4 V8';
        return (model) => '$make $model $engine';
      }
      
callable class

      void main(List<String> arguments){
        var a=A();
        a();
        A()();
      }

      class A{
        void call()=>print("i'm a function!");
      }

-dart operator
operator is a function
the left operand determine the operation

      void main(List<String> arguments){
        var a=A(1);
        var b=B(3);

        // a.+ b
        print(a+b);

        // b.+ a
        print(b+a);
      }

      class X{
        final int value;
        X(this.value);
      }

      class A extends X{
        A(int value) : super(value);
        String operator +(X other) => 'A()+ =${value+other.value}';
      }

      class B extends X{
        B(int value) : super(value);
        String operator +(X other) => 'B()+ =${value+other.value}';
      }

using operatores => creating expressions

arithmetic
+-*/~/%-expr

      var a=5;
      //a1=a, then a=a+1'
      var a1=a++;
      print(a1);
      //a=a+1, then a2=a
      var a2=++a;
      print(a2);

equality and relational operators
== != < > <= >=

== identical()
equal point the same in memory
override using generate equility

      void main(List<String> arguments){
        var a1=const A(1,2);
        var a2=const A(1,2);

        print('a1 == a2 : ${a1==a2}');
        print('identical(a1,a2): ${identical(a1,a2)}');
      }

      class A {
        final int a;
        final int b;
        const A(this.a, this.b);

        @override
        bool operator==(Object other){
          if(identical(this,other)) return true;
          return other is A && other.a==a && other.b==b;

          @override
          int get hashCode => a.hashCode ^ b.hashCode;
        }
      }

use equitable

      class A extends Equatable{
        final int a;
        final int b;

        const A(this.a, this.b);

        @override
        List<Object?> get props=> [a,b];
      }

type test operator
as typecast also used with library prefixes

      import 'dart:math' as math;

      var list=[1,2.0];
      var a = list[0] as int;
      var b = list[1] as double;

      var list=[1,2.0]..forEach((element){
        if(element is int){
          print('$element is of int type');
        } else if(element is int){
          print('$element is of double type');
        }
      })

is true if the object has the specified type
is! true if the object doesnt have the specified type


assignment operator

= -= /= %= >>= ^= += *= ~/= <<= &= |= ??=

logical operator
!expr && ||

bit operators
& | ^(xor) <<(left shift) >>(right shift) ~

conditional expression
condition ? expr1 : expr2
expr1 ?? expr2

     Car rewardCar2(Car? dreamCar)=>dreamCar != null ? dreamCar : Car('random');

     Car rewardCar3(Car? dreamCar) => dreamCar ?? Car('random);
```
![OPERATOR](assets/operator.png?raw=true "OPERATOR")
```
control flow statement
if/else
if(){}

for
     for(var i=0;i < list.length;i++){}
     for(var item in list){}
     list.forEach((elements){print(element)})
     var list=[1,2]..forEach(print);
     var list=[1,2].where((element)=>element!=).forEach(print)

while 
     while(){}
     do(){} while()

break continue

switch case
this can be int, string, or other constant value

     enum Condition{sunny, cloudy}
     void main(List<String> arguments){
       var condition = Condition.sunny;
       switch(condition){
         sunny:
         case Condition.sunny:
         break;
         default:
         continue sunny;
       }
     }

assert
     var list=[];
     assert(list.inNotEmpty, 'list must not be empty!');

try, throw, catch, finally, rethrow
     int min = -1, max =2;
     int zero = min + math.Random().nextInt(max-min)
     print('Random zero: $zero');

     try{
       if(zero<0){
         throw NegativeValue(message: 'negative value');
       } else if(zero>0){
         throw PositiveValue(message: 'positive value');
       }
     } on NegativeValue{
       print('the value is negative');
     } catch(e){
       if (e is PositiveValue){
         print('the value is positive');
       }
     } finally {
       zero = 0;
     }
     if (zero==0){
       print('zero at the end: $zero');
     }

     class NegativeValue implements Exception{
       final String message;
       NegativeValue({required this.message});
     }

     class PositiveValue implements Exception{
       final String message;
       PositiveValue({required this.message});
     }

-class

      class A{
        @override
        String toString(){
          super.toString();
          return 'this is a!';
        }
      }

      void main(){
        Object o;
        var a = A();
        var hashCode = a.hashCode;
        print('hashCode --> $hashCode');

        var runtimeType = a.runtimeType;
        print('runtimetype --> $runtimeType');

        var str = a.toString();
        print('str --> $str);
      }

instance variable - field;

      class A{
        A(int p, int x, int b, int c)
        //initializer list
        : this.c=c
        {
          _private=p;
          a=x;
          this.b=b;
        }
        //named parameter
        A(
          this._private,{
          this.a,
          this.b,
          this.c}
        ) : d=b{
          d=b;
        }
        //can only be accessed on the same file
        int? _private;
        //any non final fields & late final fields will have a default setter method
        int? a;
        int b=1;
        final int c=2;
        late int d;
        late final int e;
        late final int f=5;
        //can be access without creating an instance A.g (not A().g)
        static int g=6;
        static late in h;
        static late int i=8;
        static late final int j;
        static const int k=10;
      }

method
constructor must have the same name with class
constructor doesnt have return
      
      class A{
        A();
      }

      class A{
        A({
          required this.x,
          required this.y
        });
        //named constructor
        A.zero(): x=0,y-0;

        A.fromJson({required Map<String, int> json}):x=json['x']!,y=json['y']!;

        A.zeroX({required int y}):this(x:0,y:y);
        A.zeroY({required int X}):this(x:x,y:0);

        final int x;
        final int y;

        @override
        String toString()=>'A(x:$x,y:$y)';
      }

      void main(){
        var alfa=A(x:1,y:2);
        var alfaZero = A.zero();
        var alfaFromJson = A.fromJson(json: {'x':5,'y':10});
        print('alfa-->$alfa');
        print('alfaZero-->$alfaZero');
      }

      class Point{
        const Point({
          required this.x,
          required this.y
        });

        PointRandom({})

        final int x;
        final int y;
        static const Point origin = Point(x:0,y:0);

        @override
        String toString()=> 'Point(x:$x, t:$y)';
      }

      void main(){
        const p1=Point(x:1,y:1);
        const p2=Point(x:1,y:1);
        print(identical(p1,p2));

        const listOfPoints = [
          Point(x:1,y:1),
          Point(x:1,y:1),
        ]

        var listOfPoints = const[
          const Point(x:1,y:1),
          const Point(x:1,y:1),
        ]
      }

factory constructor

      class Point{
        const Point({
          required this.x,
          required this.y,
        });

        factory Point.random({required bool isPositive}){
          int minNegativeValue=-99;
          int maxNegativeValue=-1;
          int minPositiveValue=0;
          int maxPositiveValue=99;

          int randomNegativeValue=minNegativeValue+Random().nextInt(maxNegativeValue-minNegativeValue);
          int randomPositiveValue=minPositiveValue+Random()nexInt(maxPositiveValue-minPositiveValue);

          return isPositive ? Point(x:randomPositiveValue, y:randomPosiiveValue):Point(x:randomNegativeValue, y:randomNegativeValue);
        }

        final int x;
        final int y;
        static const Point origin = Point(x:0,y:0);

        @override
        String toString()=> 'Point(x:$x,y$y)';
      }

      factory Point.explanation(){
        return Point.random(isPositive:true);
      }

      void main(){
        var randomNegative=Point.random(isPositive:false);
        print(randomNegative);
        var randomPositive=Point.random(isPositive:true);
        print(randomPositive)
      }

      class Singleton{
        Singleton._privateConstructor();
        static final Singeleton _instance = Singleton._privateConstructor();
        factory Singleton() =>_instance;
      }

      class ConstantClass{
        const ConstantClass();
      }

      void main(){
        Singeleton s1 = Singeleton();
        Singeleton s2 = Singeleton();
        ConstantClass c1 = const ConstantClass();
        ConstantClass c2 = const ConstantClass();
      }

instance method

operator

getter & setter
      final int x;
      int get x=>x;

      int get sum=>x+y;
      int get diff=>x-y;

      void main(){
        var p1=Point(x:0,y:0);
        var p2=Point(x:1,y:1);
        print(p1.sum);
      }

      class Car{
        late int age;
        set manuFacturedYear(int value)=>age=2021-value;
      }

      void main(){
        var car=Car();
        car.manufacturedYear=2006;
        car.age;
        print(car.age);
      }

static method

      class Point{
        const Point({
          required this.x,
          required this.y
        });

        static distanceBetween(Point p1, Point p2){
          var dx=p1.x-p2.x;
          var dy=p1.y-p2.y;
          return sqrt(powe(dx,2)+pow(dy,2));
        }

        Point operator +(Point p)=>Point(x:x+p.x,y:y+p.y);
        Point operator -(Point p)=>Point(x:x-p.x,y:y-p.y);
        //instance method
        num distanceTo(Point p){
          var dx=x-p.x;
          var dy=y-p.y;
          return sqrt(pow(dx,2)+pow(dy,2));
        }
      }

      void main(){
        var p1=Point(x:1,y:1);
        var p2=Point(x:1,y:1);
        print(Point.distanceBetween(p1,p2));
        print(p1.distanceTo(p2));
        print(p1+p2);
        print(p1-p2);
      }

dart
everything you create will be an object instantiated from a class
everything class you create will inhereit by default the object class

       class Animal{
         final String name;
         Animal({required this.name});
         //animal.fromJson():name='jerry';
         void whatAmI()=>print('im an animal');
         void chase(Animal a){}
       }

       //bird extends animal. animal extends object, therefore bird extends object too
       class Bird extends Animal{
         Bird(String name) : super(name:name);
       }

       class Duck extends Bird{
         Duck(String name) : super(name);

         @override
         void whatAmI()=>print('im a duck');
       }

       class Mouse extends Animal{
         Mouse(String name):super(name:'jerry');
       }

       class Cat extends Animal{
         Cat(String name):super(name:'tom');
         @override
         void chase(covariant Animal a){}
       }

       void main(){
         Duck duck = Duck('Munchkin');
         print(duck.name);
         duck.whatAmI;
       }

dart can only extend 1 single class

inheritance
inheritance concept is achieved by using the extends keyword
class Duck extends Bird{} - Duck(derived, subclass), Bird(base, superclass)
extends is used for sharing behavior between superclass & subclass
fields & methods inside the superclass are available in the subclass
superclass can be accessed by using the super keyword
all dart classes extend only one class (object class by default)
the concept of polimorphism can be achieved in two ways:
@overriding methods, @overloading methods (optional parameter)
you can tighten a type by using the covariant keyword

      class BubbleData{
         String sender;
         String text;
         bool isMe;

         BubbleData({required this.sender, required this.text, required this.isMe});
      }

      void main(){
        List<BubbleData> bubbles = [
           BubbleData(sender: 'Not Me', text: 'Hey Mi', isMe: false),
           BubbleData(sender: 'Not Me', text: 'What\'s new?', isMe: false)
        ];

        for (var bubble in bubbles) {
          print(bubble.text);
        }
      }

abstaction
abstract classes
abstract methods
interfaces - class that contain the field and method header. so every other class that implemented it need to implement field and method that existed.

       abstract class UserRepositoryInterface{
         late final List<int> usersList;
         //abstract method
         void create();
         List<int> read();
         void update();
         void delete();
       }

       class UserRepository implements UserRepositoryInterface{
         @override
         List<int> usersList;

         @override
         void create(){}

         @override
         void delete(){}

         @override
         List<int> read(){}

         @override
         void update(){}
       }

       void main(){
         UserRepository userRepository = UserRepository();
         userRepository.create();
       }

in dart there are no explicit interfaces use abstract classes to declare interfaces
the extends keyword shares behavior of base to the derived class
the implements keyword forces behavior of interfaces to derived class
extends only one class, implements one or more classes

       class A{
         void methodA(){}
       }
       class B{
         void methodB(){}
         external void doSomething();
       }

       class C implements A,B{}

       void main(){}

explicit interface = abstract class
implicit interface = every class

abstract classes, abstract methods, interface
abstraction concept is achieved by using the implements keyword
class A implements B{} - B is an interface that needs to be implement in A
in dart every class is an implicit interface but every abstract class is an explicit interface
when implementing an interface, you have to override every field and method from inside the interface
you can extend only one class, but implement one or more interfaces

the reason why dart only single inheritance
multiple inheritance & polimorphism causing deadly diamond of death (ddd) 

        class Performer - void perform()

        class Guitarist extends Performer
        @override void perform()

        class Drummer extends Performer
        @override void perform()

        class Musician extends Guitarist, Drummer

Mixins
mixins solve the problem in dart
a class with no constructor
a class of which behavior can be shared with other classes
1. create simple class with no constructor
        class A{}
2. create an abstract class
        abstract class A{
          void method(){}
        }
3. using the mixin keyword
        mixin A{
          void method();
        }
        class B with A{
          @override
          void method(){
            super.method();
          }
        }
        void main(){
          B b = B();
          b.method();
        }
        
mixin cant be extended from another class, use with to mix in with another 

        class Performer{
          void perform()=>print('Performs!');
        }
        mixin Guitarist on Performer {
          void playGuitar()=>print('playing the guitar');
          //void perform()=>playGuitar();
          void test()=>super.perform();
        }
        mixin Drummer{
          void playDrums()=>print('Playing the drums');
          void perform()=>playDrums();
        }
        class Musician extends Performer with Guitaris, Drummer{}

        void main(){
          Musician musician = Musician();
          musician.playDrums();
          musician.playGuitar();
          musician.perform();
          musician.test();
        }

mixins are used to share behavior between one or more classes
indart you can extend one single class, implement or mixin one or more classes
the order in which you write the mixins after the with keyword matter
amixin cannot be instantiated, it cannot have a constructor
a mixin that mixed in with other class can use its method and can even override some of them

extension method

        /class IntegerExtension extends int{
        //  int get luckyNumber=>12;
        //}

        extension IntegerExtension on int{
          int get luckyInteger=>12;
          int add15()=>this+15;
        }

        void main(){
          print(1.luckyInteger);
          print(10.add15());
        }

        generics
        E element, K key, V value, T type, S source, R return

        class Tuple{
          final int? _a;
          final int? _b;
          final int? _c;

          int? get first=>_a;
          int? get second=>_b;
          int? get third=>_c;

          Tuple(this._a, this._b, this._c);
          Tuple.fromList(List<int> list)
          : _a=list.asMap().containtsKey(0)?list[0]:null,
           _b=list.asMap().containtsKey(1)?list[1]:null,
           _c=list.asMap().containtsKey(2)?list[2]:null;

           Tuple operator +(Tuple t)=>Tuple(_a!+t._a!, _b!+t._b!, _c!+t._c!);
           Tuple operator -(Tuple t)=>Tuple(_a!-t._a!, _b!-t._b!, _c!-t._c!);

           @override
           String toString()=>'Tuple:$first $second $third';
        }

        void main(List<String> arguments){
          const Tuple tuple1 = Tuple(1,2,3);
          final Tuple tuple2 = Tuple.fromList([4,5,6]);
          final Tuple tuple3 = Tuple.fromList([7]);
          final Tuple tuple4 = tuple1+tuple2;

          print(tuple1)
          print(tuple2)
          print(tuple3)
          print(tuple4)
        }

        class Tuple<E extends num>{
          final E? _a;
          final E? _b;
          final E? _c;

          E? get first=>_a;
          E? get second=>_b;
          E? get third=>_c;

          const Tuple(this._a, this._b, this._c);
          Tuple.fromList(List<E> list)
          : _a=list.asMap().containtsKey(0)?list[0]:null,
           _b=list.asMap().containtsKey(1)?list[1]:null,
           _c=list.asMap().containtsKey(2)?list[2]:null;

           Tuple<num> operator +(Tuple<num> t){
            if(this is Tuple<num>){
              final thisAsTupleNum = this as Tuple<num>;
                return Tuple(thisAsTupleNum._a!+t._a!, thisAsTupleNum._b!+t._b!, thisAsTupleNum._c!+t._c!);
            }
            return const Tuple(0,0,0);
          }
           Tuple<num> operator -(Tuple<num> t){
            if(this is Tuple<num>){
              final thisAsTupleNum = this as Tuple<num>;
                return Tuple(thisAsTupleNum._a!-t._a!, thisAsTupleNum._b!-t._b!, thisAsTupleNum._c!-t._c!);
            }
            return const Tuple(0,0,0);
           }


           @override
           String toString()=>'Tuple:$first $second $third';
        }

        void main(List<String> arguments){
          const t1 = Tuple(1,2,3);
          const t2 = Tuple(4,5,6);
          const t3 = Tuple('a','b','c');
        }

        class RandomClass<E>{}
        void main(List<String> arguments){
          var listOfInts=<int>[1,2,3];
          var listOfStrings=<String>['a','b','c'];
          var intClass=RandomClass<int>();
          var stringClass=RandomClass<String>();
        }

        class Stack<T>{
          final List<T> _stack=[];
          T get peak=>_stack.last;
          int get length=>_stack.length;
          bool get canPop=>_stack.isNotEmpty;
          T pop(){
            final T last = _stack.last;
            _stack.removeLast();
            return last;
          }
          void push(T value=>_stack.add(value));
        }

        void main(List<String> arguments){
          var stackInt=Stack<int>();
          var stackString=Stack<String>();

          stackString.push('2');
          stackString.push('3');
          if(stackString.canPop()){}
          print(stackString.peak);
        }

generics make everything more abstract more universal more widely compatible

        class Utils{
          static T? getItem<T>(List<T> list, int index)=> list.asMap().containsKey(index) ? list[index].toUpperCase():null;
        }

        void main(List<String> arguments){
          var list = ['a','b'];
          print(Utils.getItem(list,0));
        }

we need to implement data structure of your own, you wont have to reimplement the same class for each type
some portion of your code are kind of repetitive

        void main(List<String> arguments){
          final result1=(((a+b)/2)*1/3)%4;
          final result2=(((a+b)/2)*1/3)%4;
        }

        num calculate(int a, int b)=>(((a+b)/2)*1/3)%4;
        void main(List<String> arguments){
          final result1=calculate(1,2);
          final result2=calculate(3,4);
        }

        double calculate<T extends num>(T a, T b)=>(((a+b)/2)*1/3)%4;
        void main(List<String> arguments){
          final result1=calculate(1,2);
          final result2=calculate(3,4.3);
        }
 ```
