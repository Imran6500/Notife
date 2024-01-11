// ignore_for_file: file_names, avoid_print, unused_local_variable

import 'package:fast_contacts/fast_contacts.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';
import 'package:permission_handler/permission_handler.dart';

class SMSController extends GetxController {
  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 3), () {
      requestForPermission();
    });
    getContacts();
    listenNotification();
    super.onInit();
  }

  List<Contact> contacts = [];

  RxList notificationList = RxList<ServiceNotificationEvent>();

  void requestForPermission() async {
    final bool status = await NotificationListenerService.isPermissionGranted();
    if (status == true) {
      print("Permission Granted");
    }
    if (status != true) {
      print("Requesting for permission");
      final bool status = await NotificationListenerService.requestPermission();
      return;
    }
    listenNotification();
  }

  void listenNotification() {
    // requestForPermission();
    print("Listening SMS");
    NotificationListenerService.notificationsStream.listen((event) {
      print("Current notification: $event");
      if (event.packageName == "com.whatsapp") {
        event.packageName = DateTime.now().toString();
        print("phone : ${contacts.length}");
        if (event.title!.contains(":")) {
          for (var element in contacts) {
            if (event.title!.split(":")[1].trim().toLowerCase() ==
                element.structuredName?.displayName.toLowerCase()) {
              event.title = "${event.title} - ${element.phones[0].number}";
            }
          }
        } else {
          for (var element in contacts) {
            if (event.title!.toLowerCase() ==
                element.structuredName?.displayName.toLowerCase()) {
              event.title = "${event.title} - ${element.phones[0].number}";
              // } else {
              //   event.title = event.title;
            }
          }
        }
        if (event.content?.toLowerCase().trim() !=
                "Checking for new messages".toLowerCase() &&
            !(event.content ?? "")
                .toLowerCase()
                .trim()
                .contains('new messages')) {
          if (notificationList.isEmpty) {
            notificationList.add(event);
            notificationList.value = notificationList.toSet().toList();
          }
          if (notificationList.isNotEmpty &&
              notificationList.last.title != event.title &&
              notificationList.last.content != event.content) {
            notificationList.add(event);
            // notificationList.value = notificationList.toSet().toList();
          }
        }
      }
    });
  }

  Future<void> getContacts() async {
    bool isGranted = await Permission.contacts.status.isGranted;
    if (!isGranted) {
      isGranted = await Permission.contacts.request().isGranted;
    }
    if (isGranted) {
      contacts = await FastContacts.getAllContacts();
      update();
    }
  }
}
