import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:my_app/core/constants/routes.dart';
import 'package:my_app/features/auth/domain/usecases/save_tokens_usecase.dart';
import 'package:my_app/features/auth/domain/entities/token_entity.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('خروج از حساب کاربری'),
      content: const Text('آیا مطمئن هستید که می‌خواهید از حساب خود خارج شوید؟'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('لغو'),
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              // پاک کردن توکن‌ها
              final saveTokensUseCase = GetIt.instance<SaveTokensUseCase>();
              await saveTokensUseCase(TokenEntity(
                accessToken: '',
                refreshToken: '',
                userId: 0,
                expiresAt: DateTime.now(),
              ));

              if (context.mounted) {
                // بازگشت به صفحه لاگین
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.login,
                  (route) => false,
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('خطا در خروج از حساب'),
                    backgroundColor: Colors.red,
                  ),
                );
                Navigator.pop(context);
              }
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('خروج', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}