
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:petitparser/petitparser.dart';

void main() => runApp(
  DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => MyApp(), // Wrap your app
  ),
);

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromRGBO(23, 32, 52, 1) 
      ),
      home: HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({ Key? key }) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String values = ' ';
  double answer = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(45.0) ,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "$answer",
              style: TextStyle(
                fontSize: 100.0, color: Colors.purple
              ),
            ),
            Text(
              values,
            style: TextStyle(
              fontSize: 40.0, color: Colors.white70
            ),
            ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
                   KeyPadWidget(
             label: 'AC',
             backgroundColor: Colors.yellow,
             ontap: (){
               setState(() {
                 values = '';
                 answer = 0.0;
               });
             }),
           KeyPadWidget(
             label: 'DEL',
             backgroundColor: Colors.red,
             ontap: (){
               setState(() {
                 int value =  values.length -1;
                 values = values.substring(0, value);
               });
             })
         ]),
          SizedBox(
             height: 25,
           ),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
               KeyPadWidget(label: '7',
               backgroundColor: Colors.white,
               ontap: (){
                 setState((){
                   values = values + '7';
                 });
               },
               ),
               KeyPadWidget(label: '8',
               backgroundColor: Colors.white,
               ontap: (){
                 setState((){
                   values = values + '8';
                 });
               },
               ),
               KeyPadWidget(label: '9',
               backgroundColor: Colors.white,
               ontap: (){
                 setState((){
                   values = values + '9';
                 });
               },
               ),
               KeyPadWidget(label: '+',
               backgroundColor: Colors.blueAccent,
               ontap: (){
                 setState((){
                   values = values + '+';
                 });
               },
               ),
             ],
           ),
           SizedBox(
             height: 25,
           ),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
               KeyPadWidget(label: '4',
               backgroundColor: Colors.white,
               ontap: (){
                 setState((){
                   values = values + '4';
                 });
               },
               ),KeyPadWidget(label: '5',
               backgroundColor: Colors.white,
               ontap: (){
                 setState((){
                   values = values + '5';
                 });
               },
               ),KeyPadWidget(label: '6',
               backgroundColor: Colors.white,
               ontap: (){
                 setState((){
                   values = values + '6';
                 });
               },
               ),KeyPadWidget(label: '-',
               backgroundColor: Colors.blueAccent,
               ontap: (){
                 setState((){
                   values = values + '-';
                 });
               },
               ),
             ],
           ),
           SizedBox(
             height: 25,
           ),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
               KeyPadWidget(label: '1',
               backgroundColor: Colors.white,
               ontap: (){
                 setState((){
                   values = values + '1';
                 });
               },
               ),KeyPadWidget(label: '2',
               backgroundColor: Colors.white,
               ontap: (){
                 setState((){
                   values = values + '2';
                 });
               },
               ),KeyPadWidget(label: '3',
               backgroundColor: Colors.white,
               ontap: (){
                 setState((){
                   values = values + '3';
                 });
               },
               ),KeyPadWidget(label: 'x',
               backgroundColor: Colors.blueAccent,
               ontap: (){
                 setState((){
                   values = values + 'x';
                 });
               },
               ),
             ],
           ),
           SizedBox(
             height: 25,
           ),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
               KeyPadWidget(label: '0',
               backgroundColor: Colors.white,
               ontap: (){
                 setState((){
                   values = values + '0';
                 });
               },
               ),KeyPadWidget(label: '.',
               backgroundColor: Colors.blueAccent,
               ontap: (){
                 setState((){
                   if (values.isEmpty) {
                              values = values + '0.';
                            } else if (!values.contains('.')) {
                              values = values + '.';
                            }
                 });
               },
               ),KeyPadWidget(label: '/',
               backgroundColor: Colors.blueAccent,
               ontap: (){
                 setState((){   
                   values = values + '/';
                 });
               },
               ),KeyPadWidget(label: '=',
               backgroundColor: Colors.deepOrange,
               ontap: (){
         print(values);

                            Parser buildParser() {
                              final builder = ExpressionBuilder();
                              builder.group()
                                ..primitive((pattern('+-').optional() &
                                        digit().plus() &
                                        (char('.') & digit().plus())
                                            .optional() &
                                        (pattern('eE') &
                                                pattern('+-').optional() &
                                                digit().plus())
                                            .optional())
                                    .flatten('number expected')
                                    .trim()
                                    .map(num.tryParse))
                                ..wrapper(char('(').trim(), char(')').trim(),
                                    (left, value, right) => value);
                              builder
                                  .group()
                                  .prefix(char('-').trim(), (op, num a) => -a);
                              builder.group().right(char('^').trim(),
                                  (num a, op, num b) => pow(a, b));
                              builder.group()
                                ..left(char('x').trim(),
                                    (num a, op, num b) => a * b)
                                ..left(char('/').trim(),
                                    (num a, op, num b) => a / b);
                              builder.group()
                                ..left(char('+').trim(),
                                    (num a, op, num b) => a + b)
                                ..left(char('-').trim(),
                                    (num a, op, num b) => a - b);
                              return builder.build().end();
                            }

                            final parser = buildParser();

                            final result = parser.parse(values);

                            setState(() {
                              answer = double.parse('${result.value}');
                            });
                            print('parser: $result');
                           
                            print(values.split(RegExp('[^+-x//]+')));
                  },),
               
               
             ],
           ),
           SizedBox(
             height: 25,
           ),
         ],
       )
          ),
        ), 
      );
    
  }
}

class KeyPadWidget extends StatelessWidget {
  KeyPadWidget(
    {required this.label,
    required this.backgroundColor,
    required this.ontap}
    );

  final String label;
  final backgroundColor;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(25),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        )
      ),
      onPressed: ontap,
      child: Text(
        label, 
        style: TextStyle(
          color: Colors.black, fontSize: 40
        ),
      ));
  }
}
