import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sorteio_55_tech/config/theme_colors.dart';

InputDecoration inputDecoration(String label) {
  return InputDecoration(
    hintText: label,
    hintStyle: TextStyle(
      color: Colors.white70,
      fontSize: 11.sp,
    ),
    filled: true,
    fillColor: const Color(0xFF2C2C2C),
    contentPadding: EdgeInsets.symmetric(
      horizontal: 12.w,
      vertical: 6.h,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(8.r),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.afinzAccent, width: 1.w),
      borderRadius: BorderRadius.circular(8.r),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1.w),
      borderRadius: BorderRadius.circular(8.r),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent, width: 1.w),
      borderRadius: BorderRadius.circular(8.r),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(8.r),
    ),
    errorStyle: TextStyle(
      color: Colors.redAccent,
      fontSize: 9.sp,
    ),
  );
}
