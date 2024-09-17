import 'dart:convert';
import 'package:http_parser/http_parser.dart'; // for MediaType
import 'package:app17000ft_new/base_client/base_client.dart';
import 'package:app17000ft_new/components/custom_appBar.dart';
import 'package:app17000ft_new/components/custom_dialog.dart';
import 'package:app17000ft_new/components/custom_snackbar.dart';
import 'package:app17000ft_new/constants/color_const.dart';
import 'package:app17000ft_new/forms/in_person_quantitative/in_person_quantitative_controller.dart';
import 'package:app17000ft_new/forms/issue_tracker/issue_tracker_controller.dart';
import 'package:app17000ft_new/forms/issue_tracker/playground_issue.dart';
import 'package:app17000ft_new/forms/school_enrolment/school_enrolment_controller.dart';
import 'package:app17000ft_new/helper/database_helper.dart';
import 'package:app17000ft_new/services/network_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'alexa_issue.dart';
import 'digilab_issue.dart';
import 'furniture_issue.dart';
import 'issue_tracker_modal.dart';
import 'lib_issue_modal.dart';

class FinalIssueTrackerSync extends StatefulWidget {
  const FinalIssueTrackerSync({Key? key}) : super(key: key);

  @override
  State<FinalIssueTrackerSync> createState() => _FinalIssueTrackerSyncState();
}

