import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'paint.dart';
// ignore: camel_case_types
class Sorting_Visualizer extends StatefulWidget {
  @override
  _Sorting_VisualizerState createState() => _Sorting_VisualizerState();
}

// ignore: camel_case_types
class _Sorting_VisualizerState extends State<Sorting_Visualizer> {
  String dropdownValue = 'Bubble';
  List<int> _numbers = [0];
  StreamController<List<int>> _streamController = StreamController();
  int _sampleSize = 320;
  @override
  void initState() {
    _randomization();
    super.initState();
  }
  _sort() async{
    int temp;
    for(int i =0; i < _numbers.length; ++i){
      for(int j = 0; j < _numbers.length-1; ++j){
        if(_numbers[j] > _numbers[j+1])
          {
            temp = _numbers[j];
            _numbers[j] = _numbers[j+1];
            _numbers[j+1] = temp;
          }
        await Future.delayed(Duration(microseconds: 500));
        setState(() {});
      }
    }
    for(int i =0; i < _numbers.length; ++i)
      print(_numbers[i].toString() + " ");
  }
  _randomization(){
    _numbers.clear();
    for(int i = 0; i < _sampleSize; ++i)
      _numbers.add(Random().nextInt(_sampleSize));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sorting'),
        actions: <Widget>[
          DropdownButton<String>(
            value: dropdownValue,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: <String>['Bubble', 'Selection', 'Merge', 'Quick']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            Expanded(
              child: FlatButton(
                child: Text('Randomize'),
                onPressed: (){
                  setState(() {
                    _randomization();
                  });
                },
              ),
            ),
            Expanded(
              child: FlatButton(
                child: Text('Sort'),
                onPressed: (){
                  setState(() {
                    _sort();
                  });
                },
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 0.0),
          child: StreamBuilder<Object>(
              initialData: _numbers,
              stream: _streamController.stream,
              builder: (context, snapshot) {
                List<int> numbers = snapshot.data;
                int counter = 0;
                return Row(
                  children: numbers.map((int num) {
                    counter++;
                    return Container(
                      child: CustomPaint(
                        painter: BarPainter(index: counter, value: num, width: MediaQuery.of(context).size.width / _sampleSize),
                      ),
                    );
                  }).toList(),
                );
              }),
        ),
      ),
    );
  }
}
