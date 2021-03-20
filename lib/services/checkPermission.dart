import 'package:permission_handler/permission_handler.dart';

checkPermission() async {
    var activityStatus = await Permission.activityRecognition.status;
    var locationStatus = await Permission.location.status;
    // var storageStatus = await Permission.storage.status;

    if (!activityStatus.isGranted)
      await Permission.activityRecognition.request();

    if (!locationStatus.isGranted)
      await Permission.location.request();

    // if (!storageStatus.isGranted) await Permission.storage.request();
  }