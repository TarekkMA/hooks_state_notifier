import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:state_notifier/state_notifier.dart';

typedef CreateStateNotifier<T extends StateNotifier> = T Function();

/// Creates a memoized [StateNotifier] instance via [create], dispose it when
/// the widget disposes.
T useCreateStateNotifier<T extends StateNotifier>(
    CreateStateNotifier<T> create) {
  return use(_CreateStateNotifierHook(create));
}

class _CreateStateNotifierHook<T extends StateNotifier> extends Hook<T> {
  final CreateStateNotifier<T> create;

  const _CreateStateNotifierHook(this.create);

  @override
  _CreateStateNotifierHookState<T> createState() =>
      _CreateStateNotifierHookState();
}

class _CreateStateNotifierHookState<T extends StateNotifier>
    extends HookState<T, _CreateStateNotifierHook<T>> {
  late final T notifier = hook.create();

  @override
  T build(BuildContext context) => notifier;

  @override
  void dispose() {
    super.dispose();
    notifier.dispose();
  }

  @override
  String get debugLabel => 'useCreateStateNotifier<$T>';
}
