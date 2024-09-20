import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:app17000ft_new/constants/color_const.dart';

import 'package:app17000ft_new/forms/school_facilities_&_mapping_form/school_facilities_modals.dart';
import 'package:app17000ft_new/helper/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../base_client/baseClient_controller.dart';


class SchoolFacilitiesController extends GetxController with BaseController {
  var counterText = ''.obs;
  String? _tourValue;
  String? get tourValue => _tourValue;

  String? _schoolValue;
  String? get schoolValue => _schoolValue;

  bool isLoading = false;
  final TextEditingController noOfEnrolledStudentAsOnDateController = TextEditingController();
  final TextEditingController noOfFunctionalClassroomController = TextEditingController();
  final TextEditingController nameOfLibrarianController = TextEditingController();
  final TextEditingController correctUdiseCodeController = TextEditingController();



  final FocusNode _tourIdFocusNode = FocusNode();
  FocusNode get tourIdFocusNode => _tourIdFocusNode;

  final FocusNode _schoolFocusNode = FocusNode();
  FocusNode get schoolFocusNode => _schoolFocusNode;

  List<SchoolFacilitiesRecords> _schoolFacilitiesList = [];
  List<SchoolFacilitiesRecords> get schoolFacilitiesList => _schoolFacilitiesList;

  final List<XFile> _multipleImage = [];
  List<XFile> get multipleImage => _multipleImage;
  List<String> _imagePaths = [];
  List<String> get imagePaths => _imagePaths;
  // This will hold the converted list of File objects
  List<File> _imageFiles = [];
  List<File> get imageFiles => _imageFiles;

  final List<XFile> _multipleImage2 = [];
  List<XFile> get multipleImage2 => _multipleImage2;
  List<String> _imagePaths2 = [];
  List<String> get imagePaths2 => _imagePaths2;
  List<File> _imageFiles2 = [];
  List<File> get imageFiles2 => _imageFiles2;


  // Method to capture or pick photos
  Future<String> takePhoto(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    _multipleImage.clear();  // Clear the existing images
    _imagePaths = [];
    _imageFiles = [];  // Clear the converted File objects

    if (source == ImageSource.gallery) {
      final selectedImages = await picker.pickMultiImage();
      if (selectedImages != null) {
        _multipleImage.addAll(selectedImages);
        _imagePaths = selectedImages.map((image) => image.path).toList();
        _imageFiles = selectedImages.map((xfile) => File(xfile.path)).toList();  // Convert to File
      }
    } else if (source == ImageSource.camera) {
      final pickedImage = await picker.pickImage(source: source);
      if (pickedImage != null) {
        _multipleImage.add(pickedImage);
        _imagePaths.add(pickedImage.path);
        _imageFiles.add(File(pickedImage.path));  // Convert to File
      }
    }
    update();
    return _imagePaths.toString();
  }




// Method to capture or pick photos
  Future<String> takePhoto2(ImageSource source) async {
    final ImagePicker picker2 = ImagePicker();
    _multipleImage2.clear();  // Clear the existing images
    _imagePaths2 = [];
    _imageFiles2 = [];  // Clear the converted File objects


    if (source == ImageSource.gallery) {
      final selectedImages2 = await picker2.pickMultiImage();
      if (selectedImages2 != null) {
        _multipleImage2.addAll(selectedImages2);
        _imagePaths2 = selectedImages2.map((image) => image.path).toList();
        _imageFiles2 = selectedImages2.map((xfile) => File(xfile.path)).toList();  // Convert to File
      }
    } else if (source == ImageSource.camera) {
      final pickedImage2 = await picker2.pickImage(source: source);
      if (pickedImage2 != null) {
        _multipleImage2.add(pickedImage2);
        _imagePaths2.add(pickedImage2.path);
        _imageFiles2.add(File(pickedImage2.path));  // Convert to File
      }
    }
    update();
    return _imagePaths2.toString();
  }


  // Convert a File to Base64 String
  Future<List<String>> convertImagesToBase64() async {
    List<String> base64Images = [];

    for (var image in _imageFiles) { // _imageFiles is the list of File objects
      final bytes = await image.readAsBytes();
      base64Images.add(base64Encode(bytes));
    }

    return base64Images;
  }



  // Convert a File to Base64 String
  Future<List<String>> convertImagesToBase64_2() async {
    List<String> base64Images2 = [];

    for (var image in _imageFiles2) { // _imageFiles is the list of File objects
      final bytes = await image.readAsBytes();
      base64Images2.add(base64Encode(bytes));
    }
    return base64Images2;
  }


  void setSchool(String? value) {
    _schoolValue = value;

  }

  void setTour(String? value) {
    _tourValue = value;

  }



  List<String> splitSchoolLists = [];
  String? selectedDesignation;

  // Start of Showing Fields
  bool showBasicDetails = true; // For show Basic Details
  bool showSchoolFacilities = false; //For show and hide School Facilities
  bool showLibrary = false; //For show and hide Library
  // End of Showing Fields

  bool validateRegister = false;
  bool isImageUploaded = false;

  bool validateRegister2 = false;
  bool isImageUploaded2 = false;


  Widget bottomSheet(BuildContext context) {
    return Container(
      color: AppColors.primary,
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
          vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Select Image",
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto(ImageSource.camera);
                  Get.back();
                },
                child: const Text(
                  'Camera',
                  style: TextStyle(fontSize: 20.0, color: AppColors.primary),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto(ImageSource.gallery);
                  Get.back();
                },
                child: const Text(
                  'Gallery',
                  style: TextStyle(fontSize: 20.0, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget bottomSheet2(BuildContext context) {
    return Container(
      color: AppColors.primary,
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Select Image",
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto2(ImageSource.camera);
                  Get.back();
                },
                child: const Text(
                  'Camera',
                  style: TextStyle(fontSize: 20.0, color: AppColors.primary),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto2(ImageSource.gallery);
                  Get.back();
                },
                child: const Text(
                  'Gallery',
                  style: TextStyle(fontSize: 20.0, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showImagePreview(String imagePath, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.file(
                File(imagePath),
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }
 void showImagePreview2(String imagePath2, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.file(
                File(imagePath2),
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }


  void clearFields() {
    _tourValue = null;
    _schoolValue = null;
    correctUdiseCodeController.clear();
    noOfFunctionalClassroomController.clear();
    noOfEnrolledStudentAsOnDateController.clear();
    nameOfLibrarianController.clear();
    correctUdiseCodeController.clear();

  }

  Future<void> fetchData() async {
    isLoading = true;
    update();
    _schoolFacilitiesList = await LocalDbController().fetchLocalSchoolFacilitiesRecords();
    isLoading = false;
    update();
  }
}