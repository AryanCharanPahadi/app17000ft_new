import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../components/custom_appBar.dart';
import '../../components/custom_dropdown.dart';
import '../../components/custom_labeltext.dart';
import '../../tourDetails/tour_controller.dart';
import '../school_facilities_&_mapping_form/SchoolFacilitiesForm.dart';
import '../school_facilities_&_mapping_form/school_facilities_modals.dart';
import '../school_staff_vec_form/school_vec_from.dart';
import '../school_staff_vec_form/school_vec_modals.dart';
import 'edit controller.dart';

class TourSchoolSelection extends StatefulWidget {
  const TourSchoolSelection({Key? key}) : super(key: key);

  @override
  _TourSchoolSelectionState createState() => _TourSchoolSelectionState();
}
class _TourSchoolSelectionState extends State<TourSchoolSelection> {
  Map<String, dynamic> allTourData = {}; // Store data for all tours
  List<String> schoolNames = [];
  String? selectedSchool;
  String? selectedForm;
  String? selectedTourId; // Track the selected tourId
  List<dynamic> filteredData = [];
  bool isLoading = false;
  bool isOffline = false; // Track offline state

  @override
  void initState() {
    super.initState();
    loadSavedData(); // Load saved data on app start
    monitorConnectivity(); // Start monitoring connectivity
  }

