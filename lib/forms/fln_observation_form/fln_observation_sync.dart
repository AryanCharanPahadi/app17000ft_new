import 'dart:convert';
import 'package:http_parser/http_parser.dart'; // for MediaType
import 'package:app17000ft_new/base_client/base_client.dart';
import 'package:app17000ft_new/components/custom_appBar.dart';
import 'package:app17000ft_new/components/custom_dialog.dart';
import 'package:app17000ft_new/components/custom_snackbar.dart';
import 'package:app17000ft_new/constants/color_const.dart';
import 'package:app17000ft_new/forms/fln_observation_form/fln_observation_controller.dart';
import 'package:app17000ft_new/forms/in_person_quantitative/in_person_quantitative_controller.dart';
import 'package:app17000ft_new/forms/school_enrolment/school_enrolment_controller.dart';
import 'package:app17000ft_new/helper/database_helper.dart';
import 'package:app17000ft_new/services/network_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FlnObservationSync extends StatefulWidget {
  const FlnObservationSync({super.key});

  @override
  State<FlnObservationSync> createState() => _FlnObservationSync();
}

class _FlnObservationSync extends State<FlnObservationSync> {
  final FlnObservationController _flnObservationController =
      Get.put(FlnObservationController());
  final NetworkManager _networkManager = Get.put(NetworkManager());
  var isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    _flnObservationController.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldPop =
            await BaseClient().showLeaveConfirmationDialog(context);
        return shouldPop;
      },
      child: Scaffold(
        appBar: const CustomAppbar(title: 'FLN Observation Sync'),
        body: GetBuilder<FlnObservationController>(
          builder: (flnObservationController) {
            if (flnObservationController.flnObservationList.isEmpty) {
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
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                          itemCount: flnObservationController
                              .flnObservationList.length,
                          itemBuilder: (context, index) {
                            final item = flnObservationController
                                .flnObservationList[index];
                            return ListTile(
                              title: Text(
                                "${index + 1}. Tour ID: ${item.tourId!}\n    School: ${item.school!}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
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
                                              desc:
                                                  'Are you sure you want to Sync?',
                                              onPressed: () async {
                                                setState(() {
                                                  // isLoadings= true;
                                                });
                                                if (_networkManager
                                                        .connectionType.value ==
                                                    0) {
                                                  customSnackbar(
                                                      'Warning',
                                                      'You are offline please connect to the internet',
                                                      AppColors.secondary,
                                                      AppColors.onSecondary,
                                                      Icons.warning);
                                                } else {
                                                  if (_networkManager
                                                              .connectionType
                                                              .value ==
                                                          1 ||
                                                      _networkManager
                                                              .connectionType
                                                              .value ==
                                                          2) {
                                                    print('ready to insert');

                                                    var rsp =
                                                        await insertFlnObservation(
                                                      item.tourId,
                                                      item.school,
                                                      item.udiseValue,
                                                      item.correctUdise,
                                                      item.noStaffTrained,
                                                      item.imgNurTimeTable,
                                                      item.imgLKGTimeTable,
                                                      item.imgUKGTimeTable,
                                                      item.lessonPlanValue,
                                                      item.activityValue,
                                                      item.imgActivity,
                                                      item.imgTLM,
                                                      item.baselineValue,
                                                      item.baselineGradeReport,
                                                      item.flnConductValue,
                                                      item.flnGradeReport,
                                                      item.imgFLN,
                                                      item.refresherValue,
                                                      item.numTrainedTeacher,
                                                      item.imgTraining,
                                                      item.readingValue,
                                                      item.libGradeReport,
                                                      item.imgLib,
                                                      item.methodologyValue,
                                                      item.imgClass,
                                                      item.observation,
                                                      item.created_by,
                                                      item.createdAt,
                                                      item.submittedAt,
                                                      item.id,
                                                    );
                                                    print(item.imgNurTimeTable);
                                                    if (rsp['status'] == 1) {
                                                      customSnackbar(
                                                          'Successfully',
                                                          "${rsp['message']}",
                                                          AppColors.secondary,
                                                          AppColors.onSecondary,
                                                          Icons.check);
                                                    } else if (rsp['status'] ==
                                                        0) {
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
                                                  }
                                                }
                                              }));
                                    },
                                  ),
                                ],
                              ),
                              onTap: () {
                                flnObservationController
                                    .flnObservationList[index].tourId;
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

  var baseurl = "https://mis.17000ft.org/apis/fast_apis/insert_fln.php";

Future<Map<String, dynamic>> insertFlnObservation(
    String? tourId,
    String? school,
    String? udiseValue,
    String? correctUdise,
    String? noStaffTrained,
    String? imgNurTimeTable,
    String? imgLKGTimeTable,
    String? imgUKGTimeTable,
    String? lessonPlanValue,
    String? activityValue,
    String? imgActivity,
    String? imgTLM,
    String? baselineValue,
    String? baselineGradeReport,
    String? flnConductValue,
    String? flnGradeReport,
    String? imgFLN,
    String? refresherValue,
    String? numTrainedTeacher,
    String? imgTraining,
    String? readingValue,
    String? libGradeReport,
    String? imgLib,
    String? methodologyValue,
    String? imgClass,
    String? observation,
    String? created_by,
    String? createdAt,
    String? submittedAt,
    int? id,


    ) async {
  if (kDebugMode) {
    print('Inserting Fln Observation Data');
    print('tourId: $tourId');
    print('school: $school');
    print('udiseValue: $udiseValue');
    print('correctUdise: $correctUdise');
    print('noStaffTrained: $noStaffTrained');

    print('imgNurTimeTable: $imgNurTimeTable');
    print('imgLKGTimeTable: $imgLKGTimeTable');
    print('imgUKGTimeTable: $imgUKGTimeTable');

    print('lessonPlanValue: $lessonPlanValue');
    print('activityValue: $activityValue');
    print('imgActivity: $imgActivity');
    print('imgTLM: $imgTLM');

    print('baselineValue: $baselineValue');
    print('baselineGradeReport: $baselineGradeReport');
    print('flnConductValue: $flnConductValue');
    print('flnGradeReport: $flnGradeReport');
    print('imgFLN: $imgFLN');

    print('refresherValue: $refresherValue');
    print('numTrainedTeacher: $numTrainedTeacher');
    print('imgTraining: $imgTraining');

    print('readingValue: $readingValue');
    print('libGradeReport: $libGradeReport');
    print('imgLib: $imgLib');

    print('methodologyValue: $methodologyValue');
    print('imgClass: $imgClass');

    print('observation: $observation');
    print('created_by: $created_by');
    print('createdAt: $createdAt');
    print('submittedAt: $submittedAt');
    print('id: $id');

  }

  var request = http.MultipartRequest(
    'POST',
    Uri.parse(baseurl),
  );
  request.headers["Accept"] = "Application/json";

// Ensure enrolmentData is a valid JSON string
  final String baselineGradeReportJsonData = baselineGradeReport ?? '';
  final String flnGradeReportJsonData = flnGradeReport ?? '';
  final String libGradeReportJsonData = libGradeReport ?? '';

  request.fields.addAll({
    'tourId': tourId ?? '',
    'school': school ?? '',
    'udiseValue': udiseValue ?? '',
    'correctUdise': correctUdise ?? '',
    'noStaffTrained': noStaffTrained ?? '',
    'lessonPlanValue': lessonPlanValue ?? '',
    'activityValue': activityValue ?? '',
    'baselineValue': baselineValue ?? '',
    'baselineGradeReport': baselineGradeReportJsonData ?? '',
    'flnConductValue': flnConductValue ?? '',
    'flnGradeReport': flnGradeReportJsonData ?? '',
    'refresherValue': refresherValue ?? '',
    'numTrainedTeacher': numTrainedTeacher ?? '',
    'readingValue': readingValue ?? '',
    'libGradeReport': libGradeReportJsonData ?? '',
    'methodologyValue': methodologyValue ?? '',
    'observation': observation ?? '',
    'created_by': created_by ?? '',
    'createdAt': createdAt ?? '',
    'submittedAt': submittedAt ?? '',

  });

  try {
    if (imgNurTimeTable != null && imgNurTimeTable.isNotEmpty) {
      // Convert Base64 image to Uint8List
      Uint8List imageBytes = base64Decode(imgNurTimeTable);

      // Create MultipartFile from the image bytes
      var multipartFile = http.MultipartFile.fromBytes(
        'imgNurTimeTable[]', // Name of the field in the server request
        imageBytes,
        filename: 'imgNurTimeTable_${id ?? ''}.jpg', // Custom file name
        contentType: MediaType('image', 'jpeg'), // Specify the content type
      );

      // Add the image to the request
      request.files.add(multipartFile);
    }

    if (imgLKGTimeTable != null && imgLKGTimeTable.isNotEmpty) {
      // Convert Base64 image to Uint8List
      Uint8List imageBytes = base64Decode(imgLKGTimeTable);

      // Create MultipartFile from the image bytes
      var multipartFile = http.MultipartFile.fromBytes(
        'imgLKGTimeTable[]', // Name of the field in the server request
        imageBytes,
        filename: 'imgLKGTimeTable${id ?? ''}.jpg', // Custom file name
        contentType: MediaType('image', 'jpeg'), // Specify the content type
      );

      // Add the image to the request
      request.files.add(multipartFile);
    }

    if (imgUKGTimeTable != null && imgUKGTimeTable.isNotEmpty) {
      // Convert Base64 image to Uint8List
      Uint8List imageBytes = base64Decode(imgUKGTimeTable);

      // Create MultipartFile from the image bytes
      var multipartFile = http.MultipartFile.fromBytes(
        'imgUKGTimeTable[]', // Name of the field in the server request
        imageBytes,
        filename: 'imgUKGTimeTable${id ?? ''}.jpg', // Custom file name
        contentType: MediaType('image', 'jpeg'), // Specify the content type
      );

      // Add the image to the request
      request.files.add(multipartFile);
    }

    if (imgActivity != null && imgActivity.isNotEmpty) {
      // Convert Base64 image to Uint8List
      Uint8List imageBytes = base64Decode(imgActivity);

      // Create MultipartFile from the image bytes
      var multipartFile = http.MultipartFile.fromBytes(
        'imgActivity[]', // Name of the field in the server request
        imageBytes,
        filename: 'imgActivity${id ?? ''}.jpg', // Custom file name
        contentType: MediaType('image', 'jpeg'), // Specify the content type
      );

      // Add the image to the request
      request.files.add(multipartFile);
    }

    if (imgTLM != null && imgTLM.isNotEmpty) {
      // Convert Base64 image to Uint8List
      Uint8List imageBytes = base64Decode(imgTLM);

      // Create MultipartFile from the image bytes
      var multipartFile = http.MultipartFile.fromBytes(
        'imgTLM[]', // Name of the field in the server request
        imageBytes,
        filename: 'imgTLM${id ?? ''}.jpg', // Custom file name
        contentType: MediaType('image', 'jpeg'), // Specify the content type
      );

      // Add the image to the request
      request.files.add(multipartFile);
    }

    if (imgFLN != null && imgFLN.isNotEmpty) {
      // Convert Base64 image to Uint8List
      Uint8List imageBytes = base64Decode(imgFLN);

      // Create MultipartFile from the image bytes
      var multipartFile = http.MultipartFile.fromBytes(
        'imgFLN[]', // Name of the field in the server request
        imageBytes,
        filename: 'imgFLN${id ?? ''}.jpg', // Custom file name
        contentType: MediaType('image', 'jpeg'), // Specify the content type
      );

      // Add the image to the request
      request.files.add(multipartFile);
    }

    if (imgTraining != null && imgTraining.isNotEmpty) {
      // Convert Base64 image to Uint8List
      Uint8List imageBytes = base64Decode(imgTraining);

      // Create MultipartFile from the image bytes
      var multipartFile = http.MultipartFile.fromBytes(
        'imgTraining[]', // Name of the field in the server request
        imageBytes,
        filename: 'imgTraining${id ?? ''}.jpg', // Custom file name
        contentType: MediaType('image', 'jpeg'), // Specify the content type
      );

      // Add the image to the request
      request.files.add(multipartFile);
    }

    if (imgLib != null && imgLib.isNotEmpty) {
      // Convert Base64 image to Uint8List
      Uint8List imageBytes = base64Decode(imgLib);

      // Create MultipartFile from the image bytes
      var multipartFile = http.MultipartFile.fromBytes(
        'imgLib[]', // Name of the field in the server request
        imageBytes,
        filename: 'imgLib${id ?? ''}.jpg', // Custom file name
        contentType: MediaType('image', 'jpeg'), // Specify the content type
      );

      // Add the image to the request
      request.files.add(multipartFile);
    }

    if (imgClass != null && imgClass.isNotEmpty) {
      // Convert Base64 image to Uint8List
      Uint8List imageBytes = base64Decode(imgClass);

      // Create MultipartFile from the image bytes
      var multipartFile = http.MultipartFile.fromBytes(
        'imgClass[]', // Name of the field in the server request
        imageBytes,
        filename: 'imgClass${id ?? ''}.jpg', // Custom file name
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
            table: 'flnObservation',
            field: 'id',
          );
          print("Record with id $id deleted from local database.");

          // Refresh data
          await Get.find<FlnObservationController>().fetchData();

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
