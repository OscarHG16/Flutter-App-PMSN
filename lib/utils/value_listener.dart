import 'package:flutter/cupertino.dart';

class ValueListener {
  // Usamos ValueNotifier para manejar el estado del tema 
  static ValueNotifier<bool> isDark = ValueNotifier<bool>(true); //con static porque es una variable global
}