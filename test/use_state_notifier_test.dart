import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_state_notifier/hooks_state_notifier.dart';
import 'package:state_notifier/state_notifier.dart';

class _TestNotifier extends StateNotifier<int> {
  _TestNotifier() : super(0);

  void increment() => state++;
  void decrement() => state--;
  void change(int newState) => state = newState;
}

void main() {
  testWidgets('useStateNotifer', (tester) async {
    var notifer = _TestNotifier();
    int? lastState;

    Future<void> pump() {
      return tester.pumpWidget(HookBuilder(
        builder: (context) {
          lastState = useStateNotifer(notifer);
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Text(lastState.toString()),
          );
        },
      ));
    }

    await pump();

    expect(lastState, 0);
    expect(find.text('0'), findsOneWidget);

    final element = tester.firstElement(find.byType(HookBuilder));

    expect(notifer.hasListeners, true);
    expect(element.dirty, false);
    notifer.increment();
    expect(element.dirty, true);
    await tester.pump();
    expect(element.dirty, false);

    final previousNotifer = notifer;
    notifer = _TestNotifier();

    await pump();

    expect(previousNotifer.hasListeners, false);
    expect(notifer.hasListeners, true);
    expect(element.dirty, false);
    notifer.increment();
    expect(element.dirty, true);
    await tester.pump();
    expect(element.dirty, false);

    await tester.pumpWidget(const SizedBox());

    expect(notifer.hasListeners, false);

    notifer.dispose();
    previousNotifer.dispose();
  });
}
