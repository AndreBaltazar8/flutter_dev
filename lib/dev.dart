library dev;

import 'package:flutter/material.dart';
import 'package:gestures/gestures.dart';

export 'package:gestures/gestures.dart';

const bool _isReleaseMode = const bool.fromEnvironment("dart.vm.product");

/// A developer menu that can contain functionality to help test the app.
class DevMenu extends StatefulWidget {
  /// The gesture to open the app.
  ///
  /// If no gesture is provider it defaults to [down, right, up] a gesture.
  final List<Gesture>? gestures;

  /// The body of the app.
  final Widget body;

  /// The developer menu widget.
  final Widget devMenu;

  /// Whether this menu should be present on release.
  final bool hideInRelease;

  /// A callback on menu open.
  final VoidCallback? onOpen;

  /// A callback on menu close.
  final VoidCallback? onClose;

  /// The hit behaviour for this widget.
  ///
  /// Defaults to [HitTestBehavior.opaque].
  final HitTestBehavior? behavior;

  const DevMenu({
    Key? key,
    required Widget body,
    required Widget devMenu,
    this.gestures,
    this.onOpen,
    this.onClose,
    this.behavior,
    bool hideInRelease = true,
  })  : this.body = body,
        this.devMenu = devMenu,
        this.hideInRelease = hideInRelease,
        super(key: key);

  @override
  DevMenuState createState() => DevMenuState();
}

class DevMenuState extends State<DevMenu> {
  bool _showMenu = false;
  List<Gesture> _gestures = [];

  @override
  void initState() {
    super.initState();

    _updateGestures();
  }

  void _updateGestures() {
    final gestures = widget.gestures;
    if (gestures != null && gestures.length > 0) {
      _gestures = gestures.toList();
    } else {
      _gestures = <Gesture>[
        GestureLine(AxisDirection.down),
        GestureLine(AxisDirection.right),
        GestureLine(AxisDirection.up),
      ];
    }
  }

  @override
  void didUpdateWidget(DevMenu oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.gestures != widget.gestures) _updateGestures();
  }

  /// Whether the menu is open.
  bool get isOpen => _showMenu;

  /// Opens the dev menu.
  void open() {
    setState(() {
      bool isOpen = _showMenu;
      _showMenu = true;
      if (!isOpen) widget.onOpen?.call();
    });
  }

  /// Closes the dev menu.
  void close() {
    setState(() {
      bool isOpen = _showMenu;
      _showMenu = false;
      if (isOpen) widget.onClose?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.hideInRelease && _isReleaseMode
        ? widget.body
        : CustomGestureDetector(
            behavior: widget.behavior ?? HitTestBehavior.opaque,
            gestures: _gestures,
            onGestureEnd: (success) {
              if (success) {
                setState(() {
                  _showMenu = !_showMenu;
                  (_showMenu ? widget.onOpen : widget.onClose)?.call();
                });
              }
            },
            child: _showMenu
                ? Stack(
                    children: <Widget>[
                      widget.body,
                      Material(
                        color: Colors.red.withOpacity(0.4),
                        child: SafeArea(
                          child: Container(
                            constraints: BoxConstraints.expand(),
                            child: widget.devMenu,
                          ),
                        ),
                      ),
                    ],
                  )
                : widget.body,
          );
  }
}

/// Build a dev menu that will not be included in release
Widget buildDevMenu({
  Key? key,
  required Widget body,
  required Widget Function() devMenu,
  List<Gesture>? gestures,
  HitTestBehavior? behavior,
}) {
  return _isReleaseMode
      ? body
      : DevMenu(
          key: key,
          body: body,
          devMenu: devMenu(),
          gestures: gestures,
          behavior: behavior,
        );
}
