import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/constants/routes.dart';
import 'package:my_app/core/di/dependency_injection.dart';
import 'package:my_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:my_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:my_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:my_app/features/profile/presentation/widgets/profile_header_widget.dart';
import 'package:my_app/features/profile/presentation/widgets/profile_form_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('پروفایل'),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => ProfileBloc(
          getProfileUseCase: sl(),
          updateProfileUseCase: sl(),
          getTokensUseCase: sl(),
        )..add(const LoadProfileFromToken()),
        child: const ProfileView(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'تنظیمات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'خانه',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'پروفایل',
          ),
        ],
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, Routes.settings);
              break;
            case 1:
              Navigator.pushNamed(context, Routes.home);
              break;
            case 2:
              // ماندن در صفحه پروفایل
              break;
          }
        },
      ),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        print('Profile State: ${state.runtimeType}');
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProfileError) {
          print('Profile Error: ${state.message}');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<ProfileBloc>().add(const LoadProfileFromToken());
                  },
                  child: const Text('تلاش مجدد'),
                ),
              ],
            ),
          );
        } else if (state is ProfileLoaded) {
          print('Profile Loaded: ${state.profile.fullName}, Mobile: ${state.profile.mobileNumber}');
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ProfileHeaderWidget(profile: state.editedProfile),
                const SizedBox(height: 24),
                ProfileFormWidget(profile: state.editedProfile),
              ],
            ),
          );
        }
        return const Center(child: Text('خطای نامشخص'));
      },
    );
  }
}