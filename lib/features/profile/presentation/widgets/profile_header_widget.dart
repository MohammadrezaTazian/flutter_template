import 'package:flutter/material.dart';
import 'package:my_app/core/constants/colors.dart';
import 'package:my_app/features/profile/domain/entities/profile_entity.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileHeaderWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // آواتار
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primaryColor,
                  child: profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            profile.avatarUrl!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // نام کاربری یا نام کامل
            Text(
              profile.fullName ?? profile.username ?? 'کاربر',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            
            // شماره موبایل - زیر نام کاربری
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                profile.mobileNumber,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}