import 'package:flutter/material.dart';
import 'package:notes/Utilities/show_generic_dialog.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog<bool>(
      context: context,
       title: "Log Out",
        content: "are you sure You want to log out",
         option: ()=>{
        'cancel': false,
        'logout':true
      },).then((value) => value ?? false);
}
