import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

typedef void SelectColor(Color color);

class ColorSelector extends StatefulWidget {
  final Color initColor;
  final SelectColor selectColor;

  ColorSelector({@required this.initColor, @required this.selectColor});

  @override
  _ColorSelectorState createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  Color selectedColor;

  @override
  void initState() {
    selectedColor = widget.initColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Pick color"),
      content: SingleChildScrollView(
        child: ColorPicker(
          enableAlpha: false,
          pickerColor: selectedColor,
          onColorChanged: (c) {
            setState(() {
              selectedColor = c;
            });
          },
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text("ok"),
          onPressed: () {
            widget.selectColor(selectedColor);
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
