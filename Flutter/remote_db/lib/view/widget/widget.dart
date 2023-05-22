import 'package:flutter/material.dart';

class Widgets {
  static inputDecorations(String titulo) {
    return InputDecoration(
      labelText: titulo,
      contentPadding: const EdgeInsets.all(10),
      border: const OutlineInputBorder(),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.deepPurple),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.deepPurple),
      ),
      labelStyle: const TextStyle(fontFamily: 'Montserrat', color: Colors.grey),
    );
  }

  static textLabelInput() {
    return const TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: Colors.black87,
      overflow: TextOverflow.ellipsis,
    );
  }

  static elevatedButtonPrimary() {
    return ElevatedButton.styleFrom(
      elevation: 0,
      padding: const EdgeInsets.all(5),
      foregroundColor: const Color(0xFF4C53A5),
      side: BorderSide(color: const Color(0xFF4C53A5).withOpacity(0.08)),
      backgroundColor: const Color(0xFF4C53A5).withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      shadowColor: Colors.white,
    );
  }

  static elevatedButtonSuccess() {
    return ElevatedButton.styleFrom(
      elevation: 0,
      padding: const EdgeInsets.all(5),
      foregroundColor: const Color(0xFF00C853),
      side: BorderSide(color: const Color(0xFF00C853).withOpacity(0.08)),
      backgroundColor: const Color(0xFF00C853).withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      shadowColor: Colors.white,
    );
  }

  static elevatedButtonWarning() {
    return ElevatedButton.styleFrom(
      elevation: 0,
      padding: const EdgeInsets.all(5),
      foregroundColor: const Color(0xFFff9800),
      side: BorderSide(color: const Color(0xFFff9800).withOpacity(0.08)),
      backgroundColor: const Color(0xFFff9800).withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  static elevatedButtonError() {
    return ElevatedButton.styleFrom(
      elevation: 0,
      padding: const EdgeInsets.all(5),
      foregroundColor: const Color(0xFFf44336),
      side: BorderSide(color: const Color(0xFFf44336).withOpacity(0.08)),
      backgroundColor: const Color(0xFFf44336).withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  static SnackBar snackBar(String tipo, String text) {
    Color? color;
    if (tipo == "success") {
      color = const Color(0xff00d897);
    }
    if (tipo == "error") {
      color = const Color(0xffE8313D);
    } else if (tipo == "warning") {
      color = color = const Color(0xffF99638);
    } else if (tipo == "") {
      color = const Color(0xff00d897);
    }

    return SnackBar(
      elevation: 10,
      duration: const Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
      padding: const EdgeInsets.all(8.0),
      content: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
      ),
      action: SnackBarAction(
        textColor: Colors.white,
        label: 'X',
        onPressed: () {},
      ),
      backgroundColor: color,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
    );
  }
}
