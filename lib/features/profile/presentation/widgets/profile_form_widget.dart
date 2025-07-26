import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/constants/colors.dart';
import 'package:my_app/features/profile/domain/entities/profile_entity.dart';
import 'package:my_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:my_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:my_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:my_app/features/profile/presentation/dialogs/logout_dialog.dart';

class ProfileFormWidget extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileFormWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'اطلاعات شخصی',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),

            // شماره موبایل
            _buildTextField(
              context,
              label: 'شماره موبایل',
              initialValue: profile.mobileNumber,
              field: 'mobileNumber',
              icon: Icons.phone,
            ),
            const SizedBox(height: 16),

            // نام کامل
            _buildTextField(
              context,
              label: 'نام خود را وارد کنید',
              initialValue: profile.fullName,
              field: 'fullName',
              icon: Icons.person,
            ),
            const SizedBox(height: 16),

            // نام کاربری
            _buildTextField(
              context,
              label: 'نام خانوادگی خود را وارد کنید',
              initialValue: profile.username,
              field: 'username',
              icon: Icons.account_circle,
            ),
            const SizedBox(height: 16),

            // مقاطع تحصیلی (Dropdown)
            _buildDropdownField(
              context,
              label: 'مقاطع تحصیلی',
              value: profile.email,
              field: 'email',
            ),
            const SizedBox(height: 16),

            // دکمه ذخیره
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // ذخیره تغییرات
                  final currentState = context.read<ProfileBloc>().state;
                  if (currentState is ProfileLoaded) {
                    context.read<ProfileBloc>().add(
                          UpdateProfile(profile.id, currentState.editedProfile),
                        );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: AppColors.primaryColor,
                ),
                child: const Text(
                  'به‌روزرسانی اطلاعات',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // دکمه خروج از حساب کاربری
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const LogoutDialog(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.red,
                ),
                child: const Text(
                  'خروج از حساب کاربری',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    String? initialValue,
    required String field,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          keyboardType: keyboardType,
          onChanged: (value) {
            context.read<ProfileBloc>().add(UpdateProfileField(field, value));
          },
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    BuildContext context, {
    required String label,
    String? value,
    required String field,
  }) {
    String? selectedValue;
    if (value != null && value.isNotEmpty) {
      final validValues = ['کارشناسی', 'کارشناسی ارشد', 'دکتری'];
      if (validValues.contains(value)) {
        selectedValue = value;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedValue,
          onChanged: (newValue) {
            if (newValue != null) {
              context.read<ProfileBloc>().add(UpdateProfileField(field, newValue));
            }
          },
          items: const [
            DropdownMenuItem(
              value: null,
              child: Text('انتخاب کنید'),
            ),
            DropdownMenuItem(
              value: 'کارشناسی',
              child: Text('کارشناسی'),
            ),
            DropdownMenuItem(
              value: 'کارشناسی ارشد',
              child: Text('کارشناسی ارشد'),
            ),
            DropdownMenuItem(
              value: 'دکتری',
              child: Text('دکتری'),
            ),
          ],
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            hintText: 'انتخاب کنید',
          ),
        ),
      ],
    );
  }
}