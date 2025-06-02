import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

InputDecoration inputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: TextStyle(
      color: Colors.white,
      fontSize: 16.sp,
    ),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    filled: true,
    fillColor: const Color(0xFF2C2C2C), 
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(12.r),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.green, width: 1.5),
      borderRadius: BorderRadius.circular(12.r),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
    ),
  );
}