class _FinalIssueTrackerSyncState extends State<FinalIssueTrackerSync> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<IssueTrackerRecords> finalList = [];

  final IssueTrackerController _issueTrackerController =
      Get.put(IssueTrackerController());
  double _percent = 0.0;
  bool _isSubmitting = false;

  // final AssessmentController _assessmentController =
  // Get.put(AssessmentController());

  filterUnique() {
    finalList = [];
    finalList = _issueTrackerController.issueTrackerList;
    print('length of ${finalList.length}');
    setState(() {});
  }

  List<IssueTrackerRecords>? issueTrackerList;
  List<LibIssue>? libIssueList;
  List<PlaygroundIssue>? playgroundIssueList;
  List<DigiLabIssue>? digiLabIssueList;
  List<FurnitureIssue>? furnitureIssueList;
  List<AlexaIssue>? alexaIssueList;

  var isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    _issueTrackerController.fetchData().then((value) => filterUnique());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        IconData icon = Icons.check_circle;
        bool shouldExit = await showDialog(
            context: context,
            builder: (_) => Confirmation(
                iconname: icon,
                title: 'Confirm Exit',
                yes: 'Exit',
                no: 'Cancel',
                desc: 'Are you sure you want to Exit?',
                onPressed: () async {
                  Navigator.of(context).pop(true);
                }));
        return shouldExit;
      },
      child: GetBuilder<NetworkManager>(
          init: NetworkManager(),
          builder: (networkManager) {
            return Scaffold(
              key: _scaffoldKey,
              appBar: const CustomAppbar(title: 'Issue Tracker Sync'),
              body: GetBuilder<IssueTrackerController>(
                  init: IssueTrackerController(),
                  builder: (issueTrackerController) {
                    return Obx(() => isLoading.value
                        ? Center(
                            child: CircularProgressIndicator(
                                color: AppColors.primary),
                          )
                        : issueTrackerController.issueTrackerList.isEmpty
                            ? const Center(
                                child: CircularProgressIndicator(
                                    color: AppColors.primary))
                            : finalList.isEmpty
                                ? const Center(
                                    child: Text(
                                    'No Records Found',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary),
                                  ))
                                // : GetBuilder<CabController>(
                                //     builder: (cabController) {
                                : Column(
                                    children: [
                                      Expanded(
                                        child: ListView.separated(
                                          itemCount: finalList.length,
                                          separatorBuilder:
                                              (BuildContext context,
                                                      int index) =>
                                                  const Divider(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return ListTile(
                                              leading: Text("(${(index + 1)})"),
                                              title: Text(
                                                finalList[index]
                                                        .school
                                                        .toString() ??
                                                    '',
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "TourId:${finalList[index].tourId}" ??
                                                        '',
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "School: ${finalList[index].school.toString()}",
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                          width: double.infinity,
                                          height: 45,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xFF8A2724),
                                                  elevation: 0),
                                              child: const Text("Sync",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              onPressed: () async {
                                                // ignore: unrelated_type_equality_checks
                                                if (networkManager
                                                        .connectionType ==
                                                    0) {
                                                  customSnackbar(
                                                      'Warning',
                                                      'You are offline please connect to the internet',
                                                      AppColors.secondary,
                                                      AppColors.onSecondary,
                                                      Icons.warning);
                                                } else {
                                                  issueTrackerList = Get.find<
                                                          IssueTrackerController>()
                                                      .issueTrackerList
                                                      .toList();
                                                  libIssueList = Get.find<
                                                          IssueTrackerController>()
                                                      .libIssueList
                                                      .toList();
                                                  digiLabIssueList = Get.find<
                                                          IssueTrackerController>()
                                                      .digiLabIssueList
                                                      .toList();
                                                  alexaIssueList = Get.find<
                                                          IssueTrackerController>()
                                                      .alexaIssueList
                                                      .toList();
                                                  furnitureIssueList = Get.find<
                                                          IssueTrackerController>()
                                                      .furnitureIssueList
                                                      .toList();
                                                  playgroundIssueList = Get.find<
                                                          IssueTrackerController>()
                                                      .playgroundIssueList
                                                      .toList();

                                                  setState(() {
                                                    _isSubmitting = true;
                                                    _percent =
                                                        0.0; // Reset percentage
                                                  });

                                                  // exit(0);
                                                  IconData icon =
                                                      Icons.check_circle;
                                                  showDialog(
                                                      context: context,
                                                      builder: (_) =>
                                                          Confirmation(
                                                              iconname: icon,
                                                              title:
                                                                  'Confirm Submission',
                                                              yes: 'Confirm',
                                                              no: 'Cancel',
                                                              desc:
                                                                  'Are you sure you want to Synced?',
                                                              onPressed:
                                                                  () async {
                                                                isLoading
                                                                        .value =
                                                                    true;
                                                                setState(() {});
                                                                for (int i = 0;
                                                                    i <
                                                                        issueTrackerList!
                                                                            .length;
                                                                    i++) {
                                                                  print(
                                                                      '$i no of row inserted');

                                                                  // var rsp  = await insertIssueRecordss('state', 'district', 'block', 'tourId', 'school', 'uniqueId', filterdByUniqueId![i].issueExist!.toString()??'', filterdByUniqueId![i].issueName!.toString()??'', issueTrackerController.imagePaths, filterdByUniqueId![i].issueDescription!.toString()??'', filterdByUniqueId![i].issueReportOn!, filterdByUniqueId![i].issueReportBy!, filterdByUniqueId![i].issueResolvedOn!, filterdByUniqueId![i].issueResolvedBy!, filterdByUniqueId![i].issueStatus!);
                                                                  print(
                                                                      'TABLE 1 BASIC RECORDS ');

                                                                  var rsp = await insertBasicRecords(
                                                                      issueTrackerList![i]
                                                                          .tourId!
                                                                          .toString(),
                                                                      issueTrackerList![i]
                                                                              .school ??
                                                                          'NA',
                                                                      issueTrackerList![i]
                                                                              .udiseCode ??
                                                                          'NA',
                                                                      issueTrackerList![i]
                                                                              .correctUdise ??
                                                                          'NA',
                                                                      issueTrackerList![i]
                                                                              .uniqueId ??
                                                                          'NA',
                                                                      issueTrackerList![
                                                                              i]
                                                                          .createdAt!,
                                                                      issueTrackerList![
                                                                              i]
                                                                          .id);
                                                                  if (rsp !=
                                                                          null &&
                                                                      rsp.containsKey(
                                                                          'status')) {
                                                                    if (rsp['status'] ==
                                                                        '1') {
                                                                      print(
                                                                          'TABLE of Library ${libIssueList!.length}');
                                                                      if (libIssueList!
                                                                          .isNotEmpty) {
                                                                        for (int i =
                                                                                0;
                                                                            i < libIssueList!.length;
                                                                            i++) {
                                                                          print(
                                                                              'library records of num row $i');

                                                                          var rsplib = await insertIssueRecords(
                                                                              libIssueList![i].uniqueId,
                                                                              libIssueList![i].issueExist!,
                                                                              libIssueList![i].issueName!,
                                                                              libIssueList![i].libImg!,
                                                                              libIssueList![i].issueDescription!,
                                                                              libIssueList![i].issueReportOn!,
                                                                              libIssueList![i].issueReportBy!,
                                                                              libIssueList![i].issueResolvedOn!,
                                                                              libIssueList![i].issueResolvedBy!,
                                                                              libIssueList![i].issueStatus!,
                                                                              libIssueList![i].id);
                                                                          //For library records
                                                                          if (rsplib['status'] ==
                                                                              1) {
                                                                            customSnackbar(
                                                                                'Successfully',
                                                                                "${rsp['message']}",
                                                                                AppColors.secondary,
                                                                                AppColors.onSecondary,
                                                                                Icons.check);
                                                                          } else {
                                                                            customSnackbar(
                                                                              'Error',
                                                                              rsplib['message'],
                                                                              AppColors.errorContainer,
                                                                              AppColors.onBackground,
                                                                              Icons.warning,
                                                                            );
                                                                          }
                                                                        }
                                                                      } else {
                                                                        var rsplib =
                                                                            await insertIssueRecords(
                                                                          issueTrackerList![i]
                                                                              .uniqueId,
                                                                          'No',
                                                                          '',
                                                                          '',
                                                                          '',
                                                                          '',
                                                                          '',
                                                                          '',
                                                                          '',
                                                                          '',
                                                                          '' as int?,
                                                                        );
                                                                        if (rsplib['status'] ==
                                                                            1) {
                                                                          customSnackbar(
                                                                              'Successfully',
                                                                              "${rsp['message']}",
                                                                              AppColors.secondary,
                                                                              AppColors.onSecondary,
                                                                              Icons.check);
                                                                        } else {
                                                                          customSnackbar(
                                                                            'Error',
                                                                            rsplib['message'],
                                                                            AppColors.errorContainer,
                                                                            AppColors.onBackground,
                                                                            Icons.warning,
                                                                          );
                                                                        }
                                                                      }

                                                                      print(
                                                                          'TABLE of PLAYGROUND ${playgroundIssueList!.length}');
                                                                      if (playgroundIssueList!
                                                                          .isNotEmpty) {
                                                                        for (int i =
                                                                                0;
                                                                            i < playgroundIssueList!.length;
                                                                            i++) {
                                                                          print(
                                                                              'playground records of num row $i');
                                                                          var rspPlay = await insertPlayRecords(
                                                                              playgroundIssueList![i].uniqueId,
                                                                              playgroundIssueList![i].issueExist!,
                                                                              playgroundIssueList![i].issueName!,
                                                                              playgroundIssueList![i].playImg!,
                                                                              playgroundIssueList![i].issueDescription!,
                                                                              playgroundIssueList![i].issueReportOn!,
                                                                              playgroundIssueList![i].issueReportBy!,
                                                                              playgroundIssueList![i].issueResolvedOn!,
                                                                              playgroundIssueList![i].issueResolvedBy!,
                                                                              playgroundIssueList![i].issueStatus!,
                                                                              playgroundIssueList![i].id);
                                                                          if (rspPlay['status'] ==
                                                                              1) {
                                                                            customSnackbar(
                                                                                'Successfully',
                                                                                "${rsp['message']}",
                                                                                AppColors.secondary,
                                                                                AppColors.onSecondary,
                                                                                Icons.check);
                                                                          } else {
                                                                            customSnackbar(
                                                                              'Error',
                                                                              rspPlay['message'],
                                                                              AppColors.errorContainer,
                                                                              AppColors.onBackground,
                                                                              Icons.warning,
                                                                            );
                                                                          }
                                                                        }
                                                                      } else {
                                                                        var rspPlay = await insertPlayRecords(
                                                                            issueTrackerList![i].uniqueId,
                                                                            'No',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '' as int?);
                                                                        if (rspPlay['status'] ==
                                                                            1) {
                                                                          customSnackbar(
                                                                              'Successfully',
                                                                              "${rsp['message']}",
                                                                              AppColors.secondary,
                                                                              AppColors.onSecondary,
                                                                              Icons.check);
                                                                        } else {
                                                                          customSnackbar(
                                                                            'Error',
                                                                            rspPlay['message'],
                                                                            AppColors.errorContainer,
                                                                            AppColors.onBackground,
                                                                            Icons.warning,
                                                                          );
                                                                        }
                                                                      }
                                                                      print(
                                                                          'TABLE of FURNITURE ${furnitureIssueList!.length}');
                                                                      if (furnitureIssueList!
                                                                          .isNotEmpty) {
                                                                        for (int i =
                                                                                0;
                                                                            i < furnitureIssueList!.length;
                                                                            i++) {
                                                                          print(
                                                                              'furniture records of num row $i');
                                                                          var rspFurn =
                                                                              await insertFurnRecords(
                                                                            furnitureIssueList![i].uniqueId,
                                                                            furnitureIssueList![i].issueExist!,
                                                                            furnitureIssueList![i].issueName!,
                                                                            furnitureIssueList![i].furnitureImg!,
                                                                            furnitureIssueList![i].issueDescription!,
                                                                            furnitureIssueList![i].issueReportOn!,
                                                                            furnitureIssueList![i].issueReportBy!,
                                                                            furnitureIssueList![i].issueResolvedOn!,
                                                                            furnitureIssueList![i].issueResolvedBy!,
                                                                            furnitureIssueList![i].issueStatus!,
                                                                            furnitureIssueList![i].id,
                                                                          );
                                                                          if (rspFurn['status'] ==
                                                                              1) {
                                                                            customSnackbar(
                                                                                'Successfully',
                                                                                "${rsp['message']}",
                                                                                AppColors.secondary,
                                                                                AppColors.onSecondary,
                                                                                Icons.check);
                                                                          } else {
                                                                            customSnackbar(
                                                                              'Error',
                                                                              rspFurn['message'],
                                                                              AppColors.errorContainer,
                                                                              AppColors.onBackground,
                                                                              Icons.warning,
                                                                            );
                                                                          }
                                                                        }
                                                                      } else {
                                                                        var rspFurn = await insertFurnRecords(
                                                                            issueTrackerList![i].uniqueId,
                                                                            'No',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '' as int?);
                                                                        if (rspFurn['status'] ==
                                                                            1) {
                                                                          customSnackbar(
                                                                              'Successfully',
                                                                              "${rsp['message']}",
                                                                              AppColors.secondary,
                                                                              AppColors.onSecondary,
                                                                              Icons.check);
                                                                        } else {
                                                                          customSnackbar(
                                                                            'Error',
                                                                            rspFurn['message'],
                                                                            AppColors.errorContainer,
                                                                            AppColors.onBackground,
                                                                            Icons.warning,
                                                                          );
                                                                        }
                                                                      }

                                                                      print(
                                                                          'TABLE of DIGILAB ${digiLabIssueList!.length}');
                                                                      if (digiLabIssueList!
                                                                          .isNotEmpty) {
                                                                        for (int i =
                                                                                0;
                                                                            i < digiLabIssueList!.length;
                                                                            i++) {
                                                                          print(
                                                                              'digilab records of num row $i');
                                                                          var rspDig = await insertDigRecords(
                                                                              digiLabIssueList![i].uniqueId.toString(),
                                                                              digiLabIssueList![i].issueExist!.toString(),
                                                                              digiLabIssueList![i].issueName!,
                                                                              digiLabIssueList![i].digImg!.toString(),
                                                                              digiLabIssueList![i].issueDescription!.toString(),
                                                                              digiLabIssueList![i].issueReportOn!.toString(),
                                                                              digiLabIssueList![i].issueReportBy!.toString(),
                                                                              digiLabIssueList![i].issueResolvedOn!.toString(),
                                                                              digiLabIssueList![i].issueResolvedBy!.toString(),
                                                                              digiLabIssueList![i].issueStatus!.toString(),
                                                                              digiLabIssueList![i].tabletNumber!.toString(),
                                                                              digiLabIssueList![i].id);
                                                                          if (rspDig['status'] ==
                                                                              1) {
                                                                            customSnackbar(
                                                                                'Successfully',
                                                                                "${rsp['message']}",
                                                                                AppColors.secondary,
                                                                                AppColors.onSecondary,
                                                                                Icons.check);
                                                                          } else {
                                                                            customSnackbar(
                                                                              'Error',
                                                                              rspDig['message'],
                                                                              AppColors.errorContainer,
                                                                              AppColors.onBackground,
                                                                              Icons.warning,
                                                                            );
                                                                          }
                                                                        }
                                                                      } else {
                                                                        var rspDig = await insertDigRecords(
                                                                            issueTrackerList![i].uniqueId,
                                                                            'No',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '' as int?);
                                                                        if (rspDig['status'] ==
                                                                            1) {
                                                                          customSnackbar(
                                                                              'Successfully',
                                                                              "${rsp['message']}",
                                                                              AppColors.secondary,
                                                                              AppColors.onSecondary,
                                                                              Icons.check);
                                                                        } else {
                                                                          customSnackbar(
                                                                            'Error',
                                                                            rspDig['message'],
                                                                            AppColors.errorContainer,
                                                                            AppColors.onBackground,
                                                                            Icons.warning,
                                                                          );
                                                                        }
                                                                      }
                                                                      print(
                                                                          'TABLE of ALEXA ${digiLabIssueList!.length}');
                                                                      //for alexa
                                                                      if (alexaIssueList!
                                                                          .isNotEmpty) {
                                                                        print(
                                                                            'alexa records of num row $i');
                                                                        for (int i =
                                                                                0;
                                                                            i < alexaIssueList!.length;
                                                                            i++) {
                                                                          var rspAlexa = await insertAlexaRecords(
                                                                              alexaIssueList![i].uniqueId.toString(),
                                                                              alexaIssueList![i].issueExist!.toString(),
                                                                              alexaIssueList![i].issueName!,
                                                                              alexaIssueList![i].alexaImg!.toString(),
                                                                              alexaIssueList![i].issueDescription!.toString(),
                                                                              alexaIssueList![i].issueReportOn!.toString(),
                                                                              alexaIssueList![i].issueReportBy!.toString(),
                                                                              alexaIssueList![i].issueResolvedOn!.toString(),
                                                                              alexaIssueList![i].issueResolvedBy!.toString(),
                                                                              alexaIssueList![i].issueStatus!.toString(),
                                                                              alexaIssueList![i].other!.toString(),
                                                                              alexaIssueList![i].missingDot!.toString(),
                                                                              alexaIssueList![i].notConfiguredDot!.toString(),
                                                                              alexaIssueList![i].notConnectingDot!.toString(),
                                                                              alexaIssueList![i].notChargingDot!.toString(),
                                                                              alexaIssueList![i].id);
                                                                          if (rspAlexa['status'] ==
                                                                              1) {
                                                                            customSnackbar(
                                                                                'Successfully',
                                                                                "${rsp['message']}",
                                                                                AppColors.secondary,
                                                                                AppColors.onSecondary,
                                                                                Icons.check);
                                                                          } else {
                                                                            customSnackbar(
                                                                              'Error',
                                                                              rspAlexa['message'],
                                                                              AppColors.errorContainer,
                                                                              AppColors.onBackground,
                                                                              Icons.warning,
                                                                            );
                                                                          }
                                                                        }
                                                                      } else {
                                                                        var rspAlexa = await insertAlexaRecords(
                                                                            issueTrackerList![i].uniqueId,
                                                                            'No',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '',
                                                                            '' as int?);
                                                                        if (rspAlexa['status'] ==
                                                                            1) {
                                                                          customSnackbar(
                                                                              'Successfully',
                                                                              "${rsp['message']}",
                                                                              AppColors.secondary,
                                                                              AppColors.onSecondary,
                                                                              Icons.check);
                                                                        } else {
                                                                          customSnackbar(
                                                                            'Error',
                                                                            rspAlexa['message'],
                                                                            AppColors.errorContainer,
                                                                            AppColors.onBackground,
                                                                            Icons.warning,
                                                                          );
                                                                        }
                                                                      }

                                                                      // }
                                                                      double
                                                                          percentage =
                                                                          ((i + 1) /
                                                                              issueTrackerList!.length);
                                                                      setState(
                                                                          () {
                                                                        _percent =
                                                                            percentage;
                                                                      });
                                                                      if (i ==
                                                                          (issueTrackerList!.length -
                                                                              1)) {
                                                                        customSnackbar(
                                                                            ' Synced Successfully',
                                                                            "${rsp['message']}",
                                                                            AppColors.secondary,
                                                                            AppColors.onSecondary,
                                                                            Icons.check);
                                                                      }
                                                                    } else {
                                                                      if (rsp !=
                                                                              null &&
                                                                          rsp.containsKey(
                                                                              'message')) {
                                                                        customSnackbar(
                                                                          'Error',
                                                                          rsp['message'],
                                                                          AppColors
                                                                              .errorContainer,
                                                                          AppColors
                                                                              .onBackground,
                                                                          Icons
                                                                              .warning,
                                                                        );
                                                                      }
                                                                    }
                                                                    setState(
                                                                        () {});

                                                                    print(
                                                                        'ALL data is removed from tables');

                                                                    issueTrackerController
                                                                        .libIssueList
                                                                        .clear();
                                                                    issueTrackerController
                                                                        .digiLabIssueList
                                                                        .clear();
                                                                    issueTrackerController
                                                                        .furnitureIssueList
                                                                        .clear();
                                                                    issueTrackerController
                                                                        .playgroundIssueList
                                                                        .clear();
                                                                    issueTrackerController
                                                                        .issueTrackerList
                                                                        .clear();
                                                                    issueTrackerController
                                                                        .alexaIssueList
                                                                        .clear();

                                                                    isLoading
                                                                            .value =
                                                                        false;

                                                                    // ignore: use_build_context_synchronously
                                                                  }
                                                                }
                                                              }));
                                                }
                                              })),
                                    ],
                                  ));
                  }),
            );
          }),
    );
  }
}

