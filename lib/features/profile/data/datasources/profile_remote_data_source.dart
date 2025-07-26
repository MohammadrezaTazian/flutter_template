import 'package:dio/dio.dart';
import 'package:my_app/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileEntity> getProfile(int userId);
  Future<ProfileEntity> updateProfile(int userId, ProfileEntity profile);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSourceImpl({required this.dio}) {
    dio.options.baseUrl = 'http://localhost:3000';
    dio.options.headers['Content-Type'] = 'application/json';
  }

  @override
  Future<ProfileEntity> getProfile(int userId) async {
    try {
      print('Fetching profile for user ID: $userId');
      
      // دریافت تمام کاربران و جستجوی کاربر مورد نظر
      final allUsersResponse = await dio.get('/users');
      
      if (allUsersResponse.data is List) {
        final user = allUsersResponse.data.firstWhere(
          (u) => _parseUserId(u['id']) == userId,
          orElse: () => null,
        );
        
        if (user != null) {
          print('Profile API Response: $user');
          return ProfileEntity(
            id: _parseUserId(user['id']),
            mobileNumber: user['mobileNumber'] != null ? user['mobileNumber'].toString() : '',
            fullName: user['name'] != null ? user['name'].toString() : null,
            username: user['username'] != null ? user['username'].toString() : null,
            avatarUrl: user['avatarUrl'] != null ? user['avatarUrl'].toString() : null,
            email: user['email'] != null ? user['email'].toString() : null,
            createdAt: user['createdAt'] != null 
                ? DateTime.parse(user['createdAt'].toString()) 
                : DateTime.now(),
          );
        } else {
          throw Exception('User not found with ID: $userId');
        }
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Profile API Error: $e');
      throw Exception('Failed to load profile: $e');
    }
  }

  @override
  Future<ProfileEntity> updateProfile(int userId, ProfileEntity profile) async {
    try {
      print('Updating profile for user ID: $userId');
      print('Update Data: ${{
        'name': profile.fullName,
        'username': profile.username,
        'avatarUrl': profile.avatarUrl,
        'email': profile.email,
        'mobileNumber': profile.mobileNumber,
      }}');
      
      // به‌روزرسانی پروفایل
      final response = await dio.patch('/users/$userId',  data:{
        'name': profile.fullName,
        'username': profile.username,
        'avatarUrl': profile.avatarUrl,
        'email': profile.email,
        'mobileNumber': profile.mobileNumber,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      if (response.statusCode == 200) {
        final data = response.data;
        return ProfileEntity(
          id: _parseUserId(data['id']),
          mobileNumber: data['mobileNumber'] != null ? data['mobileNumber'].toString() : '',
          fullName: data['name'] != null ? data['name'].toString() : null,
          username: data['username'] != null ? data['username'].toString() : null,
          avatarUrl: data['avatarUrl'] != null ? data['avatarUrl'].toString() : null,
          email: data['email'] != null ? data['email'].toString() : null,
          createdAt: data['createdAt'] != null 
              ? DateTime.parse(data['createdAt'].toString()) 
              : DateTime.now(),
        );
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      print('Update Profile Error: $e');
      throw Exception('Failed to update profile: $e');
    }
  }

  // متد کمکی برای تبدیل id به int
  int _parseUserId(dynamic id) {
    if (id == null) return 0;
    
    try {
      if (id is int) {
        return id;
      } else if (id is String) {
        // اگر id عددی باشد، تبدیل به int
        if (int.tryParse(id) != null) {
          return int.parse(id);
        } else {
          // اگر id رشته‌ای غیر عددی باشد، یک عدد منحصر به فرد تولید کن
          return id.hashCode.abs();
        }
      } else {
        return id.hashCode.abs();
      }
    } catch (e) {
      print('Error parsing user ID: $e, returning hash code');
      return id.hashCode.abs();
    }
  }
}