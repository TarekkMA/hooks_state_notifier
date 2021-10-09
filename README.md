# StateNotifier Hook

![build workflow](https://github.com/TarekkMA/hooks_state_notifier/actions/workflows/build.yml/badge.svg)
[![codecov](https://codecov.io/gh/TarekkMA/hooks_state_notifier/branch/master/graph/badge.svg?token=7EP6J440H0)](https://codecov.io/gh/TarekkMA/hooks_state_notifier)


This package provides a `useStateNotifier` hook similar to `useValueListenable`.

## Usage

```dart
// 1. Create your state notifier as usual.
class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  void increment() => state++;
  void decrement() => state--;
}

// 2. Extend hook widget
class ReadMeExample extends HookWidget {
  const ReadMeExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 3. Create your notifier
    final notifier = useMemoized(() => CounterNotifier());
    // 4. Don't forget to dispose it
    useEffect(() => () => notifier.dispose(), []);
    // 5. Listen to your state
    final state = useStateNotifier(notifier);
    
    //......
  }
}
```