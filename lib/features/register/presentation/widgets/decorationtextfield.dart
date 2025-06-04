import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
InputDecoration inputDecoration(String label) {
  return InputDecoration(
    hintText: label,
    hintStyle: TextStyle(
      color: Colors.white70,
      fontSize: 16.sp,
    ),
    filled: true,
    fillColor: const Color(0xFF2C2C2C),
    contentPadding: EdgeInsets.symmetric(
      horizontal: 20.w,
      vertical: 18.h,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide.none, // sem borda quando não focado
      borderRadius: BorderRadius.circular(12.r),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.green, width: 1.5.w),
      borderRadius: BorderRadius.circular(12.r),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(12.r),
    ),
  );
}

