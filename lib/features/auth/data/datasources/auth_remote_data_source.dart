import 'package:dio/dio.dart';
import 'package:my_app/features/auth/domain/entities/token_entity.dart';

abstract class AuthRemoteDataSource {
  Future<void> sendOtp(String mobileNumber);
  Future<TokenEntity> verifyOtp(String mobileNumber, String otpCode);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio}) {
    dio.options.baseUrl = 'http://localhost:3000';
    dio.options.headers['Content-Type'] = 'application/json';
  }

  @override
  Future<void> sendOtp(String mobileNumber) async {
    try {
      // ابتدا چک می‌کنیم آیا کد قبلی برای این شماره وجود دارد
      final existingResponse = await dio.get('/otps?mobileNumber=$mobileNumber');
      
      // اگر کد قبلی وجود داشت، آن را حذف می‌کنیم
      if (existingResponse.data is List && existingResponse.data.isNotEmpty) {
        for (var otp in existingResponse.data) {
          await dio.delete('/otps/${otp['id']}');
        }
      }
      
      // تولید کد 5 رقمی تصادفی
      final otpCode = _generateRandomOtp();
      print('Generated OTP: $otpCode for mobile: $mobileNumber');
      
      // ارسال درخواست به API برای ارسال کد تایید
      final response = await dio.post('/otps',  data:{
        'mobileNumber': mobileNumber,
        'code': otpCode,
        'expiresAt': DateTime.now().add(Duration(minutes: 5)).toIso8601String(),
        'used': false
      });
      
      print('OTP Send Response: $response');
    } catch (e) {
      print('Send OTP Error: $e');
      throw Exception('Failed to send OTP: $e');
    }
  }

  @override
  Future<TokenEntity> verifyOtp(String mobileNumber, String otpCode) async {
    try {
      print('Verifying OTP: $otpCode for mobile: $mobileNumber');
      
      // بررسی کد تایید
      final response = await dio.get('/otps?mobileNumber=$mobileNumber&code=$otpCode&used=false');
      
      print('OTP Verify Response: $response');
      
      if (response.data is List && response.data.isNotEmpty) {
        final otp = response.data[0];
        print('Found OTP: $otp');
        
        final expiresAt = DateTime.parse(otp['expiresAt'].toString());
        
        if (expiresAt.isAfter(DateTime.now())) {
          // علامت زدن کد به عنوان استفاده شده
          await dio.patch('/otps/${otp['id']}',  data:{'used': true});
          print('OTP marked as used');
          
          // دریافت یا ایجاد کاربر - اصلاح شده
          int userId = await _getOrCreateUser(mobileNumber);
          
          // ایجاد توکن‌ها
          final accessToken = _generateAccessToken(userId, mobileNumber);
          final refreshToken = _generateRefreshToken();
          final tokenExpiresAt = DateTime.now().add(Duration(days: 30));
          
          print('Generated tokens for user $userId');
          
          // حذف توکن‌های قبلی این کاربر
          final existingTokensResponse = await dio.get('/tokens?userId=$userId');
          if (existingTokensResponse.data is List && existingTokensResponse.data.isNotEmpty) {
            for (var token in existingTokensResponse.data) {
              await dio.delete('/tokens/${token['id']}');
            }
          }
          
          // ذخیره توکن جدید
          final tokenResponse = await dio.post('/tokens',  data:{
            'userId': userId,
            'accessToken': accessToken,
            'refreshToken': refreshToken,
            'expiresAt': tokenExpiresAt.toIso8601String()
          });
          
          print('Token saved: $tokenResponse');
          
          return TokenEntity(
            accessToken: accessToken,
            refreshToken: refreshToken,
            userId: userId,
            expiresAt: tokenExpiresAt,
          );
        } else {
          throw Exception('OTP expired');
        }
      } else {
        throw Exception('Invalid OTP');
      }
    } catch (e) {
      print('Verify OTP Error Details: $e');
      throw Exception('Failed to verify OTP: $e');
    }
  }

  // متد جدید برای دریافت یا ایجاد کاربر
  Future<int> _getOrCreateUser(String mobileNumber) async {
    try {
      print('Searching for user with mobile: $mobileNumber');
      
      // دریافت تمام کاربران
      final allUsersResponse = await dio.get('/users');
      print('All users response: ${allUsersResponse.data}');
      
      if (allUsersResponse.data is List) {
        // جستجوی کاربر با شماره موبایل مشابه
        final user = allUsersResponse.data.firstWhere(
          (u) => u['mobileNumber'] == mobileNumber,
          orElse: () => null,
        );
        
        if (user != null) {
          // کاربر موجود است
          final userId = _parseUserId(user['id']);
          print('Existing user found with ID: $userId, Mobile: ${user['mobileNumber']}');
          return userId;
        } else {
          // ایجاد کاربر جدید
          print('Creating new user for mobile: $mobileNumber');
          final newUserResponse = await dio.post('/users',  data:{
            'mobileNumber': mobileNumber,
            'name': 'کاربر جدید',
            'email': '$mobileNumber@example.com',
            'createdAt': DateTime.now().toIso8601String()
          });
          final userId = _parseUserId(newUserResponse.data['id']);
          print('New user created with ID: $userId');
          return userId;
        }
      } else {
        // اگر هیچ کاربری وجود ندارد، کاربر جدید ایجاد کن
        print('No users found, creating new user for mobile: $mobileNumber');
        final newUserResponse = await dio.post('/users',  data:{
          'mobileNumber': mobileNumber,
          'name': 'کاربر جدید',
          'email': '$mobileNumber@example.com',
          'createdAt': DateTime.now().toIso8601String()
        });
        final userId = _parseUserId(newUserResponse.data['id']);
        print('New user created with ID: $userId');
        return userId;
      }
    } catch (e) {
      print('Error in _getOrCreateUser: $e');
      rethrow;
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

  String _generateRandomOtp() {
    // تولید کد 5 رقمی تصادفی
    final random = (DateTime.now().millisecondsSinceEpoch % 90000) + 10000;
    return (random % 100000).toString().padLeft(5, '0');
  }

  String _generateAccessToken(int userId, String mobileNumber) {
    // ساخت توکن ساده
    return 'access_token_${userId}_${mobileNumber}_${DateTime.now().millisecondsSinceEpoch}';
  }

  String _generateRefreshToken() {
    // ساخت رفرش توکن ساده
    return 'refresh_token_${DateTime.now().millisecondsSinceEpoch}_${_generateRandomString(20)}';
  }

  String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    return List.generate(length, (index) => chars[random % chars.length]).join();
  }
}