var baseurl = "https://mis.17000ft.org/17000ft_apis/";
Future insertBasicRecords(
  String? tourId,
  String? school,
  String? udiseCode,
  String? correctUdise,
  String? uniqueId,
  String? createdAt,
  int? id,
) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('${baseurl}IssueTracker/issueTrackerSave.php'),
  );

  request.headers["Accept"] = "Application/json";

  // Print the data being sent for debugging purposes
  print('Syncing data:');
  print('tourId: $tourId');
  print('school: $school');
  print('udiseCode: $udiseCode');
  print('correctUdise: $correctUdise');
  print('uniqueId: $uniqueId');
  print('createdAt: $createdAt');
  print('id: $id');

  // Add text fields safely to avoid null values
  request.fields.addAll({
    if (tourId != null) 'tourId': tourId,
    if (school != null) 'school': school,
    if (uniqueId != null) 'unique_id': uniqueId,
    if (createdAt != null) 'createdAt': createdAt,
    if (udiseCode != null) 'udiseCode': udiseCode,
    if (correctUdise != null) 'correctUdise': correctUdise,
  });

  try {
    var response = await request.send();
    var parsedResponse;

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      parsedResponse = json.decode(responseBody);

      print('Response for basic records:');
      print(parsedResponse);

      if (parsedResponse['status'] == 1) {
        await Get.find<IssueTrackerController>().fetchData();

        customSnackbar(
          "${parsedResponse['message']}",
          'Data synced for ${school.toString()}',
          AppColors.primary,
          Colors.white,
          Icons.check,
        );
      } else if (parsedResponse['status'] == 0) {
        customSnackbar(
          "${parsedResponse['message']}",
          'Something went wrong with school ${school.toString()}',
          AppColors.error,
          AppColors.primary,
          Icons.warning,
        );
      }
    } else {
      print('Response status not 200 for basic records');
      var responseBody = await response.stream.bytesToString();
      print('Response body: $responseBody');
    }
    return parsedResponse;
  } catch (error) {
    print('Error occurred during sync: $error');
  }
}

