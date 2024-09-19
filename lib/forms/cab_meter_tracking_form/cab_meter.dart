import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app17000ft_new/components/custom_appBar.dart';
import 'package:app17000ft_new/components/custom_button.dart';
import 'package:app17000ft_new/components/custom_imagepreview.dart';
import 'package:app17000ft_new/components/custom_textField.dart';
import 'package:app17000ft_new/components/error_text.dart';
import 'package:app17000ft_new/constants/color_const.dart';
import 'package:app17000ft_new/forms/cab_meter_tracking_form/cab_meter_tracing_controller.dart';
import 'package:app17000ft_new/helper/responsive_helper.dart';
import 'package:app17000ft_new/tourDetails/tour_controller.dart';
import 'package:app17000ft_new/components/custom_dropdown.dart';
import 'package:app17000ft_new/components/custom_labeltext.dart';
import 'package:app17000ft_new/components/custom_sizedBox.dart';

import '../../components/custom_snackbar.dart';
import '../../helper/database_helper.dart';
import 'cab_meter_tracing_modal.dart';

class CabMeterTracingForm extends StatefulWidget {
  String? userid;
  String? office;
  CabMeterTracingForm({super.key, this.userid, this.office});

  @override
  State<CabMeterTracingForm> createState() => _CabMeterTracingFormState();
}

