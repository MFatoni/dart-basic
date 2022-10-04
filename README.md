DART PROGRAMMING LANGUAGE
```
-key factor
precision - language has to be as optimised as possible
speed - language has to be minimalist and fast to run
tough - language has to be scalable, maintainable and readable
modifiable - language has to benefit of fast hot reload
popular framework - language is the foundation of flutter

-characteristics
dart is type safe - the only operations that can be performed on data in the language, are those allowed by the type of data
dart using sound type system - not allowed to run into undefined state
 static type check - compile time - local check
 runtime check - run time - additional check when program run

        int a = 5;
        String s = 'course'

        a cant use toUpperCase operation

 dynamic type - static analyzer wont check, only checked by runtime analyzer

        dynamic b = 3.4;
        b.aRandomMethod();

type are mandatory but dont have to be annotated because dart can infer types

differences between var keyword and dynamic type
 var keyword - automaticaly convert data type to match the value, it is permanent, the conversion is happening using static dart analyzer, it is not a type it is only a keyword that tell the static dart analyzer to assign data type automaticaly
 dynamic type - can set into multiple data types and only checked on runtime

        void main {
                dynamic a = 5;
                print(a.runtimeType);
                a = 'test';
                print(a.runtimeType);

                var b = 5;
                print(b.runtimeType);
        }

 var keyword will automaticaly convert into dynamic if there is no value set and it will set null as the value

sound null safety - variable cant contain null unless there is an order - static & runtime check
data can be nullable or non - nullable, but it cant be both

dart compiler - convert source code into intermediate language / machine code
 arm32, arm64, x86_64 = jit (just in time compiler), aot (ahead of time compiler)
 javascript = dart devc (dart development compiler), dart2js (dart to javascript)

development phase is using jit
 easy to test the code
 easy to debug the code
 live metrics support 
 fast coding cycles
 incremental recompilation

jit will compile the code it needs, just when it needs the code
 jit compiles just the ammount of code it need
 jit does not recompile the already compiled code if it hasnt changed
 it is using incremental recompilation (jit responsible for hot-reload)

jit should only be in development phase because
 jit does not transform the dart code into machine code but rather into an intermediary language (for faster development cycles)
 into production phase, the user doesnt care about the jit features like fast testing, debugging or hot-reload. All they cares about are for the app to start and run as fast as it can on his device.

production phase is using aot
 app should start fast
 app should run fast
 app doesnt need extra debugging features
 app doesnt need hot-reload anymore
 app should be compiled into machine code on the specific platform

ahead of time compiler - compiles the entire code into the machine code support natively by platform. It does just before each build
 aot compiles the entire source code
 aot compiles the code into platfom specific machine code
 aot makes sure the build is the best most optimal version of it

flutter sdk contain compilers, analyzers, debuggers, libraries, softwork framework

installing the dart sdk will only allow developing
 command line applications
 server applications
 non-flutter web application

standalone flutter application needs flutter sdk. but since flutter 1.21, flutter sdk include dart sdk

supported platfrom
 windows 10 - i32, x64
 linux - x64, ia32, arm, arm64
 apple - x64, arm64

dart sdk release channels (stable releases)
stable channel
 suitable for production user
 updated roughly every 3 months
 x.y.z; x=major, y=minor, z=patch
beta channel (preview releases)
 preview builds for the stable channel, recommended for testing new features
 usually updated every month
 x.y.z-a.b.beta; a=prerelease, b=prerelease patch
dev channel (prereleases)
 latest changes, may be broken or unsupported
 usually updated twice a week
 x.y.z-a.b.dev; a=prerelease, b=prerelease patch

test
type of test on dart are unit, component, e2e

component widget test
 verify that a component (which usually consists of multiple classes) behaves as expected
 a component test often requires the use of mock object(object that can mimic user actions, events, instantiate child components etc)

integration e2e end to end test
 verify the behavior of an entire app, or a large chunk of an app
 an integration test generally runs on a simulated or a real device and consists of two pieces: the app itself and the test app that puts the app through its paces

dart sync
 dart is single thread. single thread of execution called mutator thread.

 microtask events have ahigher priority compared to future event

        void main(){
               print("A");
               Future((){
                      print("B);
                      future(()=>print("C"));
                      future.microtask(()=>("D));
                      Future(()->print("E"));
                      print("F");
               });
               print("G");
        }
        AGBFDCE

synchronous operation = a task that needs to be solved before proceeding to solving the next one

iterable 
 much more abstract collection
 it is constructed lazily=> when an element is accessed (it is generated the item whenever the element accessed)
 it is traversed with the help of an iterator(curr,nextItem())
 it doesnt need to have s specified length
 acessing an element with regenerate all elements until the desired one is found

list
 special non lazyly iterable => constructed as soon as it is called
 has defined size and items are stored at a specific index
       1 value  |0 or more values
 sync  T        |iterable<T>
 async future<T>|stream<T>

        void main(){
               sum(1,2);
               print(sum(1,2));
               final a = showNormal(10);
               print(a.last);
               print(a.first);
               final b = showGenerator(10);
               print(b.last);
               print(b.first);
        }
        int sum(int a, int b)=> a+b;

        List<int> showNormal(int n){
               print('normal started');
               final list=<int>[];
               for(var i=1;i<=n;i++){
                      print(i);
                      list.add(i);
               }
               print('normal ended');
               return list;
        }

        Iterable<int> show(int n) sync*{
               print('generator started');
               for(var i=1;i<=n;i++){
                      print(i);
                      yield i;
               }
               print('generator ended');
        }

asynchrony = generate items in the background, while we can process other tasks
laziness = generate items synchronously, but only at the time you'll need them

         Iterable<int> showNegativeGenerator(int n) sync* {
                print('negative generator started');
                for(var i=1;i<=n;i++){
                       print(i);
                       yield -i;
                }
                print('negative generator started');
         }

         Iterable<int> showGenerator(int n) sync*{
                print('generator started');
                for(var i=1;i<=n;i++){
                       print(i);
                       yield i;
                }
                yield* showNegativeGenerator(n);
                print('Generator ended');
         }

async operation 
 a task that doesnt need to be solved before proceeding to processing the next one

 async may content unprocessed, uncompleted, complete error or completed value
 sync may content unprocess, completed error, completed value

         void main(List<String> arguments){
                print('Start');
                Future(()=>1).then(print).onError((error, stackTrace)=>null).whenComplete(()=>null);
                Future(()=>Future(()=>2)).then(print);
                Future.delayed(const Duration(seconds:1),()=>3).then(print);
                Future.delayed(const Duration(seconds:1),()=>Future(()=>4)).then(print);
                Future.value(5).then(print);
                Future.value(Future(()=>6)).then(print); 
                // Future(()=>6)
                Future.sync(()=>7).then(print);
                Future.sync(()=>Future(()=>8)).then(print);
                // Future.value(7)
                Future.microtask(()=>9).then(print);
                Future.microtask(()=>Future(()=>10)).then(print);
                //Future(()=>10) but placed on microtask queue
                Future(()=>11).then(print);
                Future(()=>Future(()=>12)).then(print);
                print('end');
         }
         start end 5 7 9 1 6 8 11 10 2 12 3 4

         mikrotask : f(10) 9 7 5
         event : f(4) 3 f(12) 11 8 6 f(2) 1

         void main(){
                print('1');
                scheduleMicrotask(()=>print('2'));
                Future.delayed(const Duration(seconds:1),()=>print('3'));
                Future(()=>print('4')).then((_)=>print('5')).then((_){
                       print('6');
                       scheduledMicrotask(()=>print('7'));
                }).then((_)=>print('8'));
                scheduleMicrotask(()=>print('9'));
                Future(()=>print('10));
                scheduleMicrotask(()=>print('14'));
                print('15);
         }

         micro: 14 9 2
         event: 3 12 10 4
         output: 1 15

         1 15 2 9 14 4 5 6 8 7 10 13 11 12 3

         Future main(List<String> arguments) async{
                late final int a;
                print('start');
                a=await Future(()=>1);
                print(a);
                await Future(()=>1).then(value)=>a=value;
                print('end')
         }

         stream

         void main(List<String> args){
                Stream.periodic(const Duration(seconds:1),(x)=>x).listen(print);
                Stream.periodic(const Duration(seconds:1),(x)=>-x).listen(print);

                Stream.fromFuture([Future(()=>3),Future.value(2)]).listen(print);

                final StreamController streamController=StreamController<int>.broadcast();
                final streamSubscription = streamController.stream.listen(print);
                final otherStreamSubscription = streamController.stream.listen(print);
                var value=0;
                Timer.periodic(const Duration(seconds:1),(timer){
                       if(value==5){
                              timer.cancel();
                              streamController.close();
                              streamSubscription.cancel();
                       } else {
                              streamController.add(value++);
                       }
                });
         }