Future insertIssueRecords(
  String? uniqueId,
  String? issueExist,
  String? issueValue,
  String? libImg,
  String? issueDescription,
  String? reportedOn,
  String? reportedBy,
  String? resolvedOn,
  String? resolvedBy,
  String? issueStatus,
  int? id,
) async {
  print('Insert issue records called');
  print('uniqueId: $uniqueId');
  print('issueExist: $issueExist');
  print('issueValue: $issueValue');
  print('issueImgPaths: $libImg');
  print('desc: $issueDescription');
  print('reportedOn: $reportedOn');
  print('reportedBy: $reportedBy');
  print('resolvedOn: $resolvedOn');
  print('resolvedBy: $resolvedBy');
  print('issueStatus: $issueStatus');

  var request = http.MultipartRequest(
    'POST',
    Uri.parse('${baseurl}IssueTracker/issueTrackerSave.php'),
  );
  request.headers["Accept"] = "Application/json";

  // Add text fields safely
  request.fields.addAll({
    'unique_id': uniqueId ?? '',
    'lib_issue': issueExist ?? '',
    'lib_issue_value': issueValue ?? '',
    'lib_desc': issueDescription ?? '',
    'reported_on': reportedOn ?? '',
    'reported_by': reportedBy ?? '',
    'issue_status': issueStatus ?? '',
    'resolved_on': resolvedOn ?? '',
    'resolved_by': resolvedBy ?? '',
  });

  print('Stage 1: Text fields added');

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

  try {
    print('Stage 4: Sending request');
    var response = await request.send();
    var parsedResponse;

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      parsedResponse = json.decode(responseBody);
      print('Response body: $responseBody');

      if (parsedResponse['status'] == 1) {
        print('Stage 7: Successful upload');
        await SqfliteDatabaseHelper().queryDelete(
          arg: uniqueId.toString(),
          table: 'libIssueTable',
          field: 'unique_id',
        );
        await Get.find<IssueTrackerController>().fetchData();

        print('Images uploaded successfully');
      } else {
        print('Failed to upload images. Status code: ${response.statusCode}');
        print('Response body: $responseBody');
      }
    } else {
      print('Failed request. Status code: ${response.statusCode}');
      var responseBody = await response.stream.bytesToString();
      print('Response body: $responseBody');
    }

    print('Stage 8: Exiting function');
    return parsedResponse;
  } catch (error) {
    print('Error uploading images: $error');
  }
}

