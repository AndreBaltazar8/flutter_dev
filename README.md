# Dev Tools

[![pub package](https://img.shields.io/pub/v/dev.svg)](https://pub.dev/packages/dev)

Dev tools and widgets for Flutter applications.

## How to use

In your pubspec.yaml:
```yaml
dependencies:
  dev: ^1.0.0
```

```dart
import 'package:dev/dev.dart';
```

Basic construction of the widget:

```dart
Widget build(BuildContext context) {
  return DevMenu(
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
  );
}
```

## License
Licensed under the [MIT license](https://opensource.org/licenses/MIT).
