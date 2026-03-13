import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';
import '../widgets/converter_panel_widget.dart';
import '../widgets/date_header_widget.dart';
import '../widgets/rate_card_widget.dart';
import '../widgets/todo_section_widget.dart';
import '../widgets/totals_panel_widget.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            icon: Icon(Icons.history, size: 28.sp),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              );
            },
          ),
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
