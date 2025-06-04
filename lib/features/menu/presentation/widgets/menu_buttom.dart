import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sorteio_55_tech/config/theme_colors.dart';

class MenuButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const MenuButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Center(
        child: SizedBox(
          width: 240.w, // Largura reduzida
          height: 32.h, // Altura achatada
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.afinzAccent,
              textStyle: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            onPressed: onPressed,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
