import 'package:flutter/material.dart';
import 'package:project_boilerplate/utils/widgets/widget_models.dart';
import '../../utils/constants/colors.dart';

InputDecoration inputDecorationModel(IconData prefixIcon, String lblText, AsyncSnapshot snapshot,
    {IconData suffixIcon, bool isSuffix = false, String hintText, bloc, bool seen}) {
  return InputDecoration(
    hasFloatingPlaceholder: false,
    labelText: lblText,
    fillColor: Colors.white,
    filled: true,
    suffixIcon: isSuffix
        ? GestureDetector(
      child: Icon(
        suffixIcon,
        color: SwatchColor.kLightBlueGreen,
      ),
      onTap: () {
        bloc.seenSink.add(!seen);
      },
    )
        : null,
    prefixIcon: Icon(
      prefixIcon,
      color: SwatchColor.kLightBlueGreen,
    ),
    errorStyle: dynamicTextStyle(color: Colors.red),
    errorText: snapshot.error,
    enabledBorder: OutlineInputBorder(
        borderSide:
        BorderSide(color: Colors.white, style: BorderStyle.solid)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: SwatchColor.kLightBlueGreen,
        ),
        borderRadius: BorderRadius.all(Radius.circular(4))),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.all(Radius.circular(4))),
    hintText: hintText,
  );
}