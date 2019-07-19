# GamePoints (Flutter)

The Flutter version of my favorite tutorial app; GamePoints.
Built together with my good friend nel-sam (https://github.com/nel-sam).
GamePoints can be used to keep track of each player's points in any game. 
It has the option to use a timer that limits each round and also has an option 
to store player names to disk for easy re-use when the app is used again at a later time.

<img src="https://raw.githubusercontent.com/nel-sam/gamepointsflutter/master/screenshots/readme1.png" width="400px">
<img src="https://raw.githubusercontent.com/nel-sam/gamepointsflutter/master/screenshots/readme2.png" width="400px">

## What I learned
1. Wiring up event handlers so parent widgets get alerted of activity in child widgets
2. Saving data to disk that is read when the app is re-used at a later date
3. Using OrientationBuilder to change behavior based on phone orientation
4. Asynchronous programming in Dart using Timer and Future<T>
5. Playing sound in a Flutter mobile app
 
## Previous skills I was able to practice
1. Dart language syntax and patterns
2. Increased familiarity with Flutter app structure
3. Increased familiarity with various Flutter widgets
3. Working with ADB and the Flutter CLI to push APKs to devices

## What we would do differently
1. We later learned about Streams and StreamBuilder. The messaging system we setup for reporting points changes back to the main widget could be much cleaner if we'd used Streams
2. Started with Platform widgets (https://pub.dev/packages/flutter_platform_widgets) to get an IOS look on IOS, and a Material look on Android automatically