  // Monitor connectivity changes
  void monitorConnectivity() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        // No internet, go offline
        setState(() {
          isOffline = true;
        });
        Get.snackbar('Offline', 'You are offline. Showing last fetched data.');
      } else {
        // Internet available, go online and fetch fresh data
        setState(() {
          isOffline = false;
        });
        if (selectedTourId != null) {
          fetchTourData(selectedTourId!);
        }
        Get.snackbar('Online', 'You are online. Fetching fresh data.');
      }
    });
  }

  // Fetch data for a given tour when online
  Future<void> fetchTourData(String tourId) async {
    if (isOffline) return; // Don't fetch data if offline

    // Check if data is already available locally for this tour
    if (allTourData.containsKey(tourId)) {
      filterSchoolsByTour(tourId); // Show cached data immediately
    }

    setState(() {
      isLoading = true;
    });

    final url = 'https://mis.17000ft.org/apis/fast_apis/pre-fill-data.php?id=$tourId';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Merge or replace the newly fetched data with existing data
        setState(() {
          allTourData[tourId] = data; // Store data for this tourId
        });

        // Save all fetched tour data locally
        await saveDataLocally(allTourData);

        // Update the school list for the selected tourId
        filterSchoolsByTour(tourId);
      } else {
        Get.snackbar('Error', 'Failed to load tour data');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching data');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Save all tour data locally using SharedPreferences
  Future<void> saveDataLocally(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the already saved tour data
    final savedData = prefs.getString('allTourData');
    Map<String, dynamic> existingData = {};

    if (savedData != null) {
      existingData = json.decode(savedData); // Load previously saved data
    }

    // Merge the new data with existing data
    existingData.addAll(data);

    // Save the merged data back to SharedPreferences
    await prefs.setString('allTourData', json.encode(existingData));
  }

  // Load saved data from SharedPreferences when offline
  Future<void> loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('allTourData');

    if (savedData != null) {
      setState(() {
        allTourData = json.decode(savedData); // Load all saved tour data
      });

      // Update the UI to reflect the loaded data
      if (selectedTourId != null) {
        filterSchoolsByTour(selectedTourId!); // Filter based on last selected tour
      }
    }
  }

  // Update school list when a tour is selected
  void onTourSelected(String? tourId) {
    if (tourId != null) {
      setState(() {
        selectedTourId = tourId; // Set the selected tourId
        selectedSchool = null;
        filteredData = [];
        selectedForm = null;
      });
      // Filter schools for the selected tour
      filterSchoolsByTour(tourId);

      // If online, fetch fresh data for the selected tour
      if (!isOffline) {
        fetchTourData(tourId);
      }
    }
  }

  // Filter schools based on the selected tourId
  void filterSchoolsByTour(String tourId) {
    setState(() {
      if (allTourData.containsKey(tourId)) {
        schoolNames = (allTourData[tourId] as Map<String, dynamic>).keys.toList();
      } else {
        schoolNames = [];
      }
    });
  }

  // Update school selection
  void onSchoolSelected(String? schoolName) {
    setState(() {
      selectedSchool = schoolName;
      filteredData = [];
      selectedForm = null; // Reset form selection
    });
  }

  // Update form selection and fetch data accordingly
  void onFormSelected(String? formType) {
    setState(() {
      selectedForm = formType;
    });

    if (selectedSchool != null && selectedForm != null) {
      final formData = allTourData[selectedTourId]?[selectedSchool]?[selectedForm];
      setState(() {
        filteredData = formData != null && formData.isNotEmpty
            ? formData
            : []; // If empty, set as empty list
      });
    }
  }

  // Display snackbar on edit button press
  void onEditButtonPressed(int index) {
    Get.snackbar('Edit', 'Edit button pressed for index $index');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Edit Form',
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GetBuilder<EditController>(
              init: EditController(),
              builder: (editController) {
                return Form(
                  key: GlobalKey<FormState>(),
                  child: GetBuilder<TourController>(
                    init: TourController(),
                    builder: (tourController) {
                      tourController.fetchTourDetails();

                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Tour ID Dropdown
                            LabelText(
                              label: 'Tour ID',
                              astrick: true,
                            ),
                            const SizedBox(height: 12),
                            // Ensure you set the selected tour value in the onChanged method
                            CustomDropdownFormField(
                              focusNode: editController.tourIdFocusNode,
                              options: tourController.getLocalTourList
                                  .map((e) => e.tourId?.toString() ?? "") // Convert tourId to String
                                  .toList(),
                              selectedOption: editController.tourValue, // This should hold the selected tourId value
                              onChanged: (value) {
                                setState(() {
                                  editController.setTour(value); // Use setTour method to update the value
                                });
                                onTourSelected(value); // Handle tour selection logic
                              },
                              labelText: "Select Tour ID",
                            ),


                            const SizedBox(height: 20),

                            // School Dropdown
                            if (schoolNames.isNotEmpty) ...[
                              LabelText(
                                label: 'School',
                                astrick: true,
                              ),
                              const SizedBox(height: 12),
                              DropdownSearch<String>(
                                items: schoolNames,
                                dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "Select School",
                                    hintText: "Select School",
                                  ),
                                ),
                                onChanged: onSchoolSelected,
                                selectedItem: selectedSchool,
                              ),
                              const SizedBox(height: 20),
                            ],

                            // Form Type Dropdown (facilities, enrollment, vec)
                            if (selectedSchool != null) ...[
                              LabelText(
                                label: 'Form Type',
                                astrick: true,
                              ),
                              const SizedBox(height: 12),
                              DropdownSearch<String>(
                                items: ['facilities', 'enrollment', 'vec'],
                                dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "Select Form",
                                    hintText: "Select Form Type",
                                  ),
                                ),
                                onChanged: onFormSelected,
                                selectedItem: selectedForm,
                              ),
                              const SizedBox(height: 20),
                            ],

                            // Show loader while fetching data
                            if (isLoading)
                              const Center(child: CircularProgressIndicator()),

                            // Display selected form data or No Records message
                            if (selectedSchool != null && selectedForm != null)
                              Container(
                                height: constraints.maxHeight * 0.5, // Responsiveness
                                child: ListView(
                                    children: [
                                      if (filteredData.isEmpty)
                                        const Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Text('No records found',
                                              style: TextStyle(fontSize: 16)),
                                        ),

                                      // Enrollment Section
                                      if (selectedForm == 'enrollment' &&
                                          filteredData.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Enrollment Data:',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              ...List.generate(
                                                filteredData.length,
                                                    (index) {
                                                  final enrollment = filteredData[index];
                                                  return Card(
                                                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                                                    child: ListTile(
                                                      title: Text(enrollment['school']),
                                                      subtitle: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("Grade: ${enrollment['grade']}"),
                                                          Text("No. of Boys: ${enrollment['noBoys']}"),
                                                          Text("No. of Girls: ${enrollment['noGirls']}"),
                                                          Text("Remarks: ${enrollment['remarks']}"),
                                                          Text("Created at: ${enrollment['created_at']}"),
                                                        ],
                                                      ),
                                                      trailing: IconButton(
                                                        icon: Icon(Icons.edit),
                                                        onPressed: () =>
                                                            onEditButtonPressed(index),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),

                                      // Facilities Section
                                      // Facilities Section
                                      if (selectedForm == 'facilities' && filteredData.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Facilities Data:',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              ...List.generate(
                                                filteredData.length,
                                                    (index) {
                                                  final facility = filteredData[index];
                                                  return Card(
                                                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                                                    child: ListTile(
                                                      title: Text('Tour ID: ${facility['tourId']}'),
                                                      subtitle: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("Residential Value: ${facility['residentialValue']}"),
                                                          Text("Electricity Value: ${facility['electricityValue']}"),
                                                          Text("Internet Value: ${facility['internetValue']}"),



                                                          Text("School: ${facility['school']}"),
                                                          // Add more fields here as necessary
                                                        ],
                                                      ),
                                                      trailing: IconButton(
                                                        icon: Icon(Icons.edit),
                                                        onPressed: () {
                                                          // Navigate to the SchoolFacilitiesForm and pass the selected facility record
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => SchoolFacilitiesForm(
                                                                userid: 'userid',  // Pass necessary userId and office
                                                                // or fetch from the current context if available
                                                                existingRecord: SchoolFacilitiesRecords(
                                                                  tourId: facility['tourId'],
                                                                  residentialValue: facility['residentialValue'],
                                                                  electricityValue: facility['electricityValue'],
                                                                  internetValue: facility['internetValue'],
                                                                  udiseCode: facility['udiseValue'],
                                                                  correctUdise: facility['correctUdise'],
                                                                  school: facility['school'],
                                                                  projectorValue: facility['projectorValue'],
                                                                  smartClassValue: facility['smartClassValue'],
                                                                  numFunctionalClass: facility['numFunctionalClass'],
                                                                  playgroundValue: facility['playgroundValue'],
                                                                  libValue: facility['libValue'],
                                                                  libLocation: facility['libLocation'],
                                                                  librarianName: facility['librarianName'],
                                                                  librarianTraining: facility['librarianTraining'],
                                                                  libRegisterValue: facility['libRegisterValue'],
                                                                  created_by: facility['created_by'],
                                                                  created_at: facility['created_at'],
                                                                  // Map more fields here if needed
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),



                                      // VEC Section
                                      // VEC Section
                                      if (selectedForm == 'vec' && filteredData.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'VEC Data:',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              ...List.generate(
                                                filteredData.length,
                                                    (index) {
                                                  final vec = filteredData[index];
                                                  return Card(
                                                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                                                    child: ListTile(
                                                      title: Text('VEC Name: ${vec['SmcVecName'] ?? "N/A"}'),
                                                      subtitle: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("headName: ${vec['headName']}"),
                                                          Text("headMobile: ${vec['headMobile']}"),
                                                          Text("headDesignation Held: ${vec['headDesignation']}"),
                                                          Text("SmcVecName: ${vec['SmcVecName']}"),
                                                          Text("vecMobile: ${vec['vecMobile']}"),
                                                        ],
                                                      ),
                                                      trailing: IconButton(
                                                        icon: Icon(Icons.edit),
                                                        onPressed: () {
                                                          // Navigate to the SchoolFacilitiesForm and pass the selected facility record
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => SchoolStaffVecForm(
                                                                userid: 'userid',  // Pass necessary userId and office
                                                                // or fetch from the current context if available
                                                                existingRecords: SchoolStaffVecRecords(
                                                                  tourId: vec['tourId'],
                                                                  school: vec['school'],
                                                                  headName: vec['headName'],
                                                                  headGender: vec['headGender'],
                                                                  udiseValue: vec['udiseValue'],
                                                                  correctUdise: vec['correctUdise'],
                                                                  headMobile: vec['headMobile'],
                                                                  headEmail: vec['headEmail'],
                                                                  headDesignation: vec['headDesignation'],
                                                                  totalTeachingStaff: vec['totalTeachingStaff'],
                                                                  totalNonTeachingStaff: vec['totalNonTeachingStaff'],
                                                                  totalStaff: vec['totalStaff'],
                                                                  SmcVecName: vec['SmcVecName'],
                                                                  genderVec: vec['genderVec'],
                                                                  vecMobile: vec['vecMobile'],
                                                                  vecEmail: vec['vecEmail'],
                                                                  vecQualification: vec['vecQualification'],
                                                                  vecTotal: vec['vecTotal'],
                                                                  meetingDuration: vec['meetingDuration'],
                                                                  createdBy: vec['createdBy'],
                                                                  createdAt: vec['createdAt'],
                                                                  other: vec['other'],
                                                                  otherQual: vec['otherQual'],
                                                                  // Map more fields here if needed
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                    ]
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
