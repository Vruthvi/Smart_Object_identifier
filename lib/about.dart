import 'package:flutter/material.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About',style:TextStyle(fontWeight:FontWeight.bold),),
        automaticallyImplyLeading: true,
        centerTitle: true,
      ),
      body: Center(
        child:Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width,
              child:const Text('About The Smart Product Detection',style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width,
              child:const Text("At Smart Object Detection, we revolutionize how objects are identified and tracked using advanced AI and machine learning.\n\n Our mission is to enhance safety, productivity, and convenience across various industries with precise, real-time object detection.\n\n Our technology powers security systems, autonomous vehicles, manufacturing processes, and retail environments with unparalleled accuracy and adaptability. We are committed to continuous innovation, delivering high-precision solutions that minimize errors. With versatile applications and comprehensive support, we strive to make the world smarter and safer. Join us in advancing the future of technology.",style: TextStyle(letterSpacing: 1,wordSpacing: 1),),
            ),
          ],
        )
      ),
    );
  }
}
