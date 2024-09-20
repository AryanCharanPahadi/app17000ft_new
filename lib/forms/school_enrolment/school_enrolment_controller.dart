import 'dart:convert';
import 'dart:io';

import 'package:app17000ft_new/constants/color_const.dart';
import 'package:app17000ft_new/forms/school_enrolment/school_enrolment_model.dart';
import 'package:app17000ft_new/forms/school_enrolment/school_enrolment_sync.dart';
import 'package:app17000ft_new/helper/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../base_client/baseClient_controller.dart';

class SchoolEnrolmentController extends GetxController with BaseController {
  String? _tourValue;
  String? get tourValue => _tourValue;

  // School Value
  String? _schoolValue;
  String? get schoolValue => _schoolValue;

  bool isLoading = false;

  final TextEditingController remarksController = TextEditingController();

  // Focus nodes
  final FocusNode _tourIdFocusNode = FocusNode();
  FocusNode get tourIdFocusNode => _tourIdFocusNode;
  final FocusNode _schoolFocusNode = FocusNode();
  FocusNode get schoolFocusNode => _schoolFocusNode;

  List<EnrolmentCollectionModel> _enrolmentList = [];
  List<EnrolmentCollectionModel> get enrolmentList => _enrolmentList;

  final List<XFile> _multipleImage = [];
  List<XFile> get multipleImage => _multipleImage;

  List<String> _imagePaths = [];
  List<String> get imagePaths => _imagePaths;

  // This will hold the converted list of File objects
  List<File> _imageFiles = [];
  List<File> get imageFiles => _imageFiles;

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

  // Convert a File to Base64 String
  Future<List<String>> convertImagesToBase64() async {
    List<String> base64Images = [];

    for (var image in _imageFiles) { // _imageFiles is the list of File objects
      final bytes = await image.readAsBytes();
      base64Images.add(base64Encode(bytes));
    }



    return base64Images;
  }

  // Setters for tour and school values
  setSchool(value) {
    _schoolValue = value;
    // update();
  }

  setTour(value) {
    _tourValue = value;
    // update();
  }

  // Bottom sheet for picking images
  Widget bottomSheet(BuildContext context) {
    String? imagePicked;
    final ImagePicker picker = ImagePicker();
    return Container(
      color: AppColors.primary,
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text(
            "Select Image",
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  imagePicked = await takePhoto(ImageSource.camera);
                  Get.back();
                },
                child: const Text(
                  'Camera',
                  style: TextStyle(fontSize: 20.0, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  imagePicked = await takePhoto(ImageSource.gallery);
                  Get.back();
                },
                child: const Text(
                  'Gallery',
                  style: TextStyle(fontSize: 20.0, color: AppColors.primary),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Show image preview
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

  // Clear fields in the form
  void clearFields() {
    // Clear the tour and school values
    _tourValue = null;
    _schoolValue = null;

    // Clear the remarks text controller
    remarksController.clear();

    // Clear the list of selected images, image paths, and converted files
    _multipleImage.clear();
    _imagePaths.clear();
    _imageFiles.clear();

    // Clear the enrolment list if needed
    _enrolmentList.clear();

    // Notify listeners that the state has changed
    update();
  }

  // Fetch data from local database
  fetchData() async {
    isLoading = true;

    _enrolmentList = [];
    _enrolmentList = await LocalDbController().fetchLocalEnrolmentRecord();

    update();
  }}