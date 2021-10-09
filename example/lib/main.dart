import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_state_notifier/hooks_state_notifier.dart';
import 'package:state_notifier/state_notifier.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends HookWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const Center(child: ReadMeExample()),
    );
  }
}

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  void increment() => state++;
  void decrement() => state--;
}

class ReadMeExample extends HookWidget {
  const ReadMeExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = useCreateStateNotifier(() => CounterNotifier());
    final state = useStateNotifier(notifier);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkResponse(
          onTap: notifier.increment,
          child: const Icon(Icons.add),
        ),
        Text(
          '$state',
          style: const TextStyle(fontSize: 30),
        ),
        InkResponse(
          onTap: notifier.decrement,
          child: const Icon(Icons.remove),
        ),
      ],
    );
  }
}