Future insertPlayRecords(
  String? uniqueId,
  String? issueExist,
  String? issueValue,
  String? playImg,
  String? issueDescription,
  String? reportedOn,
  String? reportedBy,
  String? resolveddOn,
  String? resolvedBy,
  String? issueStatus,
  int? id,
) async {
  print('insert playground is called $uniqueId');
  print(uniqueId);
  print(issueExist);
  print(issueValue);
  print(issueDescription);
  print(playImg);
  print(reportedOn);
  print(reportedBy);
  print(resolveddOn);
  print(resolvedBy);
  print(issueStatus);
  var request = http.MultipartRequest(
      'POST', Uri.parse('${baseurl}IssueTracker/issueTrackerSave.php'));
  request.headers["Accept"] = "Application/json";

  // Add text fields
  request.fields.addAll({
    'unique_id': uniqueId ?? '',
    'play_issue': issueExist.toString(),
    'play_issue_value': issueValue.toString(),
    'play_desc': issueDescription.toString(),
    'play_reported_on': reportedOn.toString(),
    'play_reported_by': reportedBy.toString(),
    'play_issue_status': issueStatus.toString(),
    'play_resolved_on': resolveddOn.toString(),
    'play_resolved_by': resolvedBy.toString(),
  });

  if (playImg != null && playImg.isNotEmpty) {
    // Convert Base64 image to Uint8List
    Uint8List imageBytes = base64Decode(playImg);

    // Create MultipartFile from the image bytes
    var multipartFile = http.MultipartFile.fromBytes(
      'playImg[]', // Name of the field in the server request
      imageBytes,
      filename: 'playImg${id ?? ''}.jpg', // Custom file name
      contentType: MediaType('image', 'jpeg'), // Specify the content type
    );

    // Add the image to the request
    request.files.add(multipartFile);
  }

  try {
    var response = await request.send();
    var parsedResponse;
    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      parsedResponse = json.decode(responseBody);
      if (parsedResponse['status'] == 1) {
        await SqfliteDatabaseHelper().queryDelete(
          arg: uniqueId.toString(),
          table: 'play_issue',
          field: 'unique_id',
        );
        await Get.find<IssueTrackerController>().fetchData();

        print('Response body: $responseBody');
        print('Images uploaded successfully $responseBody');
      } else {
        print('Failed to upload images. Status code: ${response.statusCode}');
        var responseBody = await response.stream.bytesToString();
        print('Response body: $responseBody');
      }
    }
    return parsedResponse;
  } catch (error) {
    print('Error uploading images: $error');
  }
}

