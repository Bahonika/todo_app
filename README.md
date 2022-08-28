# todo_app

Todo flutter app

Features:
   - Interlocalization according to the platform language with intl
   - flutter_linter added and running
   - All code formatted
   - Four architectural layers were used
   - Riverpod as State Manager
   - Local and Remote data layers
   - Local data with Hive
   - The theme can be changed by drawing a circle on the header of the home screen, if circle is not enough round, then a hint will appear showing how it should be
   - Offline first, when the application is launched, the revisions are checked and the data is merge
   - Models are generated with hive and freezed
   - Add some unit, widget and golden tests
   - Create one integration test with creating and deleting todo
   - Navigator 2.0 and deeplinks to all screens. It seems that the link to todo even works, checked in web*
   - Implemented support for landscape orientation and large screens 

Internal:
   - CI/CD testing and analyzing before pull, tried to build and send the .apk is in github storage, but I haven't been able to figure out the storage .jks file in secrets
   - Connected Logger
   - DI with riverpod
   - dev banner if flag --dart-define=is_test=true has been set
   - Connected AppMetrica 
   - Connected Crashlitics

APK:
   - https://disk.yandex.ru/d/IH_w8AT6P2VB6w

Firebase:
   - https://console.firebase.google.com/u/0/project/done-9bf58/overview

AppMetrica
   - https://appmetrica.yandex.ru/statistic?appId=4271599

Images:
   - ![1](https://user-images.githubusercontent.com/74249484/183281965-5e93414e-fcd7-4c40-ab2a-ecdc2bc84253.png)
   - ![2](https://user-images.githubusercontent.com/74249484/183281981-3de0862a-e01e-497c-b330-a940659efe7c.png)
   - ![3](https://user-images.githubusercontent.com/74249484/183281983-570ab4e6-e2eb-4590-9d3d-677d2cd9d71c.png)
