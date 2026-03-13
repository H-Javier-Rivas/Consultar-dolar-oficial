import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/converter_viewmodel.dart';
import '../theme/app_theme.dart';

class TotalsPanelWidget extends StatelessWidget {
  const TotalsPanelWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ConverterViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(color: AppTheme.glassBorder, height: 48),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Total a pagar',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Text(
              '\$ \${viewModel.totalUsd.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.secondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text(
          viewModel.totalBs.toStringAsFixed(2),
          style: TextStyle(
            fontSize: 48.sp,
            fontWeight: FontWeight.w700,
            color: AppTheme.primary,
          ),
        ),
        SizedBox(height: 24.h),
        SizedBox(
          height: 56.h,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0x1AEF4444), // rgba(239, 68, 68, 0.1)
              foregroundColor: AppTheme.error,
              side: const BorderSide(color: Color(0x33EF4444)), // rgba(239, 68, 68, 0.2)
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            icon: const Text('💸', style: TextStyle(fontSize: 20)),
            label: Text(
              'Limpiar Todo',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: AppTheme.bgCard,
                  title: const Text('Confirmar', style: TextStyle(color: Colors.white)),
                  content: const Text('¿Seguro que quieres limpiar todo?', style: TextStyle(color: AppTheme.textMuted)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancelar', style: TextStyle(color: AppTheme.primary)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Limpiar', style: TextStyle(color: AppTheme.error)),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                viewModel.clearAll();
              }
            },
          ),
        ),
      ],
    );
  }
}
