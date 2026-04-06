import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/converter_viewmodel.dart';
import '../theme/app_theme.dart';

class RateCardWidget extends StatelessWidget {
  const RateCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Escucha cambios en ConverterViewModel
    final viewModel = context.watch<ConverterViewModel>();

    String title;
    switch (viewModel.activeSource) {
      case RateSource.bcv:
        title = 'Tasa Oficial BCV';
        break;
      case RateSource.usdt:
        title = 'Tasa USDT (Paralelo)';
        break;
      case RateSource.custom:
        title = 'Tasa Personalizada';
        break;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppTheme.primary.withAlpha(26),
        border: Border.all(color: AppTheme.primary.withAlpha(51)),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.getTextMuted(context),
                ),
              ),
              if (viewModel.isOffline && viewModel.activeSource != RateSource.custom) ...[
                SizedBox(width: 8.w),
                Icon(Icons.wifi_off, color: AppTheme.secondary, size: 16.sp),
              ]
            ],
          ),
          SizedBox(height: 4.h),
          viewModel.isLoading && viewModel.activeSource != RateSource.custom
              ? SizedBox(
                  height: 24.h,
                  width: 24.h,
                  child: const CircularProgressIndicator(color: AppTheme.primary, strokeWidth: 2),
                )
              : Text(
                  "Bs. ${viewModel.currentRate.toStringAsFixed(4)}",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
        ],
      ),
    );
  }
}
