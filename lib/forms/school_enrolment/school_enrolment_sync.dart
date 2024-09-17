import 'dart:convert';
import 'dart:io';
import 'package:app17000ft_new/forms/school_enrolment/school_enrolment.dart';
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
import 'package:get/get.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class EnrolmentSync extends StatefulWidget {
  const EnrolmentSync({super.key});

  @override
  State<EnrolmentSync> createState() => _EnrolmentSyncState();
}

class _EnrolmentSyncState extends State<EnrolmentSync> {
  final SchoolEnrolmentController _schoolEnrolmentController = Get.put(SchoolEnrolmentController());
  final NetworkManager _networkManager = Get.put(NetworkManager());
  var isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    _schoolEnrolmentController.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldPop = await BaseClient().showLeaveConfirmationDialog(context);
        return shouldPop;
      },
      child: Scaffold(
        appBar: const CustomAppbar(title: 'Enrollment Sync'),
        body: GetBuilder<SchoolEnrolmentController>(
          builder: (schoolEnrolmentController) {
            if (schoolEnrolmentController.enrolmentList.isEmpty) {
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
                    itemCount: schoolEnrolmentController.enrolmentList.length,
                    itemBuilder: (context, index) {
                      final item = schoolEnrolmentController.enrolmentList[index];
                      return ListTile(
                        title: Text(
                          "${index + 1}. Tour ID: ${item.tourId!}\n    School: ${item.school!}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              color: AppColors.primary,
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                final existingRecord =
                                schoolEnrolmentController
                                    .enrolmentList[
                                index];

                                // Debug prints
                                print(
                                    'Navigating to Enrollment');
                                print(
                                    'Existing Record: $existingRecord');

                                IconData icon = Icons.edit;

                                // Show the confirmation dialog
                                bool? shouldNavigate =
                                await showDialog<bool>(
                                  context: context,
                                  builder: (_) => Confirmation(
                                    iconname: icon,
                                    title: 'Confirm Update',
                                    yes: 'Confirm',
                                    no: 'Cancel',
                                    desc:
                                    'Are you sure you want to Update this record?',
                                    onPressed: () {
                                      // Close the dialog and return true to indicate confirmation
                                      Navigator.of(context)
                                          .pop(true);
                                    },
                                  ),
                                );

                                // Check if the user confirmed the action
                                if (shouldNavigate == true) {
                                  // Debug print before navigation
                                  print('Navigating now');

                                  // Navigate to CabMeterTracingForm using Navigator.push
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SchoolEnrollmentForm(
                                            userid: 'userid',

                                            existingRecord:
                                            existingRecord,
                                          ),
                                    ),
                                  );

                                  // Debug print after navigation
                                  print('Navigation completed');
                                } else {
                                  // User canceled the action
                                  print('Navigation canceled');
                                }
                              },
                            ),
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
                                              // Ensure that registerImageXFile is correctly handled
                                              var rsp = await insertEnrolment(
                                                  item.tourId,
                                                  item.school,
                                                  item.registerImage, // Ensure this is an XFile
                                                  item.enrolmentData,
                                                  item.remarks,
                                                  item.createdAt,
                                                  item.submittedBy,

                                                  item.id
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
                          schoolEnrolmentController.enrolmentList[index].tourId;
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
const String baseUrl = "https://mis.17000ft.org/apis/fast_apis/enrollmentCollection.php";

Future<Map<String, dynamic>> insertEnrolment(
    String? tourId,
    String? school,
    String? registerImage, // Base64-encoded image
    String? enrolmentData,
    String? remarks,
    String? createdAt,
    String? submittedBy,
    int? id,
    ) async {
  if (kDebugMode) {
    print('this is School Enrollment Data');
    print('Tour ID: $tourId');
    print('School: $school');
    print('Register Image: $registerImage');
    print('Enrolment Data: $enrolmentData');
    print('Remarks: $remarks');
    print('Created At: $createdAt');
    print('Submitted By: $submittedBy');
    print('Local ID: $id');
  }

  var request = http.MultipartRequest(
    'POST',
    Uri.parse(baseUrl),
  );
  request.headers["Accept"] = "application/json";

  // Ensure enrolmentData is a valid JSON string
  final String jsonData = enrolmentData ?? '';

  // Add text fields
  request.fields.addAll({
    'id': id?.toString() ?? '',
    'tourId': tourId ?? '',
    'school': school ?? '',
    'enrolmentData': jsonData, // Properly formatted JSON string
    'remarks': remarks ?? '',
    'createdAt': createdAt ?? '',
    'submittedBy': submittedBy ?? '',
  });

  try {
    if (registerImage != null && registerImage.isNotEmpty) {
      // Convert Base64 image to Uint8List
      Uint8List imageBytes = base64Decode(registerImage);

      // Create MultipartFile from the image bytes
      var multipartFile = http.MultipartFile.fromBytes(
        'registerImage[]', // Name of the field in the server request
        imageBytes,
        filename: 'enrolment_image_${id ?? ''}.jpg', // Custom file name
        contentType: MediaType('image', 'jpeg'), // Specify the content type
      );

      // Add the image to the request
      request.files.add(multipartFile);
    }

    // Send the request to the server
    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    print('Server Response Body: $responseBody'); // Print the raw response

    if (response.statusCode == 200) {
      if (responseBody.isEmpty) {
        return {"status": 0, "message": "Empty response from server"};
      }

      try {
        var parsedResponse = json.decode(responseBody);

        if (parsedResponse['status'] == 1) {
          // Remove record from local database
          await SqfliteDatabaseHelper().queryDelete(
            arg: id.toString(),
            table: 'schoolEnrolment',
            field: 'id',
          );
          print("Record with id $id deleted from local database.");

          // Refresh data
          await Get.find<SchoolEnrolmentController>().fetchData();

          return parsedResponse;
        } else {
          print('Server Response Error: ${parsedResponse['message']}');
          return {"status": 0, "message": parsedResponse['message'] ?? 'Failed to insert data'};
        }
      } catch (e) {
        print('Error decoding JSON: $e');
        return {"status": 0, "message": "Invalid response format"};
      }
    } else {
      print('Server Error Response Code: ${response.statusCode}');
      print('Server Error Response Body: $responseBody');
      return {"status": 0, "message": "Server returned an error"};
    }
  } catch (error) {
    print("Error: $error");
    return {"status": 0, "message": "Something went wrong, Please contact Admin"};
  }
}
