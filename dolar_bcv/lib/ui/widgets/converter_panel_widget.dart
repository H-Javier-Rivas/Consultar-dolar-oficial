import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/converter_viewmodel.dart';
import '../theme/app_theme.dart';

class ConverterPanelWidget extends StatelessWidget {
  const ConverterPanelWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ConverterViewModel>();

    return Column(
      children: [
        // Input y Toggles
        GlassBox(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              TextField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.sp, color: Colors.white),
                decoration: InputDecoration(
                  hintText: '💰 Ingresa monto',
                  hintStyle: TextStyle(color: AppTheme.textMuted, fontSize: 16.sp),
                  filled: true,
                  fillColor: const Color(0x0DFFFFFF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppTheme.glassBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppTheme.primary),
                  ),
                ),
                onChanged: (val) => viewModel.updateInput(val),
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0x0DFFFFFF),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _CurrencyToggle(
                      title: 'Bs.',
                      isSelected: viewModel.isBsMode,
                      onTap: () {
                        if (!viewModel.isBsMode) viewModel.toggleCurrencyMode();
                      },
                    ),
                    SizedBox(width: 32.w),
                    _CurrencyToggle(
                      title: 'USD \$',
                      isSelected: !viewModel.isBsMode,
                      onTap: () {
                        if (viewModel.isBsMode) viewModel.toggleCurrencyMode();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        
        // Subtotal y Botones Acción
        Text(
          'Subtotal: Bs. \${viewModel.computedSubtotalBs.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 20.sp,
            color: AppTheme.textMuted,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ActionButton(
              icon: Icons.remove,
              onTap: () => viewModel.subtractFromTotal(),
            ),
            SizedBox(width: 24.w),
            Text('🛒', style: TextStyle(fontSize: 24.sp)),
            SizedBox(width: 24.w),
            _ActionButton(
              icon: Icons.add,
              onTap: () => viewModel.addToTotal(),
            ),
          ],
        ),
      ],
    );
  }
}

class _CurrencyToggle extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _CurrencyToggle({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Radio<bool>(
            value: true,
            groupValue: isSelected,
            onChanged: (_) => onTap(),
            activeColor: AppTheme.primary,
          ),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: isSelected ? Colors.white : AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Ensuring touch target is at least 48x48
    return SizedBox(
      width: 56.w, 
      height: 56.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
          padding: EdgeInsets.zero,
        ),
        onPressed: onTap,
        child: Icon(icon, color: Colors.white, size: 28.sp),
      ),
    );
  }
}
