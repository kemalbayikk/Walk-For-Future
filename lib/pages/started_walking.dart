import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pedometer/pedometer.dart';
import 'package:walk_for_future/pages/earn_prizes.dart';
import 'package:walk_for_future/widgets/timer_paint.dart';
import 'package:walk_for_future/widgets/user.dart';
import '../widgets/secrets.dart';

class StartedWalkingPage extends StatefulWidget {
  final int distance;
  final int duration;
  final String latitude;
  final String longtitude;
  final UserFromFirebase user;

  const StartedWalkingPage(
      {Key key,
      @required this.distance,
      @required this.duration,
      @required this.latitude,
      @required this.longtitude,
      this.user})
      : super(key: key);
  @override
  _StartedWalkingPageState createState() => _StartedWalkingPageState();
}

class _StartedWalkingPageState extends State<StartedWalkingPage>
    with TickerProviderStateMixin {
  AnimationController controller;
  int duration = 0;
  Position _currentPosition;
  Dio dio = new Dio();
  Stream<StepCount> _stepCountStream;
  String _steps = '?';
  Response response;
  int count = 0;
  int stepsFirst = 0;
  int estimatedStep = 0;
  void onStepCount(StepCount event) {
    if (count == 0) {
      setState(() {
        stepsFirst = event.steps;
      });
      calculateEstimatedFootStep();
    }
    count++;
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onStepCountError(error) {
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  calculateEstimatedFootStep() {
    setState(() {
      estimatedStep = (widget.distance / 2.1).toInt() + stepsFirst;
    });
  }

  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print("error");
      print(e);
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          controller.reverse(
              from: controller.value == 0.0 ? 1.0 : controller.value);
        }));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white10,
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.center,
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(
                              child: AnimatedBuilder(
                                animation: controller,
                                builder: (BuildContext context, Widget child) {
                                  return CustomPaint(
                                      painter: CustomTimerPainter(
                                    animation: controller,
                                    backgroundColor: Colors.white,
                                    color: themeData.indicatorColor,
                                  ));
                                },
                              ),
                            ),
                            Align(
                              alignment: FractionalOffset.center,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Count Down Timer",
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.white),
                                  ),
                                  AnimatedBuilder(
                                      animation: controller,
                                      builder:
                                          (BuildContext context, Widget child) {
                                        return Text(
                                          timerString,
                                          style: TextStyle(
                                              fontSize: 112.0,
                                              color: Colors.white),
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  /*Text(
                    'Steps taken:',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  Text(
                    _steps,
                    style: TextStyle(fontSize: 60, color: Colors.white),
                  ),
                  Divider(
                    height: 100,
                    thickness: 0,
                    color: Colors.white,
                  ),*/
                  FloatingActionButton.extended(
                      onPressed: () async {
                        _getCurrentLocation();
                        if (_currentPosition != null) {
                          response = await dio.get(
                              "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${_currentPosition.latitude},${_currentPosition.longitude}&destinations=${widget.latitude}%2C${widget.longtitude}&mode=walking&key=${Secrets.API_KEY}");

                          var distance = response.data["rows"][0]["elements"][0]
                              ["distance"]["value"];
                          int stepCount = estimatedStep - int.parse(_steps);
                          double time = controller.value;
                          int prizeCount = (distance / 10).toInt();

                          if (response.data != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EarnPrizesPage(
                                        time: time,
                                        distance: distance,
                                        user: widget.user,
                                        prizeCount: prizeCount,
                                        stepCount: stepCount,
                                      )),
                            );
                          }
                        }
                      },
                      label: Text("Finish Walking and Earn Prize")),
                  /*Text(
                    " dist: ${widget.distance} est step: ${estimatedStep} ${controller.value}",
                    style: TextStyle(color: Colors.white),
                  ),*/
                ],
              ),
            );
          }),
    );
  }
}
