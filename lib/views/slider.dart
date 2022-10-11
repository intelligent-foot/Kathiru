import 'package:flutter/material.dart';

class SliderExample extends StatefulWidget {
  final Function(double) updateValue;
  const SliderExample({Key? key, required this.updateValue});

  @override
  State<SliderExample> createState() => _SliderExampleState();
}

class _SliderExampleState extends State<SliderExample> {

   Function get _updateValue => widget.updateValue;

  double loanPeriod = 36.0;
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
       
            new Expanded(
         
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.blue[700],
                  inactiveTrackColor: Colors.blue[100],
                  trackShape: RoundedRectSliderTrackShape(),
                  trackHeight: 4.0,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  thumbColor: Colors.blueAccent,
                  overlayColor: Colors.blue.withAlpha(32),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                  tickMarkShape: RoundSliderTickMarkShape(),
                  activeTickMarkColor: Colors.blue[700],
                  inactiveTickMarkColor: Colors.blue[100],
                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                  valueIndicatorColor: Colors.blueAccent,
                  valueIndicatorTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: Slider(
                  value: loanPeriod,
                  min: 1,
                  max: 36,
                  divisions: 36,
                  label: '${loanPeriod.toStringAsFixed(0)} months',
                  onChanged: (value) {
                    setState(
                      () {
                        _updateValue(value);
                        loanPeriod = value;
                        print(loanPeriod);
                      },
                    );
                  },
                ),
              ),
            ),
          ])),
    );
  }
}

 
