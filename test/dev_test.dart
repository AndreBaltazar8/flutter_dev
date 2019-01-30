import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dev/dev.dart';

void main() {
  // TODO: fix this test
  testWidgets('open menu', (WidgetTester tester) async {
    var containerKey = UniqueKey();
    var opened = false;
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return MaterialApp(
            home: Material(
              child: DevMenu(
                body: Container(
                  key: containerKey,
                  child: SizedBox(
                    width: 500,
                    height: 500,
                  ),
                ),
                devMenu: Container(),
                onOpen: () {
                  setState(() {
                    opened = true;
                  });
                },
              ),
            ),
          );
        },
      ),
    );

    expect(opened, equals(false));
    final RenderBox box = find.byKey(containerKey).evaluate().first.renderObject;
    await tester.startGesture(box.localToGlobal(Offset.zero + Offset(5, 5))).then((gesture) async {
      await gesture.moveBy(Offset(0, 40));
      await gesture.moveBy(Offset(0, 55));
      await gesture.moveBy(Offset(0, 55));
      await gesture.moveBy(Offset(40, 0));
      await gesture.moveBy(Offset(55, 0));
      await gesture.moveBy(Offset(55, 0));
      await gesture.moveBy(Offset(0, -40));
      await gesture.moveBy(Offset(0, -55));
      await gesture.moveBy(Offset(0, -55));
      await gesture.up();
    });

    expect(opened, equals(true));
  });
}
