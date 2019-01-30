# Dev Tools

[![pub package](https://img.shields.io/pub/v/dev.svg)](https://pub.dartlang.org/packages/dev)

Dev tools and widgets for Flutter applications.

## How to use

In your pubspec.yaml:
```yaml
dependencies:
  gestures: ^0.0.1
```

```dart
import 'package:gestures/gestures.dart';
```

Basic construction of the widget:

```dart
DevMenu(
  gestures: [
    GestureLine(AxisDirection.down),
    GestureLine(AxisDirection.right),
    GestureLine(AxisDirection.up),
  ],
  onGestureEnd: (success) {
    if (success) {
      // TODO: your action here..
    }
  },
  body: Container(),
  devMenu: Text('Dev Menu'),
)
```

## License
Licensed under the [MIT license](https://opensource.org/licenses/MIT).
