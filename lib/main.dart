import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jellyview/utils/jelly_configurations.dart';
import 'package:jellyview/utils/my_jelly_paint.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blue));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JellyView',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

List<JellyConfiguration> createJellies(
    BuildContext context, int jellyCount, int steps, Size size) {
  List<JellyConfiguration> jellyConfigurations = List();
  for (int i = 0; i < jellyCount; i++) {
    jellyConfigurations.add(JellyConfiguration(size,
        position: i, reductionRadiusFactor: 1.5 - ((i + 1) / jellyCount)));
  }
  return jellyConfigurations;
}

class _HomeState extends State<Home> {
  int jellyCount = 4;
  int steps = 16;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            SizedBox.fromSize(
                size: Size(400, 400),
                child: MyHomePage(jellyCount, steps, size)),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        jellyCount = jellyCount + 1;
                      });
                    },
                    child: Text("Increase Layer"),
                  ),
                  SizedBox.fromSize(size: Size(10, 10)),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        jellyCount = 1;
                      });
                    },
                    child: Text("Reset"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final int steps;
  final Size size;
  final int jellyCount;

  MyHomePage(this.jellyCount, this.steps, this.size);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List<JellyConfiguration> jellyConfigurations;

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        _controller.repeat();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    jellyConfigurations =
        createJellies(context, widget.jellyCount, widget.steps, widget.size);
    return new AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget child) {
          return CustomPaint(
              painter: JellyPaint(
            animation: _controller,
            jellyConfigurations: jellyConfigurations,
          ));
        });
  }
}
