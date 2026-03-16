import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class DateHeaderWidget extends StatelessWidget {
  const DateHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    
    // Using intl to format in Spanish
    final dayNum = DateFormat('d', 'es').format(now);
    final monthStr = DateFormat('MMM', 'es').format(now).toUpperCase();
    final yearStr = DateFormat('yyyy', 'es').format(now);
    final weekdayStr = DateFormat('EEEE', 'es').format(now);

    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 24.h),
      decoration: BoxDecoration(
        color: AppTheme.isDark(context) 
            ? AppTheme.bgCard.withAlpha(51) 
            : AppTheme.bgCardLight.withAlpha(128),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppTheme.getGlassBorder(context)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                dayNum,
                style: TextStyle(
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    monthStr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppTheme.getTextMuted(context),
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    yearStr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppTheme.getTextMuted(context),
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            weekdayStr,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
