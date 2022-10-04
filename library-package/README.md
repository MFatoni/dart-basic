```
dart doesnt offer class private fields instead it is offer library private fields
1 feature 1 library

part and part of
 only part of directive are allowed inside extension files from inside library
 all extension files can access both private and public members of the library
 when you want to access something from inside an extension file, all other files that are part of that library will be also include in the import

rule
 declare all your libraries containing feature implementation inside the lib folder
 never reach in or out the lib folder by using relative import, when you need to use the 'package' directive

libraries containing specific implementation from your package should be placed inside the lib folder
a file represent a library unless
 we want to have multiple files inside your library (part & part of)
 we want to have multiple libraries inside bigger library (export)
```
