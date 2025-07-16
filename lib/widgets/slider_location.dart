import 'package:flutter/material.dart';

class SliderLocation extends StatefulWidget {
  final Function(double)? onChanged;
  const SliderLocation({super.key, this.onChanged});

  @override
  State<SliderLocation> createState() => _SliderLocationState();
}

class _SliderLocationState extends State<SliderLocation> {
  double _value = 0;
  final double _min = 0;
  final double _max = 400;

  @override
  Widget build(BuildContext context) {
    const double sliderWidth = 350;

    double percent = (_value - _min) / (_max - _min);
    double indicatorLeft = percent * (sliderWidth - 32);

    return SizedBox(
      width: sliderWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Slider(
                value: _value,
                min: _min,
                max: _max,
                activeColor: Color(0xFFF5BBEC),
                onChanged: (newValue) {
                  setState(() {
                    _value = newValue;
                  });
                  if (widget.onChanged != null){
                    widget.onChanged!(newValue);
                  }
                },
              ),
              Positioned(
                left: indicatorLeft,
                top: 36,

                child: Container(
                  width: 40,
                  alignment: Alignment.center,
                  child: Text(
                    _value.toStringAsFixed(0),
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFD593F7),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
