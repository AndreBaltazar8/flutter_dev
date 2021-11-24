library dev;

import 'package:flutter/material.dart';
import 'package:gestures/gestures.dart';

export 'package:gestures/gestures.dart';

const bool _isReleaseMode = const bool.fromEnvironment("dart.vm.product");

class DevMenu extends StatefulWidget {
  final List<Gesture>? gestures;
  final Widget body;
  final Widget devMenu;
  final bool hideInRelease;
  final VoidCallback? onOpen;
  final VoidCallback? onClose;
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

  bool get isOpen => _showMenu;

  void open() {
    setState(() {
      bool isOpen = _showMenu;
      _showMenu = true;
      if (!isOpen) widget.onOpen?.call();
    });
  }

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

Widget buildDevMenu({
  Key? key,
  required Widget body,
  required Widget Function() devMenu,
  bool hideInRelease = true,
  List<Gesture>? gestures,
}) {
  return _isReleaseMode
      ? body
      : DevMenu(
          key: key,
          body: body,
          devMenu: devMenu(),
          gestures: gestures,
        );
}
