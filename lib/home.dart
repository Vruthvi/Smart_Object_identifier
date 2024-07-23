import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:object_detection/about.dart';
import 'package:object_detection/detect_screen.dart';
import 'models.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<CameraDescription> cameras;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setupCameras();
  }

  loadModel(model) async {
    String? res;
    switch (model) {

      case mobilenet:
        res = await Tflite.loadModel(
            model: "assets/mobilenet_v1_1.0_224.tflite",
            labels: "assets/mobilenet_v1_1.0_224.txt");
        break;

      case mobilenet2:
        res = await Tflite.loadModel(
            model: "assets/mobilenet_v2_fine_tuned11.tflite",
            labels: "assets/mobilenet_v2_fine_tuned11.txt");
        break;

      case posenet:
        res = await Tflite.loadModel(
            model: "assets/posenet_mv1_075_float_from_checkpoints.tflite");
        break;

      default:
        res = await Tflite.loadModel(
            model: "assets/ssd_mobilenet.tflite",
            labels: "assets/ssd_mobilenet.txt");
    }
    log("$res");
  }

  onSelect(model) {
    loadModel(model);
    final route = MaterialPageRoute(builder: (context) {
      return DetectScreen(cameras: cameras, model: model);
    });
    Navigator.of(context).push(route);
  }

  setupCameras() async {
    try {
      cameras = await availableCameras();
      setState(() {});
    } on CameraException catch (e) {
      log('Error: $e.code\nError Message: $e.message');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 3, 4, 94)),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.55,
            child: Container(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.1),
                  child: Text(
                    'Smart Object Detection',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.60,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(top: 45),
              child: const Text(
                'Choose an Option',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 243, 91, 4),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 30,
            right: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    FloatingActionButton(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      onPressed: () => onSelect(ssd),
                      child: const Icon(Icons.camera_alt, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Model-A',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    FloatingActionButton(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      onPressed: () => onSelect(mobilenet2),
                      child:
                          const Icon(Icons.electric_bolt, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Model-B',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    FloatingActionButton(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const InstructionPage()),
                        );
                      },
                      child: const Icon(Icons.info, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Instruction',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                icon: Image.asset(
                  'assets/menu_icon.gif',
                  width: 30,
                  height: 30,
                ),
              ),
              title: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Image.asset(
                          'assets/logo.png',
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'EXPERIMIND LABS',
                      style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              automaticallyImplyLeading: true,
              centerTitle: true,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        width: 270,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 3, 4, 94),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 150,
                  padding: const EdgeInsets.only(left: 16.0),
                  child: const Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Color.fromARGB(255, 243, 91, 4)),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outlined, color: Color.fromARGB(255, 243, 91, 4)),
              title: const Text('About'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const About()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class InstructionPage extends StatelessWidget {
  const InstructionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instructions',style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: const Color.fromARGB(255, 3, 4, 94),
        elevation: 0,
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
              Text(
              '1. Choose the Model.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '2. Model-A,detects the real world objects.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '3. Model-B,detects the electronic components.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '4. Calibrate your device phone.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '5. It will detect objects around you.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
