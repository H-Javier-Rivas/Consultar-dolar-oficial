import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/todo_viewmodel.dart';
import '../theme/app_theme.dart';

class TodoSectionWidget extends StatefulWidget {
  const TodoSectionWidget({Key? key}) : super(key: key);

  @override
  State<TodoSectionWidget> createState() => _TodoSectionWidgetState();
}

class _TodoSectionWidgetState extends State<TodoSectionWidget> {
  final TextEditingController _controller = TextEditingController();

  void _submitTask(TodoViewModel viewModel) {
    viewModel.addTodo(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TodoViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 32.h),
        Text(
          'Items Pendientes',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 16.h),
        
        // Input y Botones Extra
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48.h,
                child: TextField(
                  controller: _controller,
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  decoration: InputDecoration(
                    hintText: '¿Qué vamos a comprar?',
                    hintStyle: TextStyle(color: AppTheme.textMuted, fontSize: 14.sp),
                    filled: true,
                    fillColor: const Color(0x0DFFFFFF),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: AppTheme.glassBorder),
                    ),
                  ),
                  onSubmitted: (_) => _submitTask(viewModel),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            _ActionButtonMini(
              text: '➕',
              color: AppTheme.primary,
              onTap: () => _submitTask(viewModel),
            ),
            SizedBox(width: 8.w),
            _ActionButtonMini(
              text: '👀',
              color: const Color(0x0DFFFFFF),
              onTap: () => viewModel.sort(),
            ),
            SizedBox(width: 8.w),
            _ActionButtonMini(
              text: '✨',
              color: const Color(0x0DFFFFFF),
              onTap: () => viewModel.deleteDone(),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Lista de Todos
        if (viewModel.isLoading)
          const Center(child: CircularProgressIndicator(color: AppTheme.primary))
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: viewModel.todos.length,
            itemBuilder: (context, index) {
              final todo = viewModel.todos[index];
              return Container(
                margin: EdgeInsets.only(bottom: 8.h),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12.r),
                    onTap: () => viewModel.toggleTodo(todo),
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: todo.isDone ? Colors.transparent : const Color(0x08FFFFFF),
                        border: Border.all(color: AppTheme.glassBorder),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              todo.text,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: todo.isDone ? AppTheme.textMuted : Colors.white,
                                decoration: todo.isDone ? TextDecoration.lineThrough : null,
                              ),
                            ),
                          ),
                          Text(todo.isDone ? '✅' : '⏳', style: TextStyle(fontSize: 16.sp)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

class _ActionButtonMini extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;

  const _ActionButtonMini({required this.text, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      width: 48.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
        onPressed: onTap,
        child: Text(text, style: TextStyle(fontSize: 18.sp)),
      ),
    );
  }
}
