import 'package:barista/shared/components/default_text.dart';
import 'package:flutter/material.dart';

import '../styles/colors.dart';

/*
class RadioWidget extends StatelessWidget {
  const RadioWidget({
    super.key,
    required this.radio1,
    required this.radio2,
  });
  final String groupValue = '';
  final String radio1;
  final String radio2;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: Radio(
                    activeColor: kPrimaryColor,
                    value: widget.radio1,
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() {
                        groupValue = value.toString();
                      });
                    }),
              ),
              DefaultText(
                  text: widget.radio1, textSize: 14, textColor: kBodyTextColor),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: Radio(
                    activeColor: kPrimaryColor,
                    value: widget.radio2,
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() {
                        groupValue = value.toString();
                      });
                    }),
              ),
              DefaultText(
                  text: widget.radio2, textSize: 14, textColor: kBodyTextColor),
            ],
          ),
        ),
      ],
    );
  }
}
*/
class RadioWidget extends StatefulWidget {
  final List<String> options;
  final Function(String) onChanged;
  final String selectedOption;

  const RadioWidget({super.key, 
    required this.options,
    required this.onChanged,
    required this.selectedOption,
  });

  @override
  State<RadioWidget> createState() => _RadioWidgetState();
}

class _RadioWidgetState extends State<RadioWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.options.map((option) {
        return Expanded(
          child: Row(
            children: [
              Radio(
                activeColor: kPrimaryColor,
                value: option,
                groupValue: widget.selectedOption,
                onChanged: (value) {
                  setState(() {
                    widget.onChanged(value!);
                  });
                },
              ),
              DefaultText(
                  text: option, textSize: 14, textColor: kBodyTextColor),
            ],
          ),
        );
      }).toList(),
    );
  }
}
