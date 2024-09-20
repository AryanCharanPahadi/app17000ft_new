import 'dart:convert';
import 'package:http_parser/http_parser.dart'; // for MediaType
import 'package:app17000ft_new/base_client/base_client.dart';
import 'package:app17000ft_new/components/custom_appBar.dart';
import 'package:app17000ft_new/components/custom_dialog.dart';
import 'package:app17000ft_new/components/custom_snackbar.dart';
import 'package:app17000ft_new/constants/color_const.dart';
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


import 'alfa_observation_controller.dart';



class AlfaObservationSync extends StatefulWidget {
  const AlfaObservationSync({super.key});

  @override
  State<AlfaObservationSync> createState() => _AlfaObservationSync();
}

class _AlfaObservationSync extends State<AlfaObservationSync> {
  final AlfaObservationController _alfaObservationController = Get.put(AlfaObservationController());
  final NetworkManager _networkManager = Get.put(NetworkManager());
  var isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    _alfaObservationController.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldPop = await BaseClient().showLeaveConfirmationDialog(context);
        return shouldPop;
      },
      child: Scaffold(
        appBar: const CustomAppbar(title: 'Alfa Observation Sync'),
        body: GetBuilder<AlfaObservationController>(
          builder: (alfaObservationController) {
            if (alfaObservationController.alfaObservationList.isEmpty) {
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
                    itemCount: alfaObservationController.alfaObservationList.length,
                    itemBuilder: (context, index) {
                      final item = alfaObservationController.alfaObservationList[index];
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
                                            // isLoadings= true;
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
                                              print(item.submittedAt);
                                              var rsp = await insertAlfaObservation(
                                                item.tourId,
                                                item.school,
                                                item.udiseValue,
                                                item.correctUdise,
                                                item.noStaffTrained,
                                                item.imgNurTimeTable,
                                                item.imgLKGTimeTable,
                                                item.imgUKGTimeTable,
                                                item.bookletValue,
                                                item.moduleValue,
                                                item.numeracyBooklet,
                                                item.numeracyValue,
                                                item.pairValue,
                                                item.alfaActivityValue,
                                                item.alfaGradeReport,
                                                item.imgAlfa,
                                                item.refresherTrainingValue,
                                                item.noTrainedTeacher,
                                                item.imgTraining,
                                                item.readingValue,
                                                item.libGradeReport,
                                                item.imgLibrary,
                                                item.tlmKitValue,
                                                item.imgTlm,
                                                item.classObservation,
                                                item.createdAt,
                                                item.submittedAt,
                                                item.createdBy,
                                                item.id,

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
                                            }
                                          }
                                        }));
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          alfaObservationController.alfaObservationList[index].tourId;
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


var baseurl = "https://mis.17000ft.org/17000ft_apis/alfaObservation/insert_alfa.php";


Future<Map<String, dynamic>> insertAlfaObservation(
    String? tourId,
    String? school,
    String? udiseValue,
    String? correctUdise,
    String? noStaffTrained,
    String? imgNurTimeTable,
    String? imgLKGTimeTable,
    String? imgUKGTimeTable,
    String? bookletValue,
    String? moduleValue,
    String? numeracyBooklet,
    String? numeracyValue,
    String? pairValue,
    String? alfaActivityValue,
    String? alfaGradeReport,
    String? imgAlfa,
    String? refresherTrainingValue,
    String? noTrainedTeacher,
    String? imgTraining,
    String? readingValue,
    String? libGradeReport,
    String? imgLibrary,
    String? tlmKitValue,
    String? imgTLM,
    String? classObservation,
    String? createdAt,
    String? submittedAt,
    String? createdBy,
    int? id,

    ) async {
  if (kDebugMode) {
    print('Inserting Alfa Observation Data');
    print('tourId: $tourId');
    print('school: $school');
    print('id: $id');
    print('udiseValue: $udiseValue');
    print('correctUdise: $correctUdise');
    print('noStaffTrained: $noStaffTrained');
    print('imgNurTimeTable: $imgNurTimeTable');
    print('imgLKGTimeTable: $imgLKGTimeTable');
    print('imgUKGTimeTable: $imgUKGTimeTable');
    print('bookletValue: $bookletValue');
    print('moduleValue: $moduleValue');
    print('numeracyBooklet: $numeracyBooklet');
    print('numeracyValue: $numeracyValue');
    print('pairValue: $pairValue');
    print('alfaActivityValue: $alfaActivityValue');
    print('alfaGradeReport: $alfaGradeReport');
    print('imgAlfa: $imgAlfa');
    print('refresherTrainingValue: $refresherTrainingValue');
    print('noTrainedTeacher: $noTrainedTeacher');
    print('imgTraining: $imgTraining');
    print('readingValue: $readingValue');
    print('libGradeReport: $libGradeReport');
    print('imgLibrary: $imgLibrary');
    print('tlmKitValue: $tlmKitValue');
    print('imgTLM: $imgTLM');
    print('classObservation: $classObservation');
    print('createdAt: $createdAt');
    print('submittedAt: $submittedAt');
    print('createdBy: $createdBy');

  }

  var request = http.MultipartRequest(
    'POST',
    Uri.parse(baseurl),
  );
  request.headers["Accept"] = "Application/json";


  // Ensure enrolmentData is a valid JSON string
  final String alfaGradeReportJsonData = alfaGradeReport ?? '';
  final String libGradeReportJsonData = libGradeReport ?? '';

  // Add text fields
  request.fields.addAll({

    'tourId': tourId ?? '',
    'school': school ?? '',
    'udiseValue': udiseValue ?? '',
    'correctUdise': correctUdise ?? '',
    'noStaffTrained': noStaffTrained ?? '',
    'bookletValue': bookletValue ?? '',
    'moduleValue': moduleValue ?? '',
    'numeracyBooklet': numeracyBooklet ?? '',
    'numeracyValue': numeracyValue ?? '',
    'pairValue': pairValue ?? '',
    'alfaActivityValue': alfaActivityValue ?? '',
    'alfaGradeReport': alfaGradeReportJsonData ?? '',
    'refresherTrainingValue': refresherTrainingValue ?? '',
    'noTrainedTeacher': noTrainedTeacher ?? '',
    'readingValue': readingValue ?? '',
    'libGradeReport': libGradeReportJsonData ?? '',
    'tlmKitValue': tlmKitValue ?? '',
    'classObservation': classObservation ?? '',
    'createdAt': createdAt ?? '',
    'submittedAt': submittedAt ?? '',
    'createdBy': createdBy ?? '',
    'id': id?.toString() ?? '',

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

    if (imgAlfa != null && imgAlfa.isNotEmpty) {
      // Convert Base64 image to Uint8List
      Uint8List imageBytes = base64Decode(imgAlfa);

      // Create MultipartFile from the image bytes
      var multipartFile = http.MultipartFile.fromBytes(
        'imgAlfa[]', // Name of the field in the server request
        imageBytes,
        filename: 'imgAlfa${id ?? ''}.jpg', // Custom file name
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

    if (imgLibrary != null && imgLibrary.isNotEmpty) {
      // Convert Base64 image to Uint8List
      Uint8List imageBytes = base64Decode(imgLibrary);

      // Create MultipartFile from the image bytes
      var multipartFile = http.MultipartFile.fromBytes(
        'imgLibrary[]', // Name of the field in the server request
        imageBytes,
        filename: 'imgLibrary${id ?? ''}.jpg', // Custom file name
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
            table: 'alfaObservation',
            field: 'id',
          );
          print("Record with id $id deleted from local database.");

          // Refresh data
          await Get.find<AlfaObservationController>().fetchData();

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
