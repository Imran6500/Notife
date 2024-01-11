// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notife/smsController.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SMSController smsController = Get.put(SMSController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Notify",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          backgroundColor: Colors.teal,
          centerTitle: true,
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 15,
            ),
            const Center(
                child: Text(
              "All Notifications",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            )),
            Obx(() => Column(
                children: smsController.notificationList.value
                    .map((e) => e.title.trim() != "WhatsApp" &&
                            !e.content.contains("new messages")
                        ? Container(
                            margin: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              color: Colors.teal.shade50,
                              // boxShadow: const [
                              //   BoxShadow(
                              //       color: Colors.white,
                              //       blurRadius: 5,
                              //       spreadRadius: 0)
                              // ]
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        e.title.contains(":")
                                            ? "Group Name - "
                                            : "Name - ",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        e.title.contains(":")
                                            ? e.title.split(" ")[0]
                                            : e.title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15),
                                      ),
                                      const Spacer(),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            DateFormat("dd MMM yy").format(
                                                DateTime.parse(e.packageName)),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black38),
                                          ),
                                          Text(
                                            DateFormat("hh:mm a").format(
                                                DateTime.parse(e.packageName)),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black38),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  if (e.title.contains(":"))
                                    Row(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text(
                                          "By - ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15),
                                        ),
                                        if (e.title.contains(':'))
                                          Expanded(
                                            child: Text(
                                              e.title.contains("-")
                                                  ? e.title
                                                      .split("-")[0]
                                                      .split(':')[1]
                                                  : e.title.split(':')[1],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15),
                                            ),
                                          )
                                        else
                                          Expanded(
                                            child: Text(
                                              e.title.contains("-")
                                                  ? e.title.split("-")[0]
                                                  : e.title,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15),
                                            ),
                                          ),
                                      ],
                                    )
                                  else
                                    const SizedBox(),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  if (e.title.contains("-"))
                                    Row(
                                      children: [
                                        const Text("Mob No -",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15)),
                                        Text(
                                          e.title.split("-")[1],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: Text(e.content)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox())
                    .toList()))
          ],
        ));
  }
}
