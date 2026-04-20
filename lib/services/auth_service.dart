import '../services/api.dart';
import '../utils/storage.dart';

class AuthService {
  /// EMAIL LOGIN / REGISTER
  static Future<bool> emailAuth(String email) async {
    final res = await Api.post("/auth/email", {"email": email});
    return res["isNewUser"] ?? false; // 👈 bool return karo
  }

  /// VERIFY OTP
  static Future<void> verifyOtp(String email, String otp) async {
    final res = await Api.post("/auth/verify-otp", {
      "email": email,
      "otp": otp,
    });

    await Storage.saveTokens(res["accessToken"], res["refreshToken"]);
  }

  /// GOOGLE LOGIN
  static Future<void> googleAuth(String token) async {
    final res = await Api.post("/auth/google", {"token": token});

    await Storage.saveTokens(res["accessToken"], res["refreshToken"]);
  }

  static Future<void> resendOtp(String email) async {
    await Api.post("/auth/resend-otp", {"email": email});
  }

  /// SAVE DOB
  static Future<void> saveDob(String dob) async {
    await Api.post("/auth/dob", {"dob": dob});
  }
}
