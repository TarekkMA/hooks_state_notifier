import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:state_notifier/state_notifier.dart';

/// Subscribes to a [StateNotifier] and mark the widget as needing build
/// whenever the state is changed.
T useStateNotifer<T>(StateNotifier<T> stateNotifer) {
  return use(_StateNotiferHook<T>(stateNotifer));
}

class _StateNotiferHook<T> extends Hook<T> {
  const _StateNotiferHook(this.stateNotifier);

  final StateNotifier<T> stateNotifier;

  @override
  _ListenableStateHook<T> createState() => _ListenableStateHook<T>();
}

class _ListenableStateHook<T> extends HookState<T, _StateNotiferHook<T>> {
  RemoveListener? _removeListenerCallback;
  late T _currentState;

  @override
  void initHook() {
    super.initHook();
    _addListener();
  }

  @override
  void didUpdateHook(_StateNotiferHook<T> oldHook) {
    super.didUpdateHook(oldHook);
    if (hook.stateNotifier != oldHook.stateNotifier) {
      _removeListner();
      _addListener();
    }
  }

  @override
  T build(BuildContext context) => _currentState;

  void _listener(state) {
    setState(() {
      _currentState = state;
    });
  }

  void _addListener() {
    _removeListenerCallback = hook.stateNotifier.addListener(
      _listener,
      fireImmediately: true, // ensures that [_currentState] will be initlized
    );
  }

  void _removeListner() {
    _removeListenerCallback?.call();
  }

  @override
  void dispose() {
    _removeListner();
  }

  @override
  String get debugLabel => 'useStateNotifer';

  @override
  Object? get debugValue => hook.stateNotifier;
}
