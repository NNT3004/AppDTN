import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static Future<bool> testStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Thử ghi và đọc một giá trị
      await prefs.setString('test_key', 'test_value');
      final value = prefs.getString('test_key');
      debugPrint('✅ SharedPreferences hoạt động tốt. Giá trị đọc: $value');
      return value == 'test_value';
    } catch (e) {
      debugPrint('❌ Lỗi SharedPreferences: $e');
      return false;
    }
  }
}
