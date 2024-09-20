import 'dart:convert';

import 'package:app17000ft_new/base_client/base_client.dart';
import 'package:app17000ft_new/components/custom_appBar.dart';
import 'package:app17000ft_new/components/custom_dialog.dart';
import 'package:app17000ft_new/components/custom_snackbar.dart';
import 'package:app17000ft_new/constants/color_const.dart';
import 'package:app17000ft_new/forms/school_enrolment/school_enrolment.dart';
import 'package:app17000ft_new/forms/school_enrolment/school_enrolment_controller.dart';
import 'package:app17000ft_new/forms/school_facilities_&_mapping_form/school_facilities_controller.dart';
import 'package:app17000ft_new/forms/school_staff_vec_form/school_vec_controller.dart';
import 'package:app17000ft_new/forms/school_staff_vec_form/school_vec_from.dart';
import 'package:app17000ft_new/helper/database_helper.dart';
import 'package:app17000ft_new/services/network_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SchoolStaffVecSync extends StatefulWidget {
  const SchoolStaffVecSync({super.key});

  @override
  State<SchoolStaffVecSync> createState() => _SchoolStaffVecSyncState();
}

class _SchoolStaffVecSyncState extends State<SchoolStaffVecSync> {
  final _schoolStaffVecController = Get.put(SchoolStaffVecController());
  final NetworkManager _networkManager = Get.put(NetworkManager());
  var isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    _schoolStaffVecController.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        bool shouldPop =
            await BaseClient().showLeaveConfirmationDialog(context);
        return shouldPop;
      },
      child: Scaffold(
        appBar: const CustomAppbar(title: 'School Staff & SMC/VEC Details'),
        body: GetBuilder<SchoolStaffVecController>(
          builder: (schoolStaffVecController) {
            return Obx(() => isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : schoolStaffVecController.schoolStaffVecList.isEmpty
                    ? const Center(
                        child: Text(
                          'No Records Found',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary),
                        ),
                      )
                    : Column(
                        children: [
                          schoolStaffVecController.schoolStaffVecList.isNotEmpty
                              ? Expanded(
                                  child: ListView.separated(
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const Divider(),
                                    itemCount: schoolStaffVecController
                                        .schoolStaffVecList.length,
                                    itemBuilder: (context, index) {
                                      final item = schoolStaffVecController
                                          .schoolStaffVecList[index];
                                      return ListTile(
                                        title: Text(
                                          "${index + 1}. Tour ID: ${item.tourId!}\n    School ${item.school}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              color: AppColors.primary,
                                              icon: const Icon(Icons.edit),
                                              onPressed: () async {
                                                final existingRecord =
                                                schoolStaffVecController
                                                    .schoolStaffVecList[
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
                                                          SchoolStaffVecForm(
                                                            userid: 'userid',

                                                            existingRecords:
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
                                                IconData icon =
                                                    Icons.check_circle;
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
                                                          if (_networkManager
                                                                  .connectionType
                                                                  .value ==
                                                              0) {
                                                            customSnackbar(
                                                                'Warning',
                                                                'You are offline please connect to the internet',
                                                                AppColors
                                                                    .secondary,
                                                                AppColors
                                                                    .onSecondary,
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
                                                              print(
                                                                  'ready to insert');
                                                              var rsp = await insertSchoolStaffVec(
                                                                  item.school,
                                                                  item.tourId,
                                                                  item.udiseValue,
                                                                  item.correctUdise,
                                                                  item.headName,
                                                                  item.headGender,
                                                                  item.headMobile,
                                                                  item.headEmail,
                                                                  item.headDesignation,
                                                                  item.totalTeachingStaff,
                                                                  item.totalNonTeachingStaff,
                                                                  item.totalStaff,
                                                                  item.SmcVecName,
                                                                  item.genderVec,
                                                                  item.vecMobile,
                                                                  item.vecEmail,
                                                                  item.vecQualification,
                                                                  item.vecTotal,
                                                                  item.meetingDuration,
                                                                  item.createdBy,
                                                                  item.createdAt,
                                                                  item.other,
                                                                  item.otherQual,




                                                                  item.id);
                                                              if (rsp['status'] ==
                                                                  1) {
                                                                customSnackbar(
                                                                    'Successfully',
                                                                    "${rsp['message']}",
                                                                    AppColors
                                                                        .secondary,
                                                                    AppColors
                                                                        .onSecondary,
                                                                    Icons
                                                                        .check);
                                                              } else if (rsp[
                                                                      'status'] ==
                                                                  0) {
                                                                customSnackbar(
                                                                    "Error",
                                                                    "${rsp['message']}",
                                                                    AppColors
                                                                        .error,
                                                                    AppColors
                                                                        .onError,
                                                                    Icons
                                                                        .warning);
                                                              } else {
                                                                customSnackbar(
                                                                    "Error",
                                                                    "Something went wrong, Please contact Admin",
                                                                    AppColors
                                                                        .error,
                                                                    AppColors
                                                                        .onError,
                                                                    Icons
                                                                        .warning);
                                                              }
                                                            }
                                                          }
                                                        }));
                                              },
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          schoolStaffVecController
                                              .schoolStaffVecList[index].tourId;
                                        },
                                      );
                                    },
                                  ),
                                )
                              : const Padding(
                                  padding: EdgeInsets.only(top: 340.0),
                                  child: Center(
                                    child: Text(
                                      'No Data Found',
                                      style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                        ],
                      ));
          },
        ),
      ),
    );
  }
}

