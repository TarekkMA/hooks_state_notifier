import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_state_notifier/src/use_create_state_notifier.dart';
import 'package:state_notifier/state_notifier.dart';

class _TestNotifier extends StateNotifier<int> {
  _TestNotifier([int? state]) : super(state ?? 0);

  void increment() => state++;
  void decrement() => state--;
  void change(int newState) => state = newState;

  @override
  String toString() {
    return '_TestNotifier($state)';
  }
}

void main() {
  testWidgets('debugFillProperties', (tester) async {
    await tester.pumpWidget(
      HookBuilder(builder: (context) {
        useCreateStateNotifier(() => _TestNotifier(22));
        return const SizedBox();
      }),
    );

    final element = tester.element(find.byType(HookBuilder));

    expect(
      element
          .toDiagnosticsNode(style: DiagnosticsTreeStyle.offstage)
          .toStringDeep(),
      equalsIgnoringHashCodes(
        'HookBuilder\n'
        ' │ useCreateStateNotifier<int>: _TestNotifier(22)\n'
        ' └SizedBox(renderObject: RenderConstrainedBox#00000)\n',
      ),
    );
  });

  testWidgets('useCreateStateNotifier', (tester) async {
    _TestNotifier notifierToSupply = _TestNotifier(11);
    int callCounter = 0;
    _TestNotifier create() {
      callCounter++;
      return notifierToSupply;
    }

    _TestNotifier? lastBuiltNotifier;

    Future<void> pump() {
      return tester.pumpWidget(HookBuilder(
        builder: (context) {
          lastBuiltNotifier = useCreateStateNotifier(create) as _TestNotifier;
          return Container();
        },
      ));
    }

    await pump();
    expect(lastBuiltNotifier!.mounted, true);

    expect(lastBuiltNotifier, notifierToSupply);
    expect(callCounter, 1);

    notifierToSupply = _TestNotifier(11);
    await pump();
    lastBuiltNotifier!.increment();
    await pump();
    lastBuiltNotifier!.increment();
    lastBuiltNotifier!.increment();
    lastBuiltNotifier!.increment();
    lastBuiltNotifier!.decrement();
    await pump();

    expect(lastBuiltNotifier, isNot(notifierToSupply));
    expect(callCounter, 1);

    await tester.pumpWidget(const SizedBox());

    expect(lastBuiltNotifier, isNot(notifierToSupply));
    expect(callCounter, 1);

    expect(lastBuiltNotifier!.mounted, false);
  });
}
