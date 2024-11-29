import 'package:flutter/material.dart';
import 'package:notes/Utilities/show_generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
      context: context,
       title: "Delete",
        content: "are you sure You want to delete this note",
         option: ()=>{
        'cancel': false,
        'yes':true
      },).then((value) => value ?? false);
}