var baseurl = "https://mis.17000ft.org/apis/fast_apis/insert_vec.php";
Future insertSchoolStaffVec(
    String? tourId,
    String? school,
    String? udiseValue,
    String? correctUdise,
    String? headName,
    String? headGender,
    String? headMobile,
    String? headEmail,
    String? headDesignation,
    String? totalTeachingStaff,
    String? totalNonTeachingStaff,
    String? totalStaff,
    String? SmcVecName,
    String? genderVec,
    String? vecMobile,
    String? vecEmail,
    String? vecQualification,
    String? vecTotal,
    String? meetingDuration,
    String? createdBy,
    String? createdAt,
    String? other,
    String? otherQual,
    int? id,
    ) async {
  print('This is enrolment data:');
  print('tourId: $tourId');
  print('school: $school');
  print('udiseValue: $udiseValue');
  print('correctUdise: $correctUdise');
  print('headName: $headName');
  print('headGender: $headGender');
  print('headMobile: $headMobile');
  print('headEmail: $headEmail');
  print('headDesignation: $headDesignation');
  print('totalTeachingStaff: $totalTeachingStaff');
  print('totalNonTeachingStaff: $totalNonTeachingStaff');
  print('totalStaff: $totalStaff');
  print('SmcVecName: $SmcVecName');
  print('genderVec: $genderVec');
  print('vecMobile: $vecMobile');
  print('vecEmail: $vecEmail');
  print('vecQualification: $vecQualification');
  print('vecTotal: $vecTotal');
  print('meetingDuration: $meetingDuration');
  print('createdBy: $createdBy');
  print('createdAt: $createdAt');
  print('other: $other');
  print('otherQual: $otherQual');
  print('id: $id');

  var request = http.MultipartRequest(
    'POST',
    Uri.parse(baseurl),
  );

  // Set headers
  request.headers["Accept"] = "Application/json";

  // Add text fields
  request.fields.addAll({
    'tourId': tourId ?? '',
    'school': school ?? '',
    'udiseValue': udiseValue ?? '',
    'correctUdise': correctUdise ?? '',
    'headName': headName ?? '',
    'headGender': headGender ?? '',
    'headMobile': headMobile ?? '',
    'headEmail': headEmail ?? '',
    'headDesignation': headDesignation ?? '',
    'totalTeachingStaff': totalTeachingStaff?.toString() ?? '',
    'totalNonTeachingStaff': totalNonTeachingStaff?.toString() ?? '',
    'totalStaff': totalStaff?.toString() ?? '',
    'SmcVecName': SmcVecName ?? '',
    'genderVec': genderVec ?? '',
    'vecMobile': vecMobile ?? '',
    'vecEmail': vecEmail ?? '',
    'vecQualification': vecQualification ?? '',
    'vecTotal': vecTotal ?? '',
    'meetingDuration': meetingDuration ?? '',
    'createdBy': createdBy ?? '',
    'createdAt': createdAt ?? '',
    'other': other ?? '',
    'otherQual': otherQual ?? '',
    'id': id?.toString() ?? '', // Convert the integer ID to a string
  });

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
        table: 'schoolStaffVec',
        field: 'id',
      );
      print("Record with id $id deleted from local database.");
      await Get.find<SchoolStaffVecController>().fetchData();
    }

    return parsedResponse;
  } catch (error) {
    print("Error: $error");
    return {"status": 0, "message": "Something went wrong, Please contact Admin"};
  }
}
