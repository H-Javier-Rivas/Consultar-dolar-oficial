import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/converter_viewmodel.dart';
import '../theme/app_theme.dart';

class RateCardWidget extends StatelessWidget {
  const RateCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Escucha cambios en ConverterViewModel
    final viewModel = context.watch<ConverterViewModel>();

    return Container(
      margin: EdgeInsets.only(bottom: 32.h),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
      decoration: BoxDecoration(
        color: const Color(0x1A10B981), // rgba(16, 185, 129, 0.1)
        border: Border.all(color: const Color(0x3310B981)), // rgba(16, 185, 129, 0.2)
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tasa Oficial BCV',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.textMuted,
                ),
              ),
              if (viewModel.isOffline) ...[
                SizedBox(width: 8.w),
                Icon(Icons.wifi_off, color: AppTheme.secondary, size: 16.sp),
              ]
            ],
          ),
          SizedBox(height: 4.h),
          viewModel.isLoading
              ? SizedBox(
                  height: 32.h,
                  width: 32.h,
                  child: const CircularProgressIndicator(color: AppTheme.primary),
                )
              : Text(
                  "Bs. \${viewModel.exchangeRate?.promedio.toStringAsFixed(4) ?? '---'}",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
        ],
      ),
    );
  }
}
