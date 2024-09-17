

import 'dart:convert';
import 'package:http_parser/http_parser.dart'; // for MediaType

import 'package:app17000ft_new/base_client/base_client.dart';
import 'package:app17000ft_new/components/custom_appBar.dart';
import 'package:app17000ft_new/components/custom_dialog.dart';
import 'package:app17000ft_new/components/custom_snackbar.dart';
import 'package:app17000ft_new/constants/color_const.dart';
import 'package:app17000ft_new/forms/school_enrolment/school_enrolment_controller.dart';
import 'package:app17000ft_new/helper/database_helper.dart';
import 'package:app17000ft_new/services/network_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'cab_meter_tracing_controller.dart';

class CabTracingSync extends StatefulWidget {
  const CabTracingSync({super.key});

  @override
  State<CabTracingSync> createState() => _CabTracingSyncState();
}

class _CabTracingSyncState extends State<CabTracingSync> {
  final CabMeterTracingController _cabMeterTracingController = Get.put(CabMeterTracingController());
  final NetworkManager _networkManager = Get.put(NetworkManager());
  var isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    _cabMeterTracingController.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldPop = await BaseClient().showLeaveConfirmationDialog(context);
        return shouldPop;
      },
      child: Scaffold(
        appBar: const CustomAppbar(title: 'Cab Meter Tracing Sync'),
        body: GetBuilder<CabMeterTracingController>(
          builder: (cabMeterTracingController) {
            if (cabMeterTracingController.cabMeterTracingList.isEmpty) {
              return const Center(
                child: Text(
                  'No Records Found',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary),
                ),
              );
            }

            return Obx(() => isLoading.value
                ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
                : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) => const Divider(),
                    itemCount: cabMeterTracingController.cabMeterTracingList.length,
                    itemBuilder: (context, index) {
                      final item = cabMeterTracingController.cabMeterTracingList[index];
                      return ListTile(
                        title: Text(
                          "${index + 1}. Tour ID: ${item.tour_id!}\n    Vehicle No. ${item.vehicle_num!}\n    Driver Name: ${item.driver_name!}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              color: AppColors.primary,
                              icon: const Icon(Icons.sync),
                              onPressed: () async {
                                IconData icon = Icons.check_circle;
                                showDialog(
                                    context: context,
                                    builder: (_) => Confirmation(
                                        iconname: icon,
                                        title: 'Confirm',
                                        yes: 'Confirm',
                                        no: 'Cancel',
                                        desc: 'Are you sure you want to Sync?',
                                        onPressed: () async {
                                          setState(() {
                                            isLoading.value = true; // Show loading spinner
                                          });
                                          if (_networkManager.connectionType.value == 0) {
                                            customSnackbar(
                                                'Warning',
                                                'You are offline please connect to the internet',
                                                AppColors.secondary,
                                                AppColors.onSecondary,
                                                Icons.warning);
                                          } else {
                                            if (_networkManager.connectionType.value == 1 ||
                                                _networkManager.connectionType.value == 2) {
                                              print('ready to insert');
                                              var rsp = await insertCabMeterTracing(
                                                item.id,
                                                item.status,
                                                item.vehicle_num,
                                                item.driver_name,
                                                item.meter_reading,
                                                item.image,
                                                item.uniqueId,
                                                item.place_visit,
                                                item.remarks,
                                                item.created_at,
                                                item.office,
                                                item.version,
                                                item.uniqueId,
                                                item.tour_id,
                                              );
                                              if (rsp['status'] == 1) {
                                                customSnackbar(
                                                    'Successfully',
                                                    "${rsp['message']}",
                                                    AppColors.secondary,
                                                    AppColors.onSecondary,
                                                    Icons.check);
                                              } else if (rsp['status'] == 0) {
                                                customSnackbar(
                                                    "Error",
                                                    "${rsp['message']}",
                                                    AppColors.error,
                                                    AppColors.onError,
                                                    Icons.warning);
                                              } else {
                                                customSnackbar(
                                                    "Error",
                                                    "Something went wrong, Please contact Admin",
                                                    AppColors.error,
                                                    AppColors.onError,
                                                    Icons.warning);
                                              }
                                              setState(() {
                                                isLoading.value = false; // Hide loading spinner
                                              });
                                            }
                                          }
                                        }));
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          cabMeterTracingController.cabMeterTracingList[index].tour_id;
                        },
                      );
                    },
                  ),
                ),
              ],
            ));
          },
        ),
      ),
    );
  }
}

var baseurl = "https://mis.17000ft.org/apis/fast_apis/insert_cabMeter.php";



Future<Map<String, dynamic>> insertCabMeterTracing(
    int? id,
    String? status,
    String? vehicle_num,
    String? driver_name,
    String? meter_reading,
    String? base64Images, // Base64 encoded image data
    String? user_id,
    String? place_visit,
    String? remarks,
    String? created_at,
    String? office,
    String? version,
    String? uniqueId,
    String? tour_id,
    ) async {
  print('this is Cab Meter Tracing Data');
  print(id);
  print(status);
  print(vehicle_num);
  print(driver_name);
  print(meter_reading);
  print(user_id);
  print(place_visit);
  print(base64Images);
  print(remarks);
  print(created_at);
  print(office);
  print(version);
  print(uniqueId);
  print(tour_id);

  var request = http.MultipartRequest('POST', Uri.parse(baseurl));
  request.headers["Accept"] = "application/json";

  // Add form fields with null checks
  request.fields.addAll({
    'id': id?.toString() ?? '',
    'status': status ?? '',
    'vehicle_num': vehicle_num ?? '',
    'driver_name': driver_name ?? '',
    'meter_reading': meter_reading ?? '',
    'user_id': user_id ?? '',
    'place_visit': place_visit ?? '',
    'remarks': remarks ?? '',
    'created_at': created_at ?? '',
    'office': office ?? '',
    'version': version ?? '1.0',
    'uniqueId': uniqueId ?? '',
    'tour_id': tour_id ?? '',
  });

  // Convert Base64 back to file and add it to the request
  if (base64Images != null && base64Images.isNotEmpty) {
    try {
      List<String> imagesList = base64Images.split(",");
      for (int i = 0; i < imagesList.length; i++) {
        var imageBytes = base64Decode(imagesList[i]);
        var file = http.MultipartFile.fromBytes(
          'image[]', // Ensure 'image' is the correct field name for your API
          imageBytes,
          filename: 'image$i.jpg',
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(file);
      }
    } catch (e) {
      print("Error decoding Base64 images: $e");
    }
  } else {
    print("No images to upload");
  }

  try {
    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    print('Raw response body: $responseBody');

    // Check if the response body contains HTML (which suggests an issue with the server)
    if (responseBody.contains('<br />') || responseBody.contains('<b>')) {
      print("HTML error response detected.");
      return {"status": 0, "message": "Server returned HTML instead of JSON. Please check the API."};
    }

    // Try parsing the response as JSON
    var parsedResponse = json.decode(responseBody);

    if (parsedResponse['status'] == 1) {
      // If successfully inserted, delete from local database
      await SqfliteDatabaseHelper().queryDelete(
        arg: id.toString(),
        table: 'cabMeter_tracing',
        field: 'id',
      );
      print("Record with id $id deleted from local database.");
      await Get.find<CabMeterTracingController>().fetchData();
    }

    return parsedResponse;
  } catch (error) {
    print("Error: $error");
    return {"status": 0, "message": "Something went wrong, Please contact Admin"};
  }
}
