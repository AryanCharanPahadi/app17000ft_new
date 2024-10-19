import 'package:app17000ft_new/components/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../constants/color_const.dart';
import '../forms/alfa_observation_form/alfa_observation_sync.dart';
import '../forms/cab_meter_tracking_form/cab_meter_tracing_sync.dart';
import '../forms/edit_form/edit_form_page.dart';
import '../forms/fln_observation_form/fln_observation_sync.dart';
import '../forms/inPerson_qualitative_form/inPerson_qualitative_sync.dart';
import '../forms/in_person_quantitative/in_person_quantitative_sync.dart';
import '../forms/issue_tracker/issue_tracker_sync.dart';
import '../forms/school_enrolment/school_enrolment_sync.dart';
import '../forms/school_facilities_&_mapping_form/school_facilities_sync.dart';
import '../forms/school_recce_form/school_recce_sync.dart';
import '../forms/school_staff_vec_form/school_vec_sync.dart';
import '../helper/responsive_helper.dart';
import '../helper/shared_prefernce.dart';
import '../home/home_screen.dart';
import '../home/tour_data.dart';
import '../login/login_screen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final UserController _userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Drawer(
      backgroundColor: AppColors.background,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          GestureDetector(
            onTap: _userController.loadUserData, // Refresh user data on tap
            child: Container(
              color: AppColors.primary,
              height: responsive.responsiveValue(
                  small: 250.0, medium: 260.0, large: 280.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Username Text
                    Obx(() => Text(
                      _userController.username.value.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: responsive.responsiveValue(
                            small: 18, medium: 20, large: 22),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    )),
                    const SizedBox(height: 8),

                    // Office Name Text
                    Obx(() => Text(
                      _userController.officeName.value.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: responsive.responsiveValue(
                            small: 16, medium: 18, large: 20),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    )),
                    const SizedBox(height: 8),

                    // Version Text
                    Text(
                   '4.0.0',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: responsive.responsiveValue(
                            small: 14, medium: 16, large: 18),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Drawer menu items
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
            icons: const FaIcon(FontAwesomeIcons.penToSquare),
            onPressed: () {
              Navigator.pop(context);
              Get.to(() => EditFormPage()); // Navigate to the Edit Form Screen
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
            },
          ),

          DrawerMenu(
            title: 'In Person Quantitative Sync',
            icons: const FaIcon(FontAwesomeIcons.database),
            onPressed: () async {
              await SharedPreferencesHelper.logout();
              await Get.to(() => const InPersonQuantitativeSync());
            },
          ),

          DrawerMenu(
            title: 'School Facilities Mapping Form Sync',
            icons: const FaIcon(FontAwesomeIcons.database),
            onPressed: () async {
              await SharedPreferencesHelper.logout();
              await Get.to(() => const SchoolFacilitiesSync());
            },
          ),

          DrawerMenu(
            title: 'School Staff & SMC/VEC Details Sync',
            icons: const FaIcon(FontAwesomeIcons.database),
            onPressed: () async {
              await SharedPreferencesHelper.logout();
              await Get.to(() => const SchoolStaffVecSync());
            },
          ),

          DrawerMenu(
            title: 'Issue Tracker Sync',
            icons: const FaIcon(FontAwesomeIcons.database),
            onPressed: () async {
              await SharedPreferencesHelper.logout();
              await Get.to(() =>  const FinalIssueTrackerSync());
            },
          ),

          DrawerMenu(
            title: 'Alfa Observation Sync',
            icons: const FaIcon(FontAwesomeIcons.database),
            onPressed: () async {
              await SharedPreferencesHelper.logout();
              await Get.to(() => const AlfaObservationSync());
            },
          ),

          DrawerMenu(
            title: 'FLN Observation Sync',
            icons: const FaIcon(FontAwesomeIcons.database),
            onPressed: () async {
              await SharedPreferencesHelper.logout();
              await Get.to(() => const FlnObservationSync());
            },
          ),

          DrawerMenu(
            title: 'IN-Person Qualitative Sync',
            icons: const FaIcon(FontAwesomeIcons.database),
            onPressed: () async {
              await SharedPreferencesHelper.logout();
              await Get.to(() => const InpersonQualitativeSync());
            },
          ),

          DrawerMenu(
            title: 'School Recce Sync',
            icons: const FaIcon(FontAwesomeIcons.database),
            onPressed: () async {
              await SharedPreferencesHelper.logout();
              await Get.to(() => const SchoolRecceSync());
            },
          ),

          DrawerMenu(
            title: 'Logout',
            icons: const FaIcon(FontAwesomeIcons.signOut),
            onPressed: () async {
              final UserController userController = Get.find<UserController>();

              // Clear user data from memory
              userController.clearUserData();

              // Clear user data from SharedPreferences
              await SharedPreferencesHelper.logout();

              // Navigate to the login screen
              Get.offAll(() => const LoginScreen());
            },
          ),

        ],
      ),
    );
  }
}

class DrawerMenu extends StatelessWidget {
  final String? title;
  final FaIcon? icons;
  final Function? onPressed;

  const DrawerMenu({
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
          style: TextStyle(
              color: AppColors.onBackground,
              fontSize: 14,
              fontWeight: FontWeight.w600)),
      onTap: () {
        if (onPressed != null) {
          onPressed!(); // Call the function using parentheses
        }
      },
    );
  }
}
