import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/converter_viewmodel.dart';
import '../theme/app_theme.dart';

class ConverterPanelWidget extends StatelessWidget {
  const ConverterPanelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ConverterViewModel>();

    return Column(
      children: [
        // Selector de Fuente de Tasa
        GlassBox(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fuente de la tasa:',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.getTextMuted(context),
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.isDark(context) ? Colors.white.withAlpha(13) : Colors.black.withAlpha(13),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: SegmentedButton<RateSource>(
                  segments: const [
                    ButtonSegment(value: RateSource.bcv, label: Text('BCV'), icon: Icon(Icons.account_balance)),
                    ButtonSegment(value: RateSource.usdt, label: Text('USDT'), icon: Icon(Icons.currency_bitcoin)),
                    ButtonSegment(value: RateSource.custom, label: Text('Propia'), icon: Icon(Icons.edit)),
                  ],
                  selected: {viewModel.activeSource},
                  onSelectionChanged: (Set<RateSource> selection) {
                    viewModel.setRateSource(selection.first);
                  },
                  showSelectedIcon: false,
                  style: SegmentedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    selectedBackgroundColor: AppTheme.secondary.withAlpha(204),
                    selectedForegroundColor: Colors.black,
                    foregroundColor: AppTheme.getTextMuted(context),
                    side: BorderSide.none,
                    textStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                ),
              ),
              if (viewModel.activeSource == RateSource.custom) ...[
                SizedBox(height: 12.h),
                TextField(
                  controller: viewModel.customRateController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(fontSize: 16.sp, color: AppTheme.getTextMain(context)),
                  decoration: InputDecoration(
                    hintText: 'Ingresa tasa manual',
                    hintStyle: TextStyle(color: AppTheme.getTextMuted(context), fontSize: 14.sp),
                    prefixIcon: const Icon(Icons.edit_note, color: AppTheme.secondary),
                    filled: true,
                    fillColor: AppTheme.isDark(context) ? Colors.white.withAlpha(8) : Colors.black.withAlpha(8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide.none),
                  ),
                  onChanged: (val) => viewModel.updateCustomRate(val),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // Input y Toggles de Moneda
        GlassBox(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              TextField(
                controller: viewModel.inputController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.sp, color: AppTheme.getTextMain(context)),
                decoration: InputDecoration(
                  hintText: '💰 Ingresa monto',
                  hintStyle: TextStyle(color: AppTheme.getTextMuted(context), fontSize: 16.sp),
                  filled: true,
                  fillColor: AppTheme.isDark(context) ? Colors.white.withAlpha(13) : Colors.black.withAlpha(13),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppTheme.getGlassBorder(context)),
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
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.isDark(context) ? Colors.white.withAlpha(13) : Colors.black.withAlpha(13),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment<bool>(
                      value: true,
                      label: Text('Bs.'),
                      icon: Icon(Icons.money),
                    ),
                    ButtonSegment<bool>(
                      value: false,
                      label: Text('USD \$'),
                      icon: Icon(Icons.attach_money),
                    ),
                  ],
                  selected: {viewModel.isBsMode},
                  onSelectionChanged: (Set<bool> newSelection) {
                    if (newSelection.first != viewModel.isBsMode) {
                      viewModel.toggleCurrencyMode();
                    }
                  },
                  showSelectedIcon: false,
                  style: SegmentedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    selectedBackgroundColor: AppTheme.primary,
                    selectedForegroundColor: Colors.white,
                    foregroundColor: AppTheme.getTextMuted(context),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        
        // Subtotal y Botones Acción
        Text(
          'Subtotal: Bs. ${viewModel.computedSubtotalBs.toStringAsFixed(2)} (\$ ${viewModel.computedSubtotalUsd.toStringAsFixed(2)})',
          style: TextStyle(
            fontSize: 20.sp,
            color: AppTheme.getTextMuted(context),
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
