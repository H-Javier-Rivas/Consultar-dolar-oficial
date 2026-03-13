import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/history_viewmodel.dart';
import '../theme/app_theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh history when opening the screen
    Future.microtask(() {
      context.read<HistoryViewModel>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HistoryViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.bgMain,
        title: const Text('Historial de Cálculos'),
        actions: [
          if (viewModel.entries.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: AppTheme.bgCard,
                    title: const Text('Limpiar', style: TextStyle(color: Colors.white)),
                    content: const Text('¿Eliminar todo el historial?', style: TextStyle(color: AppTheme.textMuted)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancelar', style: TextStyle(color: AppTheme.primary)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Eliminar', style: TextStyle(color: AppTheme.error)),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  viewModel.clearHistory();
                }
              },
            )
        ],
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
          : viewModel.entries.isEmpty
              ? Center(
                  child: Text(
                    'No hay operaciones recientes',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 16.sp),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(20.w),
                  itemCount: viewModel.entries.length,
                  itemBuilder: (context, index) {
                    final entry = viewModel.entries[index];
                    final isPositive = entry.operation == '+';
                    
                    final dateObj = DateTime.parse(entry.sessionDate);
                    final dateStr = DateFormat('dd MMM yyyy, hh:mm a', 'es').format(dateObj);

                    return Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: const Color(0x08FFFFFF),
                        border: Border.all(color: AppTheme.glassBorder),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dateStr,
                                style: TextStyle(color: AppTheme.textMuted, fontSize: 12.sp),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Tasa: \${entry.rateUsed}',
                                style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                              ),
                            ],
                          ),
                          Text(
                            "\${isPositive ? '+' : '-'} Bs. \${entry.amountBs.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: isPositive ? AppTheme.primary : AppTheme.error,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
