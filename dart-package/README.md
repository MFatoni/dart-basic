-dart package

![Pubspec](assets/pubspec_general.png?raw=true "Pubspec")

directory containing, at minimum a pubspec.yaml
dart ecosystem uses packages to manage shared software (libraries & tools)
pub package manager

main package<- a<- b<- c
*<-require

immidiate dependencies = a
transitive dependencies = b,c

regular dependencies = dev and prod phase
dev dependencies = dev phase only

dependencies using semantic versioning (should still work after upgrade on stable version 1.0.0 - 1.9.9)

caret syntax
depedencies:
 bloc: ^1.2.3
 test: ^0.1.2

traditional syntax
dependencies:
 bloc: >=1.2.3 <2.0.0
 test: >=0.1.2 <0.2.0

-hosted packages
pub.dev
 depedencies:
  wckd_package: ^1.4.0
http server
 depedencies:
  wckd_package:
   hosted: wckd_package
   url: http://wckd_package.com
 version: ^1.4.0

-git packages
depedencies:
  wckd_package:
   git: https://github.com/TheWCKD/wckd_package.git

depedencies:
  wckd_package:
   git: 
    url: git@github.com:TheWCKD/wckd_package.git
    ref: master_dev

-path packages
depedencies:
  package_a:
   path: /packages/package_a
  package_b:
   path: /packages/package_b

-sdk packages
dependencies:
 flutter_driver:
  sdk: flutter
  version: ^0.0.1

located on
%LOCALAPPDATA%\Pub\Cache
.pub-cache in home directory