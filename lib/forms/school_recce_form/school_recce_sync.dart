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
import 'package:app17000ft_new/forms/school_recce_form/school_recce_controller.dart';
import 'package:app17000ft_new/helper/database_helper.dart';
import 'package:app17000ft_new/services/network_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SchoolRecceSync extends StatefulWidget {
  const SchoolRecceSync({super.key});

  @override
  State<SchoolRecceSync> createState() => _SchoolRecceSync();
}

class _SchoolRecceSync extends State<SchoolRecceSync> {
  final SchoolRecceController _schoolRecceController =
      Get.put(SchoolRecceController());
  final NetworkManager _networkManager = Get.put(NetworkManager());
  var isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    _schoolRecceController.fetchData();
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
        appBar: const CustomAppbar(title: 'School Recce Sync'),
        body: GetBuilder<SchoolRecceController>(
          builder: (schoolRecceController) {
            if (schoolRecceController.schoolRecceList.isEmpty) {
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
                          itemCount:
                              schoolRecceController.schoolRecceList.length,
                          itemBuilder: (context, index) {
                            final item =
                                schoolRecceController.schoolRecceList[index];
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
                                                        await insertSchoolRecce(
                                                      item.tourId,
                                                      item.school,
                                                      item.udiseValue,
                                                      item.udise_correct,
                                                      item.boardImg,
                                                      item.buildingImg,
                                                      item.gradeTaught,
                                                      item.instituteHead,
                                                      item.headDesignation,
                                                      item.headPhone,
                                                      item.headEmail,
                                                      item.appointedYear,
                                                      item.noTeachingStaff,
                                                      item.noNonTeachingStaff,
                                                      item.totalStaff,
                                                      item.registerImg,
                                                      item.smcHeadName,
                                                      item.smcPhone,
                                                      item.smcQual,
                                                      item.qualOther,
                                                      item.totalSmc,
                                                      item.meetingDuration,
                                                      item.meetingOther,
                                                      item.smcDesc,
                                                      item.noUsableClass,
                                                      item.electricityAvailability,
                                                      item.networkAvailability,
                                                      item.digitalLearning,
                                                      item.smartClassImg,
                                                      item.projectorImg,
                                                      item.computerImg,
                                                      item.libraryExisting,
                                                      item.libImg,
                                                      item.playGroundSpace,
                                                      item.spaceImg,
                                                      item.enrollmentReport,
                                                      item.enrollmentImg,
                                                      item.academicYear,
                                                      item.gradeReportYear1,
                                                      item.gradeReportYear2,
                                                      item.gradeReportYear3,
                                                      item.DigiLabRoomImg,
                                                      item.libRoomImg,
                                                      item.remoteInfo,
                                                      item.motorableRoad,
                                                      item.languageSchool,
                                                      item.languageOther,
                                                      item.supportingNgo,
                                                      item.otherNgo,
                                                      item.observationPoint,
                                                      item.submittedBy,
                                                      item.createdAt,
                                                      item.id,
                                                    );

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
                                schoolRecceController
                                    .schoolRecceList[index].tourId;
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

var baseurl = "https://mis.17000ft.org/apis/fast_apis/insert_recce.php";
Future insertSchoolRecce(
    String? tourId,
    String? school,
    String? udiseValue,
    String? udise_correct,
    String? boardImg,
    String? buildingImg,
    String? gradeTaught,
    String? instituteHead,
    String? headDesignation,
    String? headPhone,
    String? headEmail,
    String? appointedYear,
    String? noTeachingStaff,
    String? noNonTeachingStaff,
    String? totalStaff,
    String? registerImg,
    String? smcHeadName,
    String? smcPhone,
    String? smcQual,
    String? qualOther,
    String? totalSmc,
    String? meetingDuration,
    String? meetingOther,
    String? smcDesc,
    String? noUsableClass,
    String? electricityAvailability,
    String? networkAvailability,
    String? digitalLearning,
    String? smartClassImg,
    String? projectorImg,
    String? computerImg,
    String? libraryExisting,
    String? libImg,
    String? playGroundSpace,
    String? spaceImg,
    String? enrollmentReport,
    String? enrollmentImg,
    String? academicYear,
    String? gradeReportYear1,
    String? gradeReportYear2,
    String? gradeReportYear3,
    String? DigiLabRoomImg,
    String? libRoomImg,
    String? remoteInfo,
    String? motorableRoad,
    String? languageSchool,
    String? languageOther,
    String? supportingNgo,
    String? otherNgo,
    String? observationPoint,
    String? submittedBy,
    String? createdAt,
    int? id,
    ) async {
  if (kDebugMode) {
    print('This is School Recce Data');
    print('Tour ID: $tourId');
    print('School: $school');
    print('UDISE Value: $udiseValue');
    print('UDISE Correct: $udise_correct');
    print('Board Image: $boardImg');
    print('Building Image: $buildingImg');
    print('Grade Taught: $gradeTaught');
    print('Institute Head: $instituteHead');
    print('Head Designation: $headDesignation');
    print('Head Phone: $headPhone');
    print('Head Email: $headEmail');
    print('Appointed Year: $appointedYear');
    print('No Teaching Staff: $noTeachingStaff');
    print('No Non-Teaching Staff: $noNonTeachingStaff');
    print('Total Staff: $totalStaff');
    print('Register Image: $registerImg');
    print('SMC Head Name: $smcHeadName');
    print('SMC Phone: $smcPhone');
    print('SMC Qualification: $smcQual');
    print('Qualification Other: $qualOther');
    print('Total SMC: $totalSmc');
    print('Meeting Duration: $meetingDuration');
    print('Meeting Other: $meetingOther');
    print('SMC Description: $smcDesc');
    print('No Usable Class: $noUsableClass');
    print('Electricity Availability: $electricityAvailability');
    print('Network Availability: $networkAvailability');
    print('Digital Learning: $digitalLearning');
    print('Smart Class Image: $smartClassImg');
    print('Projector Image: $projectorImg');
    print('Computer Image: $computerImg');
    print('Library Existing: $libraryExisting');
    print('Library Image: $libImg');
    print('Playground Space: $playGroundSpace');
    print('Space Image: $spaceImg');
    print('Enrollment Report: $enrollmentReport');
    print('Enrollment Image: $enrollmentImg');
    print('Academic Year: $academicYear');
    print('Grade Report Year 1: $gradeReportYear1');
    print('Grade Report Year 2: $gradeReportYear2');
    print('Grade Report Year 3: $gradeReportYear3');
    print('Digital Lab Room Image: $DigiLabRoomImg');
    print('Library Room Image: $libRoomImg');
    print('Remote Info: $remoteInfo');
    print('Motorable Road: $motorableRoad');
    print('Language School: $languageSchool');
    print('Language Other: $languageOther');
    print('Supporting NGO: $supportingNgo');
    print('Other NGO: $otherNgo');
    print('Observation Point: $observationPoint');
    print('Submitted By: $submittedBy');
    print('Created At: $createdAt');
    print('ID: $id');
  }

  var request = http.MultipartRequest(
    'POST',
    Uri.parse(baseurl),
  );
  request.headers["Accept"] = "Application/json";

  // Ensure enrolmentData is a valid JSON string
  final String enrollmentReportJsonData = enrollmentReport ?? '';
  final String gradeReportYear1JsonData = gradeReportYear1 ?? '';
  final String gradeReportYear2JsonData = gradeReportYear2 ?? '';
  final String gradeReportYear3JsonData = gradeReportYear3 ?? '';

  // Add text fields
  request.fields.addAll({
    'tourId': tourId ?? '',
    'school': school ?? '',
    'udiseValue': udiseValue ?? '',
    'udise_correct': udise_correct ?? '',


    'gradeTaught': gradeTaught ?? '',
    'instituteHead': instituteHead ?? '',
    'headDesignation': headDesignation ?? '',
    'headPhone': headPhone ?? '',
    'headEmail': headEmail ?? '',
    'appointedYear': appointedYear ?? '',
    'noTeachingStaff': noTeachingStaff ?? '',
    'noNonTeachingStaff': noNonTeachingStaff ?? '',
    'totalStaff': totalStaff ?? '',

    'smcHeadName': smcHeadName ?? '',
    'smcPhone': smcPhone ?? '',
    'smcQual': smcQual ?? '',
    'qualOther': qualOther ?? '',
    'totalSmc': totalSmc ?? '',
    'meetingDuration': meetingDuration ?? '',
    'meetingOther': meetingOther ?? '',
    'smcDesc': smcDesc ?? '',
    'noUsableClass': noUsableClass ?? '',
    'electricityAvailability': electricityAvailability ?? '',
    'networkAvailability': networkAvailability ?? '',
    'digitalLearning': digitalLearning ?? '',



    'libraryExisting': libraryExisting ?? '',

    'playGroundSpace': playGroundSpace ?? '',

    'enrollmentReport': enrollmentReportJsonData ?? '',

    'academicYear': academicYear ?? '',
    'gradeReportYear1': gradeReportYear1JsonData ?? '',
    'gradeReportYear2': gradeReportYear2JsonData ?? '',
    'gradeReportYear3': gradeReportYear3JsonData ?? '',


    'remoteInfo': remoteInfo ?? '',
    'motorableRoad': motorableRoad ?? '',
    'languageSchool': languageSchool ?? '',
    'languageOther': languageOther ?? '',
    'supportingNgo': supportingNgo ?? '',
    'otherNgo': otherNgo ?? '',
    'observationPoint': observationPoint ?? '',
    'submittedBy': submittedBy ?? '',
    'createdAt': createdAt ?? '',
  });

  try {
    if (boardImg != null && boardImg.isNotEmpty) {
      // Convert Base64 image to Uint8List
      Uint8List imageBytes = base64Decode(boardImg);

      // Create MultipartFile from the image bytes
      var multipartFile = http.MultipartFile.fromBytes(
        'boardImg[]', // Name of the field in the server request
        imageBytes,
        filename: 'boardImg${id ?? ''}.jpg', // Custom file name
        contentType: MediaType('image', 'jpeg'), // Specify the content type
      );

      // Add the image to the request
      request.files.add(multipartFile);
    }

    if (buildingImg != null && buildingImg.isNotEmpty) {
      // Convert Base64 image to Uint8List
      Uint8List imageBytes = base64Decode(buildingImg);

      // Create MultipartFile from the image bytes
      var multipartFile = http.MultipartFile.fromBytes(
        'buildingImg[]', // Name of the field in the server request
        imageBytes,
        filename: 'buildingImg${id ?? ''}.jpg', // Custom file name
        contentType: MediaType('image', 'jpeg'), // Specify the content type
      );

      // Add the image to the request
      request.files.add(multipartFile);
    }

    if (registerImg != null && registerImg.isNotEmpty) {
      // Convert Base64 image to Uint8List
      Uint8List imageBytes = base64Decode(registerImg);

      // Create MultipartFile from the image bytes
      var multipartFile = http.MultipartFile.fromBytes(
        'registerImg[]', // Name of the field in the server request
        imageBytes,
        filename: 'registerImg${id ?? ''}.jpg', // Custom file name
        contentType: MediaType('image', 'jpeg'), // Specify the content type
      );

      // Add the image to the request
      request.files.add(multipartFile);
    }

    if (smartClassImg != null && smartClassImg.isNotEmpty) {
      // Convert Base64 image to Uint8List
      Uint8List imageBytes = base64Decode(smartClassImg);

      // Create MultipartFile from the image bytes
      var multipartFile = http.MultipartFile.fromBytes(
        'smartClassImg[]', // Name of the field in the server request
        imageBytes,
        filename: 'smartClassImg${id ?? ''}.jpg', // Custom file name
        contentType: MediaType('image', 'jpeg'), // Specify the content type
      );

      // Add the image to the request
      request.files.add(multipartFile);
    }

    if (projectorImg != null && projectorImg.isNotEmpty) {
      // Convert Base64 image to Uint8List
      Uint8List imageBytes = base64Decode(projectorImg);

      // Create MultipartFile from the image bytes
      var multipartFile = http.MultipartFile.fromBytes(
        'projectorImg[]', // Name of the field in the server request
        imageBytes,
        filename: 'projectorImg${id ?? ''}.jpg', // Custom file name
        contentType: MediaType('image', 'jpeg'), // Specify the content type
      );

      // Add the image to the request
      request.files.add(multipartFile);
    }

    if (computerImg != null && computerImg.isNotEmpty) {
      // Convert Base64 image to Uint8List
      Uint8List imageBytes = base64Decode(computerImg);

      // Create MultipartFile from the image bytes
      var multipartFile = http.MultipartFile.fromBytes(
        'computerImg[]', // Name of the field in the server request
        imageBytes,
        filename: 'computerImg${id ?? ''}.jpg', // Custom file name
        contentType: MediaType('image', 'jpeg'), // Specify the content type
      );

      // Add the image to the request
      request.files.add(multipartFile);
    }

    if (libImg != null && libImg.isNotEmpty) {
      // Convert Base64 image to Uint8List
      Uint8List imageBytes = base64Decode(libImg);

      // Create MultipartFile from the image bytes
      var multipartFile = http.MultipartFile.fromBytes(
        'libImg[]', // Name of the field in the server request
        imageBytes,
        filename: 'libImg${id ?? ''}.jpg', // Custom file name
        contentType: MediaType('image', 'jpeg'), // Specify the content type
      );

      // Add the image to the request
      request.files.add(multipartFile);
    }

    if (spaceImg != null && spaceImg.isNotEmpty) {
      // Convert Base64 image to Uint8List
      Uint8List imageBytes = base64Decode(spaceImg);

      // Create MultipartFile from the image bytes
      var multipartFile = http.MultipartFile.fromBytes(
        'spaceImg[]', // Name of the field in the server request
        imageBytes,
        filename: 'spaceImg${id ?? ''}.jpg', // Custom file name
        contentType: MediaType('image', 'jpeg'), // Specify the content type
      );

      // Add the image to the request
      request.files.add(multipartFile);
    }

    if (enrollmentImg != null && enrollmentImg.isNotEmpty) {
      // Convert Base64 image to Uint8List
      Uint8List imageBytes = base64Decode(enrollmentImg);

      // Create MultipartFile from the image bytes
      var multipartFile = http.MultipartFile.fromBytes(
        'enrollmentImg[]', // Name of the field in the server request
        imageBytes,
        filename: 'enrollmentImg${id ?? ''}.jpg', // Custom file name
        contentType: MediaType('image', 'jpeg'), // Specify the content type
      );

      // Add the image to the request
      request.files.add(multipartFile);
    }

    if (DigiLabRoomImg != null && DigiLabRoomImg.isNotEmpty) {
      // Convert Base64 image to Uint8List
      Uint8List imageBytes = base64Decode(DigiLabRoomImg);

      // Create MultipartFile from the image bytes
      var multipartFile = http.MultipartFile.fromBytes(
        'DigiLabRoomImg[]', // Name of the field in the server request
        imageBytes,
        filename: 'DigiLabRoomImg${id ?? ''}.jpg', // Custom file name
        contentType: MediaType('image', 'jpeg'), // Specify the content type
      );

      // Add the image to the request
      request.files.add(multipartFile);
    }

    if (libRoomImg != null && libRoomImg.isNotEmpty) {
      // Convert Base64 image to Uint8List
      Uint8List imageBytes = base64Decode(libRoomImg);

      // Create MultipartFile from the image bytes
      var multipartFile = http.MultipartFile.fromBytes(
        'libRoomImg[]', // Name of the field in the server request
        imageBytes,
        filename: 'libRoomImg${id ?? ''}.jpg', // Custom file name
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
            table: 'schoolRecce',
            field: 'id',
          );
          print("Record with id $id deleted from local database.");

          // Refresh data
          await Get.find<SchoolRecceController>().fetchData();

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
