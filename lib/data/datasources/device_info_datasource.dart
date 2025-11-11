import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

/// Data source for device information
abstract class DeviceInfoDataSource {
  /// Get device information
  Future<Map<String, String>> getDeviceInfo();
}

/// Implementation of DeviceInfoDataSource
class DeviceInfoDataSourceImpl implements DeviceInfoDataSource {
  final DeviceInfoPlugin _deviceInfo;

  DeviceInfoDataSourceImpl({DeviceInfoPlugin? deviceInfo})
      : _deviceInfo = deviceInfo ?? DeviceInfoPlugin();

  @override
  Future<Map<String, String>> getDeviceInfo() async {
    if (Platform.isAndroid) {
      return await _getAndroidInfo();
    } else if (Platform.isIOS) {
      return await _getIosInfo();
    } else {
      // Default for unsupported platforms
      return {
        'model': 'Unknown',
        'manufacturer': 'Unknown',
        'osVersion': 'Unknown',
        'platform': Platform.operatingSystem,
      };
    }
  }

  Future<Map<String, String>> _getAndroidInfo() async {
    try {
      final androidInfo = await _deviceInfo.androidInfo;
      return {
        'model': androidInfo.model ?? 'Unknown',
        'manufacturer': androidInfo.manufacturer ?? 'Unknown',
        'osVersion': 'Android ${androidInfo.version.release}',
        'platform': 'android',
      };
    } catch (e) {
      return {
        'model': 'Unknown',
        'manufacturer': 'Unknown',
        'osVersion': 'Unknown',
        'platform': 'android',
      };
    }
  }

  Future<Map<String, String>> _getIosInfo() async {
    try {
      final iosInfo = await _deviceInfo.iosInfo;
      return {
        'model': iosInfo.model ?? 'Unknown',
        'manufacturer': 'Apple',
        'osVersion': 'iOS ${iosInfo.systemVersion}',
        'platform': 'ios',
      };
    } catch (e) {
      return {
        'model': 'Unknown',
        'manufacturer': 'Apple',
        'osVersion': 'Unknown',
        'platform': 'ios',
      };
    }
  }
}
