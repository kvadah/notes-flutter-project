import 'package:flutter/material.dart';
import 'package:notes/Utilities/show_generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text) async {
  return showGenericDialog(
    context: context,
    title: "an Error occured",
    content: text,
    option: ()=>{
      'OK':null
    },
  );
}
