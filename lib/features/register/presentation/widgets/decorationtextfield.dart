import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sorteio_55_tech/config/theme_colors.dart';
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
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(12.r),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.afinzAccent, width: 1.5.w),
      borderRadius: BorderRadius.circular(12.r),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1.5.w),
      borderRadius: BorderRadius.circular(12.r),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent, width: 1.5.w),
      borderRadius: BorderRadius.circular(12.r),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(12.r),
    ),
    errorStyle: TextStyle(
      color: Colors.redAccent,
      fontSize: 13.sp,
    ),
  );
}