Future insertFurnRecords(
  String? uniqueId,
  String? issueExist,
  String? issueValue,
  String? furnitureImg,
  String? issueDescription,
  String? reportedOn,
  String? reportedBy,
  String? resolveddOn,
  String? resolvedBy,
  String? issueStatus,
  int? id,
) async {
  print('insert issue is called Furn $uniqueId');
  print(uniqueId);
  print(issueExist);
  print(issueValue);
  print(furnitureImg);
  print(issueDescription);
  print(reportedOn);
  print(reportedBy);
  print(resolveddOn);
  print(resolvedBy);
  print(issueStatus);
  var request = http.MultipartRequest(
      'POST', Uri.parse('${baseurl}IssueTracker/issueTrackerSave.php'));
  request.headers["Accept"] = "Application/json";

  // Add text fields
  request.fields.addAll({
    'unique_id': uniqueId ?? '',
    'furn_issue': issueExist.toString(),
    'furn_issue_value': issueValue.toString(),
    'furn_desc': issueDescription.toString(),
    'furn_reported_on': reportedOn.toString(),
    'furn_reported_by': reportedBy.toString(),
    'furn_issue_status': issueStatus.toString(),
    'furn_resolved_on': resolveddOn.toString(),
    'furn_resolved_by': resolvedBy.toString(),
  });
  if (furnitureImg != null && furnitureImg.isNotEmpty) {
    // Convert Base64 image to Uint8List
    Uint8List imageBytes = base64Decode(furnitureImg);

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

  try {
    var response = await request.send();
    var parsedResponse;

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      parsedResponse = json.decode(responseBody);
      if (parsedResponse['status'] == 1) {
        await SqfliteDatabaseHelper().queryDelete(
          arg: uniqueId.toString(),
          table: 'furniture_issue',
          field: 'unique_id',
        );
        await Get.find<IssueTrackerController>().fetchData();

        print('Response body: $responseBody');
        print('Images uploaded successfully $responseBody');
      } else {
        print('Failed to upload images. Status code: ${response.statusCode}');
        var responseBody = await response.stream.bytesToString();
        print('Response body: $responseBody');
      }
    }
    return parsedResponse;
  } catch (error) {
    print('Error uploading images: $error');
  }
}

