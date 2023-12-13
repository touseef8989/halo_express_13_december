
import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoService {
  PackageInfoService._();

  factory PackageInfoService() => _instance;

  static final PackageInfoService _instance = PackageInfoService._();

  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<String> getAppBuildNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  Future<String> getPackageName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }
}
