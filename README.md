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
   - Encapsulated theme from comfort using
   - Cosmetic changes like some animations

Internal:
   - CI/CD testing and analyzing before pull, tried to build and send the .apk with key is in github storage, but I haven't been able to figure out the storage .jks file in secrets
   - Connected Logger
   - DI with riverpod
   - dev banner if flag --dart-define=is_test=true has been set
   - Connected AppMetrica for analytics
   - Connected Crashlitics

APK:
   - https://disk.yandex.ru/d/qLc3FgaWnEDWuw

Firebase:
   - https://console.firebase.google.com/u/0/project/done-9bf58/overview

AppMetrica
   - https://appmetrica.yandex.ru/statistic?appId=4271599

Images:
   - ![1](https://user-images.githubusercontent.com/74249484/187086751-df9bf344-096f-4340-a143-c8dcab95a89e.png)
   - ![2](https://user-images.githubusercontent.com/74249484/187086753-42155fc1-00e3-4406-9fae-50c136501412.png)
   - ![3](https://user-images.githubusercontent.com/74249484/187086757-3951b4cd-29c8-4510-b360-27c5ce7dbc4c.png)



