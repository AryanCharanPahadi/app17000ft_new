// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:app17000ft_new/constants/color_const.dart';
import 'package:app17000ft_new/forms/alfa_observation_form/alfa_observation_sync.dart';
import 'package:app17000ft_new/forms/fln_observation_form/fln_observation_sync.dart';
import 'package:app17000ft_new/forms/issue_tracker/issue_tracker_sync.dart';
import 'package:app17000ft_new/forms/school_enrolment/school_enrolment_sync.dart';
import 'package:app17000ft_new/forms/school_facilities_&_mapping_form/school_facilities_sync.dart';
import 'package:app17000ft_new/helper/responsive_helper.dart';
import 'package:app17000ft_new/helper/shared_prefernce.dart';
import 'package:app17000ft_new/home/home_screen.dart';
import 'package:app17000ft_new/home/tour_data.dart';
import 'package:app17000ft_new/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';

import '../forms/cab_meter_tracking_form/cab_meter_tracing_sync.dart';
import '../forms/edit_form/edit_form_page.dart';
import '../forms/inPerson_qualitative_form/inPerson_qualitative_sync.dart';
import '../forms/in_person_quantitative/in_person_quantitative_sync.dart';
import '../forms/school_recce_form/school_recce_sync.dart';
import '../forms/school_staff_vec_form/school_vec_sync.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    return Drawer(
      backgroundColor: AppColors.background,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: AppColors.background,
            height: responsive.responsiveValue(
                small: 200.0, medium: 210.0, large: 220.0),
            width: responsive.responsiveValue(
                small: 320.0, medium: 330.0, large: 340.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.background,
                  image: DecorationImage(
                    image: AssetImage('assets/check.png'),
                  ),
                ),
              ),
            ),
          ),
          DrawerMenu(
            title: 'Home',
            icons: const FaIcon(FontAwesomeIcons.home),
            onPressed: () {
              Navigator.pop(context);
              Get.to(() => const HomeScreen());
            },
          ),

          DrawerMenu(
            title: 'Edit Form',
            icons: const FaIcon(FontAwesomeIcons.edit),
            onPressed: () {
              Navigator.pop(context);
              Get.to(() =>  TourSchoolSelection ()); // Navigate to the Edit Form Screen
            },
          ),

          DrawerMenu(
            title: 'Tour Data',
            icons: const FaIcon(FontAwesomeIcons.home),
            onPressed: () {
              Get.to(() => const SelectTourData());
            },
          ),

          DrawerMenu(
            title: 'Enrolment Sync',
            icons: const FaIcon(FontAwesomeIcons.database),
            onPressed: () async {
              await SharedPreferencesHelper.logout();
              await Get.to(() => const EnrolmentSync());
            },
          ),
          DrawerMenu(
              title: 'Cab Meter Tracing Sync',
              icons: const FaIcon(FontAwesomeIcons.database),
              onPressed: () async {
                await SharedPreferencesHelper.logout();
                await Get.to(() => const CabTracingSync());
              }),
          DrawerMenu(
              title: 'In Person Quantitative Sync',
              icons: const FaIcon(FontAwesomeIcons.database),
              onPressed: () async {
                await SharedPreferencesHelper.logout();
                await Get.to(() => const InPersonQuantitativeSync());
              }),
          DrawerMenu(
              title: 'School Facilities Mapping Form Sync',
              icons: const FaIcon(FontAwesomeIcons.database),
              onPressed: () async {
                await SharedPreferencesHelper.logout();
                await Get.to(() => const SchoolFacilitiesSync());
              }),
          DrawerMenu(
              title: 'School Staff & SMC/VEC Details Sync',
              icons: const FaIcon(FontAwesomeIcons.database),
              onPressed: () async {
                await SharedPreferencesHelper.logout();
                await Get.to(() => const SchoolStaffVecSync());
              }),
          DrawerMenu(
              title: 'Issue Tracker Sync',
              icons: const FaIcon(FontAwesomeIcons.database),
              onPressed: () async {
                await SharedPreferencesHelper.logout();
                await Get.to(() => const FinalIssueTrackerSync());
              }),
          DrawerMenu(
              title: 'Alfa Observation Sync',
              icons: const FaIcon(FontAwesomeIcons.database),
              onPressed: () async {
                await SharedPreferencesHelper.logout();
                await Get.to(() => const AlfaObservationSync());
              }),
          DrawerMenu(
              title: 'FLN Observation Sync',
              icons: const FaIcon(FontAwesomeIcons.database),
              onPressed: () async {
                await SharedPreferencesHelper.logout();
                await Get.to(() => const FlnObservationSync());
              }),
          DrawerMenu(
              title: 'IN-Person Qualitative Sync',
              icons: const FaIcon(FontAwesomeIcons.database),
              onPressed: () async {
                await SharedPreferencesHelper.logout();
                await Get.to(() => const InpersonQualitativeSync());
              }),

          DrawerMenu(
              title: 'School Recce Sync',
              icons: const FaIcon(FontAwesomeIcons.database),
              onPressed: () async {
                await SharedPreferencesHelper.logout();
                await Get.to(() => const SchoolRecceSync());
              }),



          DrawerMenu(
            title: 'Logout',
            icons: const FaIcon(FontAwesomeIcons.signOut),
            onPressed: () async {
              await SharedPreferencesHelper.logout();
              await Get.to(() => const LoginScreen());
            },
          ),
        ],
      ),
    );
  }
}


class DrawerMenu extends StatelessWidget {
  String? title;
  FaIcon? icons;
  Function? onPressed;
  DrawerMenu({
    super.key,
    this.title,
    this.icons,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icons,
      title: Text(title ?? '',
          style: AppStyles.inputLabel(context, AppColors.onBackground, 14)),
      onTap: () {
        if (onPressed != null) {
          onPressed!(); // Call the function using parentheses
        }
      },
    );
  }
}
