import 'package:permission_handler/permission_handler.dart';


class MyPermissionStorage {
  Future<void> getStoragePermission(Permission permission)async{
    Future<bool> statusUndetermined = permission.isUndetermined;
    Future<bool> statusDenied = permission.isDenied;
    Future<bool> statusPermanentlyDenied = permission.isPermanentlyDenied;
    if(statusUndetermined != null)
      permission.request();

    else if(statusPermanentlyDenied != null)
      openAppSettings();
  }
}