Future insertDigRecords(
  String? uniqueId,
  String? issueExist,
  String? issueValue,
  String? digImg,
  String? issueDescription,
  String? reportedOn,
  String? reportedBy,
  String? resolveddOn,
  String? resolvedBy,
  String? issueStatus,
  String? tabletNumber,
  int? id,
) async {
  print('insert issue is called for digilab $uniqueId');
  print(uniqueId);
  print(issueExist);
  print(issueValue);
  print(digImg);
  print(issueDescription);
  print(reportedOn);
  print(reportedBy);
  print(resolveddOn);
  print(resolvedBy);
  print(issueStatus);
  print(tabletNumber);

  var request = http.MultipartRequest(
      'POST', Uri.parse('${baseurl}IssueTracker/issueTrackerSave.php'));

  request.headers["Accept"] = "Application/json";

  // Add text fields
  request.fields.addAll({
    'unique_id': uniqueId ?? '',
    'digi_issue': issueExist.toString(),
    'digi_issue_value': issueValue.toString(),
    'digi_desc': issueDescription.toString(),
    'digi_reported_on': reportedOn.toString(),
    'digi_reported_by': reportedBy.toString(),
    'digi_issue_status': issueStatus.toString(),
    'digi_resolved_on': resolveddOn.toString(),
    'digi_resolved_by': resolvedBy.toString(),
    'tablet_number': tabletNumber.toString(),
  });

  if (digImg != null && digImg.isNotEmpty) {
    // Convert Base64 image to Uint8List
    Uint8List imageBytes = base64Decode(digImg);

    // Create MultipartFile from the image bytes
    var multipartFile = http.MultipartFile.fromBytes(
      'digImg[]', // Name of the field in the server request
      imageBytes,
      filename: 'digImg${id ?? ''}.jpg', // Custom file name
      contentType: MediaType('image', 'jpeg'), // Specify the content type
    );

    // Add the image to the request
    request.files.add(multipartFile);
  }

  try {
    var response = await request.send();
    var parsedResponse;

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      parsedResponse = json.decode(responseBody);
      if (parsedResponse['status'] == 1) {
        await SqfliteDatabaseHelper().queryDelete(
          arg: uniqueId.toString(),
          table: 'digiLab_issue',
          field: 'unique_id',
        );
        await Get.find<IssueTrackerController>().fetchData();

        print('Response body: $responseBody');
        print('Images uploaded successfully $responseBody');
      } else {
        print('Failed to upload images. Status code: ${response.statusCode}');
        var responseBody = await response.stream.bytesToString();
        print('Response body: $responseBody');
      }
    }
    return parsedResponse;
  } catch (error) {
    print('Error uploading images: $error');
  }
}

