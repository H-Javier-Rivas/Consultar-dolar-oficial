import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/theme_viewmodel.dart';
import '../widgets/converter_panel_widget.dart';
import '../widgets/date_header_widget.dart';
import '../widgets/rate_card_widget.dart';
import '../widgets/todo_section_widget.dart';
import '../widgets/totals_panel_widget.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeVM = Provider.of<ThemeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Dolar BVC Premium',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.sp),
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeVM.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              size: 26.sp,
            ),
            onPressed: () => themeVM.toggleTheme(),
          ),
          IconButton(
            icon: Icon(Icons.history, size: 28.sp),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              );
            },
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const DateHeaderWidget(),
              const RateCardWidget(),
              const ConverterPanelWidget(),
              SizedBox(height: 32.h),
              const TotalsPanelWidget(),
              SizedBox(height: 32.h),
              const TodoSectionWidget(),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