class _CabMeterTracingFormState extends State<CabMeterTracingForm> {
  String? _selectedValue = '';
  bool _isImageUploaded = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  bool validateRegister = false;
  List<String> splitSchoolLists = [];
  bool _radioFieldError = false;
  final ImagePicker _picker = ImagePicker();
  List<File> _imageFiles = [];
  var jsonData = <String, Map<String, String>>{};

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFiles.add(File(pickedFile.path));
        _isImageUploaded = true;
        validateRegister = false; // Reset error state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Cab Meter Tracing Form',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              GetBuilder<CabMeterTracingController>(
                init: CabMeterTracingController(),
                builder: (cabMeterController) {
                  return Form(
                    key: _formKey,
                    child: GetBuilder<TourController>(
                      init: TourController(),
                      builder: (tourController) {
                        tourController.fetchTourDetails();

                        return Column(children: [
                          LabelText(
                            label: 'Tour ID',
                            astrick: true,
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          CustomDropdownFormField(
                            focusNode: cabMeterController.tourIdFocusNode,
                            options: tourController.getLocalTourList
                                .map((e) => e.tourId)
                                .toList(),
                            selectedOption: cabMeterController.tourValue,
                            onChanged: (value) {
                              splitSchoolLists = tourController.getLocalTourList
                                  .where((e) => e.tourId == value)
                                  .map((e) => e.allSchool.split('|').toList())
                                  .expand((x) => x)
                                  .toList();
                              setState(() {
                                cabMeterController.setSchool(null);
                                cabMeterController.setTour(value);
                              });
                            },
                            labelText: "Select Tour ID",
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          LabelText(
                            label: 'Place Visited',
                            astrick: true,
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          CustomTextFormField(
                            textController:
                                cabMeterController.placeVisitedController,
                            labelText: 'Place Visited',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Place Visited';
                              }
                              return null;
                            },
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          LabelText(
                            label: 'Vehicle Number',
                            astrick: true,
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          CustomTextFormField(
                            textController:
                                cabMeterController.VehicleNumberController,
                            labelText: 'Vehicle Number',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Vehicle Number';
                              }
                              // Regex pattern for validating Indian vehicle number plate
                              final regExp =
                                  RegExp(r"^[a-zA-Z]{2}[a-zA-Z0-9]*[0-9]{4}$");
                              if (!regExp.hasMatch(value)) {
                                return 'Please Enter a valid Vehicle Number';
                              }
                              return null;
                            },
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          LabelText(
                            label: 'Driver Name',
                            astrick: true,
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          CustomTextFormField(
                            textController:
                                cabMeterController.driverNameController,
                            labelText: 'Driver Name',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Driver Name';
                              }
                              return null;
                            },
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          LabelText(
                            label: 'Meter reading',
                            astrick: true,
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          CustomTextFormField(
                            textController:
                                cabMeterController.meterReadingController,
                            labelText: 'Meter reading',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Meter Reading';
                              }
                              return null;
                            },
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          LabelText(
                            label: 'Click Images:',
                            astrick: true,
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                width: 2,
                                color: _isImageUploaded
                                    ? AppColors.primary
                                    : AppColors.error,
                              ),
                            ),
                            child: ListTile(
                              title: _isImageUploaded
                                  ? const Text('Click or Upload Image')
                                  : const Text('Click Supporting Images'),
                              trailing: const Icon(Icons.camera_alt,
                                  color: AppColors.onBackground),
                              onTap: _pickImageFromCamera,
                            ),
                          ),
                          ErrorText(
                            isVisible: validateRegister,
                            message: 'Register Image Required',
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          if (_imageFiles.isNotEmpty)
                            Container(
                              width: responsive.responsiveValue(
                                small: 600.0,
                                medium: 900.0,
                                large: 1400.0,
                              ),
                              height: responsive.responsiveValue(
                                small: 170.0,
                                medium: 170.0,
                                large: 170.0,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _imageFiles.length,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    height: 200,
                                    width: 200,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              CustomImagePreview
                                                  .showImagePreview(
                                                _imageFiles[index].path,
                                                context,
                                              );
                                            },
                                            child: Image.file(
                                              _imageFiles[index],
                                              width: 190,
                                              height: 120,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _imageFiles.removeAt(index);
                                            });
                                          },
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          LabelText(
                            label: 'Choose Options:',
                            astrick: true,
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 300),
                            child: Row(
                              children: [
                                Radio(
                                  value: 'Start',
                                  groupValue: cabMeterController
                                      .getSelectedValue('meter'),
                                  onChanged: (value) {
                                    cabMeterController.setRadioValue(
                                        'meter', value);
                                  },
                                ),
                                const Text('Start'),
                              ],
                            ),
                          ),
                          CustomSizedBox(
                            value: 150,
                            side: 'width',
                          ),
                          // make it that user can also edit the tourId and school
                          Padding(
                            padding: const EdgeInsets.only(right: 300),
                            child: Row(
                              children: [
                                Radio(
                                  value: 'End',
                                  groupValue: cabMeterController
                                      .getSelectedValue('meter'),
                                  onChanged: (value) {
                                    cabMeterController.setRadioValue(
                                        'meter', value);
                                  },
                                ),
                                const Text('End'),
                              ],
                            ),
                          ),
                          if (cabMeterController.getRadioFieldError('meter'))
                            const Padding(
                              padding: EdgeInsets.only(left: 16.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Please select an option',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          LabelText(
                            label: 'Remarks',
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          CustomTextFormField(
                            textController:
                                cabMeterController.remarksController,
                            labelText: 'Remarks Here',
                            validator: (value) {
                              if (value != null && value.length > 30) {
                                return 'Text must not be more than 30 characters';
                              }
                              return null;
                            },
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          CustomButton(
                            title: 'Submit',
                            onPressedButton: () async {
                              final isRadioValid1 = cabMeterController.validateRadioSelection('meter');
                              setState(() {
                                validateRegister = !_isImageUploaded || _imageFiles.isEmpty;
                              });

                              if (_formKey.currentState!.validate() && !_imageFiles.isEmpty && isRadioValid1) {
                                // Generate a unique ID
                                String generateUniqueId(int length) {
                                  const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
                                  Random _rnd = Random();
                                  return String.fromCharCodes(Iterable.generate(
                                      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
                                }

                                String uniqueId = generateUniqueId(6);
                                DateTime now = DateTime.now();
                                String formattedDate = DateFormat('yyyy-MM-dd').format(now);



                                // Create CabMeterTracingRecords object
                                CabMeterTracingRecords enrolmentCollectionObj = CabMeterTracingRecords(
                                  status: cabMeterController.getSelectedValue('meter') ?? '',
                                  place_visit: cabMeterController.placeVisitedController.text,
                                  remarks: cabMeterController.remarksController.text,
                                  vehicle_num: cabMeterController.VehicleNumberController.text,
                                  driver_name: cabMeterController.driverNameController.text,
                                  meter_reading: cabMeterController.meterReadingController.text,
                                  image: _imageFiles.map((file) => file.path).toString(),
                                  office: widget.office ?? '',
                                  tour_id: cabMeterController.tourValue ?? '',
                                  created_at: formattedDate,
                                  uniqueId: uniqueId,
                                );

                                // Save data to local database
                                int result = await LocalDbController().addData(
                                  cabMeterTracingRecords: enrolmentCollectionObj,
                                );

                                if (result > 0) {
                                  cabMeterController.clearFields();
                                  setState(() {
                                    jsonData = {};
                                    _imageFiles = [];
                                    _isImageUploaded = false;
                                    _selectedValue = '';
                                  });

                                  // Save the data to a file as JSON
                                  await saveDataToFile(enrolmentCollectionObj).then((_) {
                                    // If successful, show a snackbar indicating the file was downloaded
                                    customSnackbar(
                                      'File downloaded successfully',
                                      'downloaded',
                                      AppColors.primary,
                                      AppColors.onPrimary,
                                      Icons.file_download_done,
                                    );
                                  }).catchError((error) {
                                    // If there's an error during download, show an error snackbar
                                    customSnackbar(
                                      'Error',
                                      'File download failed: $error',
                                      AppColors.primary,
                                      AppColors.onPrimary,
                                      Icons.error,
                                    );
                                  });

                                  customSnackbar(
                                    'Submitted Successfully',
                                    'submitted',
                                    AppColors.primary,
                                    AppColors.onPrimary,
                                    Icons.verified,
                                  );
                                } else {
                                  customSnackbar(
                                    'Error',
                                    'Something went wrong',
                                    AppColors.primary,
                                    AppColors.onPrimary,
                                    Icons.error,
                                  );
                                }
                              }
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                          )

                        ]);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Function to save JSON data to a file

Future<void> saveDataToFile(CabMeterTracingRecords data) async {
  try {
    // Request storage permissions
    var status = await Permission.storage.request();
    if (status.isGranted) {
      // Get the user's downloads directory
      final directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        print('Download directory not found');
        return;
      }

      final path = '${directory.path}/cab_Meter_Tracing${data.uniqueId}.txt';

      // Convert the CabMeterTracingRecords object to a JSON string
      String jsonString = jsonEncode(data);

      // Write the JSON string to a file
      File file = File(path);
      await file.writeAsString(jsonString);

      print('Data saved to $path');
    } else {
      print('Storage permission not granted');
      // Optionally, handle what happens if permission is denied
    }
  } catch (e) {
    print('Error saving data: $e');
  }
}