//insert Alexa Issues
Future insertAlexaRecords(
  String? uniqueId,
  String? issueExist,
  String? issueValue,
  String? alexaImg,
  String? issueDescription,
  String? reportedOn,
  String? reportedBy,
  String? resolveddOn,
  String? resolvedBy,
  String? issueStatus,
  String? other,
  String? missing,
  String? notConfigured,
  String? notConnecting,
  String? notCharging,
  int? id,
) async {
  var request = http.MultipartRequest(
      'POST', Uri.parse('${baseurl}IssueTracker/issueTrackerSave.php'));
  request.headers["Accept"] = "Application/json";

  // Add text fields
  request.fields.addAll({
    'unique_id': uniqueId ?? '',
    'alexa_issue': issueExist.toString(),
    'alexa_issue_value': issueValue.toString(),
    'alexa_desc': issueDescription.toString(),
    'alexa_reported_on': reportedOn.toString(),
    'alexa_reported_by': reportedBy.toString(),
    'alexa_issue_status': issueStatus.toString(),
    'alexa_resolved_on': resolveddOn.toString(),
    'alexa_resolved_by': resolvedBy.toString(),
    'other': other.toString(),
    'missing': missing.toString(),
    'not_configured': notConfigured.toString(),
    'not_connecting': notConnecting.toString(),
    'not_charging': notCharging.toString(),
  });
  if (alexaImg != null && alexaImg.isNotEmpty) {
    // Convert Base64 image to Uint8List
    Uint8List imageBytes = base64Decode(alexaImg);

    // Create MultipartFile from the image bytes
    var multipartFile = http.MultipartFile.fromBytes(
      'alexaImg[]', // Name of the field in the server request
      imageBytes,
      filename: 'alexaImg${id ?? ''}.jpg', // Custom file name
      contentType: MediaType('image', 'jpeg'), // Specify the content type
    );

    // Add the image to the request
    request.files.add(multipartFile);
  }
  try {
    var response = await request.send();
    var parsedResponse;

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      parsedResponse = json.decode(responseBody);
      if (parsedResponse['status'] == 1) {
        await SqfliteDatabaseHelper().queryDelete(
          arg: uniqueId.toString(),
          table: 'alexa_issues',
          field: 'unique_id',
        );
        await SqfliteDatabaseHelper().queryDelete(
          arg: uniqueId.toString(),
          table: 'issueTracker_basic',
          field: 'unique_id',
        );
        await Get.find<IssueTrackerController>().fetchData();

        print('Response body: $responseBody');
        print('Images uploaded successfully $responseBody');
      } else {
        print('Failed to upload images. Status code: ${response.statusCode}');
        var responseBody = await response.stream.bytesToString();
        print('Response body: $responseBody');
      }
    }
    return parsedResponse;
  } catch (error) {
    print('Error uploading images: $error');
  }
}
