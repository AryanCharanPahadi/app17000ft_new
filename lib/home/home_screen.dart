import 'package:app17000ft_new/components/circular_indicator.dart';
import 'package:app17000ft_new/components/custom_appBar.dart';
import 'package:app17000ft_new/components/custom_drawer.dart';
import 'package:app17000ft_new/constants/color_const.dart';
import 'package:app17000ft_new/forms/fln_observation_form/fln_observation_form.dart';
import 'package:app17000ft_new/forms/inPerson_qualitative_form/inPerson_qualitative_form.dart';
import 'package:app17000ft_new/forms/in_person_quantitative/in_person_quantitative.dart';
import 'package:app17000ft_new/forms/school_enrolment/school_enrolment.dart';
import 'package:app17000ft_new/forms/school_recce_form/school_recce_form.dart';
import 'package:app17000ft_new/helper/responsive_helper.dart';
import 'package:app17000ft_new/home/home_controller.dart';
import 'package:app17000ft_new/home/tour_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app17000ft_new/database/baseDB_controller.dart';
import 'package:app17000ft_new/helper/shared_prefernce.dart';

import '../forms/alfa_observation_form/alfa_observation_form.dart';
import '../forms/cab_meter_tracking_form/cab_meter.dart';
import '../forms/issue_tracker/issue_tracker_form.dart';
import '../forms/school_facilities_&_mapping_form/SchoolFacilitiesForm.dart';
import '../forms/school_staff_vec_form/school_vec_from.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize any other state-related things here if needed.
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Custom back button behavior for Screen1
        Navigator.pop(context); // Pop the current route
        return false; // Return false to prevent default back button behavior
      },
      child: Scaffold(
        appBar:  const CustomAppbar(title: 'Home'),
        drawer:  const CustomDrawer(),
        body: GetBuilder<HomeController>(
          init: HomeController(),
          builder: (homeController) {
            if (homeController.isLoading) {
              return  const Center(
                child: TextWithCircularProgress(text:'Loading...',indicatorColor: AppColors.primary,fontsize: 14,strokeSize: 2,),
              );
            }

            return homeController.offlineTaskList.isNotEmpty
                ? Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          AppColors.inverseOnSurface,
                          AppColors.outlineVariant,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(8),
                              itemCount: homeController.offlineTaskList.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: responsive.responsiveValue(
                                  small: 2,
                                  medium: 4,
                                  large: 5,
                                ),
                                crossAxisSpacing: responsive.responsiveValue(
                                  small: 20.0,
                                  medium: 50.0,
                                  large: 60.0,
                                ),
                                childAspectRatio: 1.3,
                                mainAxisSpacing: responsive.responsiveValue(
                                  small: 30.0,
                                  medium: 50.0,
                                  large: 60.0,
                                ),
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.background,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 5,
                                        blurRadius: 4,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        if (homeController.offlineTaskList[index] == 'School Enrollment Form') {
                                        Get.to(() =>  SchoolEnrollmentForm(userid:homeController.empId));
                                      
                                        }else if(homeController.offlineTaskList[index] == 'Cab Meter Tracing Form') {
                                          Get.to(() =>  CabMeterTracingForm(userid:homeController.empId,office:homeController.office ,));
                            
                                        }else if(homeController.offlineTaskList[index] == 'In Person Monitoring Quantitative'){
                                          Get.to(() =>  InPersonQuantitative(userid:homeController.empId,office:homeController.office ,));
                                        }
                                        else if(homeController.offlineTaskList[index] == 'School Facilities Mapping Form'){
                                          Get.to(() =>  SchoolFacilitiesForm(userid:homeController.empId,office:homeController.office ,));
                                        }
                                        else if(homeController.offlineTaskList[index] == 'School Staff & SMC/VEC Details'){
                                          Get.to(() =>  SchoolStaffVecForm(userid:homeController.empId,office:homeController.office ,));
                                        }
                                        else if(homeController.offlineTaskList[index] == 'Issue Tracker (New)'){
                                          Get.to(() =>  IssueTrackerForm(userid:homeController.empId,office:homeController.office ,));
                                        }
                                        else if(homeController.offlineTaskList[index] == 'ALfA Observation Form'){
                                          Get.to(() =>  AlfaObservationForm(userid:homeController.empId,office:homeController.office ,));
                                        }
                                        else if(homeController.offlineTaskList[index] == 'FLN Observation Form'){
                                          Get.to(() =>  FlnObservationForm(userid:homeController.empId,office:homeController.office ,));
                                        }
                                        else if(homeController.offlineTaskList[index] == 'In Person Monitoring Qualitative'){
                                          Get.to(() =>  InPersonQualitativeForm(userid:homeController.empId,office:homeController.office ,));
                                        }
                                        else if(homeController.offlineTaskList[index] == 'School Recce Form'){
                                          Get.to(() =>  SchoolRecceForm(userid:homeController.empId,office:homeController.office ,));
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          homeController.offlineTaskList[index].toString(),
                                          textAlign: TextAlign.center,
                                          style: AppStyles.captionText(
                                            context,
                                            AppColors.onBackground,
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.onSurface,
                          AppColors.tertiaryFixedDim,
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                    ),
                    child: const Center(child: Text('No Data Found')),
                  );
          },
        ),
      ),
    );
  }
}
