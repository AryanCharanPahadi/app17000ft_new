
import 'dart:convert';
import 'dart:io';

import 'package:app17000ft_new/constants/color_const.dart';
import 'package:app17000ft_new/forms/alfa_observation_form/alfa_obervation_modal.dart';
import 'package:app17000ft_new/forms/school_enrolment/school_enrolment_model.dart';
import 'package:app17000ft_new/forms/school_enrolment/school_enrolment_sync.dart';
import 'package:app17000ft_new/helper/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../base_client/baseClient_controller.dart';
import '../../constants/color_const.dart';
import 'alfa_obervation_modal.dart';
class AlfaObservationController extends GetxController with BaseController{

  String? _tourValue;
  String? get tourValue => _tourValue;

  //school Value
  String? _schoolValue;
  String? get schoolValue => _schoolValue;

  bool isLoading = false;

  final TextEditingController remarksController = TextEditingController();
  final TextEditingController correctUdiseCodeController = TextEditingController();
  final TextEditingController noOfStaffTrainedController = TextEditingController();
  final TextEditingController moduleEnglishController = TextEditingController();
  final TextEditingController alfaNumercyController = TextEditingController();
  final TextEditingController noOfTeacherTrainedController = TextEditingController();

  // Map to store selected values for radio buttons
  final Map<String, String?> _selectedValues = {};
  String? getSelectedValue(String key) => _selectedValues[key];

  // Map to store error states for radio buttons
  final Map<String, bool> _radioFieldErrors = {};
  bool getRadioFieldError(String key) => _radioFieldErrors[key] ?? false;

  // Method to set the selected value and clear any previous error
  void setRadioValue(String key, String? value) {
    _selectedValues[key] = value;
    _radioFieldErrors[key] = false; // Clear error when a value is selected
    update(); // Update the UI
  }

  // Method to validate radio button selection
  bool validateRadioSelection(String key) {
    if (_selectedValues[key] == null) {
      _radioFieldErrors[key] = true;
      update(); // Update the UI
      return false;
    }
    _radioFieldErrors[key] = false;
    update(); // Update the UI
    return true;
  }



  //Focus nodes
  final FocusNode _tourIdFocusNode = FocusNode();
  FocusNode get  tourIdFocusNode => _tourIdFocusNode;
  final FocusNode _schoolFocusNode = FocusNode();
  FocusNode get  schoolFocusNode => _schoolFocusNode;

  List<AlfaObservationModel> _alfaObservationList =[];
  List<AlfaObservationModel> get alfaObservationList => _alfaObservationList;

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


  final List<XFile> _multipleImage3 = [];
  List<XFile> get multipleImage3 => _multipleImage3;
  List<String> _imagePaths3 = [];
  List<String> get imagePaths3 => _imagePaths3;
  List<File> _imageFiles3 = [];
  List<File> get imageFiles3 => _imageFiles3;

  final List<XFile> _multipleImage4 = [];
  List<XFile> get multipleImage4 => _multipleImage4;
  List<String> _imagePaths4 = [];
  List<String> get imagePaths4 => _imagePaths4;
  List<File> _imageFiles4 = [];
  List<File> get imageFiles4 => _imageFiles4;


  final List<XFile> _multipleImage5 = [];
  List<XFile> get multipleImage5 => _multipleImage5;
  List<String> _imagePaths5 = [];
  List<String> get imagePaths5 => _imagePaths5;
  List<File> _imageFiles5 = [];
  List<File> get imageFiles5 => _imageFiles5;


  final List<XFile> _multipleImage6 = [];
  List<XFile> get multipleImage6 => _multipleImage6;
  List<String> _imagePaths6 = [];
  List<String> get imagePaths6 => _imagePaths6;
  List<File> _imageFiles6 = [];
  List<File> get imageFiles6 => _imageFiles6;



  final List<XFile> _multipleImage7 = [];
  List<XFile> get multipleImage7 => _multipleImage7;
  List<String> _imagePaths7 = [];
  List<String> get imagePaths7 => _imagePaths7;
  List<File> _imageFiles7 = [];
  List<File> get imageFiles7 => _imageFiles7;


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

  // Convert a File to Base64 String
  Future<List<String>> convertImagesToBase64_3() async {
    List<String> base64Images3 = [];

    for (var image in _imageFiles3) { // _imageFiles is the list of File objects
      final bytes = await image.readAsBytes();
      base64Images3.add(base64Encode(bytes));
    }
    return base64Images3;
  }

// Convert a File to Base64 String
  Future<List<String>> convertImagesToBase64_4() async {
    List<String> base64Images4 = [];

    for (var image in _imageFiles4) { // _imageFiles is the list of File objects
      final bytes = await image.readAsBytes();
      base64Images4.add(base64Encode(bytes));
    }
    return base64Images4;
  }

  // Convert a File to Base64 String
  Future<List<String>> convertImagesToBase64_5() async {
    List<String> base64Images5 = [];

    for (var image in _imageFiles5) { // _imageFiles is the list of File objects
      final bytes = await image.readAsBytes();
      base64Images5.add(base64Encode(bytes));
    }
    return base64Images5;
  }

  // Convert a File to Base64 String
  Future<List<String>> convertImagesToBase64_6() async {
    List<String> base64Images6 = [];

    for (var image in _imageFiles6) { // _imageFiles is the list of File objects
      final bytes = await image.readAsBytes();
      base64Images6.add(base64Encode(bytes));
    }
    return base64Images6;
  }

  // Convert a File to Base64 String
  Future<List<String>> convertImagesToBase64_7() async {
    List<String> base64Images7 = [];

    for (var image in _imageFiles7) { // _imageFiles is the list of File objects
      final bytes = await image.readAsBytes();
      base64Images7.add(base64Encode(bytes));
    }
    return base64Images7;
  }


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



  Future<String> takePhoto3(ImageSource source) async {
    final ImagePicker picker3 = ImagePicker();
    _multipleImage3.clear();  // Clear the existing images
    _imagePaths3 = [];
    _imageFiles3 = [];  // Clear the converted File objects

    if (source == ImageSource.gallery) {
      final selectedImages3 = await picker3.pickMultiImage();
      if (selectedImages3 != null) {
        _multipleImage3.addAll(selectedImages3);
        _imagePaths3 = selectedImages3.map((image) => image.path).toList();
        _imageFiles3 = selectedImages3.map((xfile) => File(xfile.path)).toList();  // Convert to File
      }
    } else if (source == ImageSource.camera) {
      final pickedImage3 = await picker3.pickImage(source: source);
      if (pickedImage3 != null) {
        _multipleImage3.add(pickedImage3);
        _imagePaths3.add(pickedImage3.path);
        _imageFiles3.add(File(pickedImage3.path));  // Convert to File
      }
    }
    update();
    return _imagePaths3.toString();
  }

  Future<String> takePhoto4(ImageSource source) async {
    final ImagePicker picker4 = ImagePicker();
    _multipleImage4.clear();  // Clear the existing images
    _imagePaths4 = [];
    _imageFiles4 = [];  // Clear the converted File objects

    if (source == ImageSource.gallery) {
      final selectedImages4 = await picker4.pickMultiImage();
      if (selectedImages4 != null) {
        _multipleImage4.addAll(selectedImages4);
        _imagePaths4 = selectedImages4.map((image) => image.path).toList();
        _imageFiles4 = selectedImages4.map((xfile) => File(xfile.path)).toList();  // Convert to File
      }
    } else if (source == ImageSource.camera) {
      final pickedImage4 = await picker4.pickImage(source: source);
      if (pickedImage4 != null) {
        _multipleImage4.add(pickedImage4);
        _imagePaths4.add(pickedImage4.path);
        _imageFiles4.add(File(pickedImage4.path));  // Convert to File
      }
    }
    update();
    return _imagePaths4.toString();
  }

  Future<String> takePhoto5(ImageSource source) async {
    final ImagePicker picker5 = ImagePicker();
    _multipleImage5.clear();  // Clear the existing images
    _imagePaths5 = [];
    _imageFiles5 = [];  // Clear the converted File objects

    if (source == ImageSource.gallery) {
      final selectedImages5 = await picker5.pickMultiImage();
      if (selectedImages5 != null) {
        _multipleImage5.addAll(selectedImages5);
        _imagePaths5 = selectedImages5.map((image) => image.path).toList();
        _imageFiles5 = selectedImages5.map((xfile) => File(xfile.path)).toList();  // Convert to File
      }
    } else if (source == ImageSource.camera) {
      final pickedImage5 = await picker5.pickImage(source: source);
      if (pickedImage5 != null) {
        _multipleImage5.add(pickedImage5);
        _imagePaths5.add(pickedImage5.path);
        _imageFiles5.add(File(pickedImage5.path));  // Convert to File
      }
    }
    update();
    return _imagePaths5.toString();
  }

  Future<String> takePhoto6(ImageSource source) async {
    final ImagePicker picker6 = ImagePicker();
    _multipleImage6.clear();  // Clear the existing images
    _imagePaths6 = [];
    _imageFiles6 = [];  // Clear the converted File objects

    if (source == ImageSource.gallery) {
      final selectedImages6 = await picker6.pickMultiImage();
      if (selectedImages6 != null) {
        _multipleImage6.addAll(selectedImages6);
        _imagePaths6 = selectedImages6.map((image) => image.path).toList();
        _imageFiles6 = selectedImages6.map((xfile) => File(xfile.path)).toList();  // Convert to File
      }
    } else if (source == ImageSource.camera) {
      final pickedImage6 = await picker6.pickImage(source: source);
      if (pickedImage6 != null) {
        _multipleImage6.add(pickedImage6);
        _imagePaths6.add(pickedImage6.path);
        _imageFiles6.add(File(pickedImage6.path));  // Convert to File
      }
    }
    update();
    return _imagePaths6.toString();
  }

  Future<String> takePhoto7(ImageSource source) async {
    final ImagePicker picker7 = ImagePicker();
    _multipleImage7.clear();  // Clear the existing images
    _imagePaths7 = [];
    _imageFiles7 = [];  // Clear the converted File objects

    if (source == ImageSource.gallery) {
      final selectedImages7 = await picker7.pickMultiImage();
      if (selectedImages7 != null) {
        _multipleImage7.addAll(selectedImages7);
        _imagePaths7 = selectedImages7.map((image) => image.path).toList();
        _imageFiles7 = selectedImages7.map((xfile) => File(xfile.path)).toList();  // Convert to File
      }
    } else if (source == ImageSource.camera) {
      final pickedImage7 = await picker7.pickImage(source: source);
      if (pickedImage7 != null) {
        _multipleImage7.add(pickedImage7);
        _imagePaths7.add(pickedImage7.path);
        _imageFiles7.add(File(pickedImage7.path));  // Convert to File
      }
    }
    update();
    return _imagePaths7.toString();
  }

  setSchool(value)
  {
    _schoolValue = value;
    // update();
  }

  setTour(value){
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


  Widget bottomSheet2(BuildContext context) {
    return Container(
      color: AppColors.primary,
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text("Select Image", style: TextStyle(fontSize: 20.0, color: Colors.white)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto2(ImageSource.camera);
                  Get.back();
                },
                child: const Text('Camera', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto2(ImageSource.gallery);
                  Get.back();
                },
                child: const Text('Gallery', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget bottomSheet3(BuildContext context) {
    return Container(
      color: AppColors.primary,
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text("Select Image", style: TextStyle(fontSize: 20.0, color: Colors.white)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto3(ImageSource.camera);
                  Get.back();
                },
                child: const Text('Camera', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto3(ImageSource.gallery);
                  Get.back();
                },
                child: const Text('Gallery', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget bottomSheet4(BuildContext context) {
    return Container(
      color: AppColors.primary,
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text("Select Image", style: TextStyle(fontSize: 20.0, color: Colors.white)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto4(ImageSource.camera);
                  Get.back();
                },
                child: const Text('Camera', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto4(ImageSource.gallery);
                  Get.back();
                },
                child: const Text('Gallery', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget bottomSheet5(BuildContext context) {
    return Container(
      color: AppColors.primary,
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text("Select Image", style: TextStyle(fontSize: 20.0, color: Colors.white)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto5(ImageSource.camera);
                  Get.back();
                },
                child: const Text('Camera', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto5(ImageSource.gallery);
                  Get.back();
                },
                child: const Text('Gallery', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget bottomSheet6(BuildContext context) {
    return Container(
      color: AppColors.primary,
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text("Select Image", style: TextStyle(fontSize: 20.0, color: Colors.white)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto6(ImageSource.camera);
                  Get.back();
                },
                child: const Text('Camera', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto6(ImageSource.gallery);
                  Get.back();
                },
                child: const Text('Gallery', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget bottomSheet7(BuildContext context) {
    return Container(
      color: AppColors.primary,
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text("Select Image", style: TextStyle(fontSize: 20.0, color: Colors.white)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto7(ImageSource.camera);
                  Get.back();
                },
                child: const Text('Camera', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto7(ImageSource.gallery);
                  Get.back();
                },
                child: const Text('Gallery', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
            ],
          ),
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
              child: Image.file(File(imagePath2), fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }

  void showImagePreview3(String imagePath3, BuildContext context) {
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
              child: Image.file(File(imagePath3), fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }


  void showImagePreview4(String imagePath4, BuildContext context) {
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
              child: Image.file(File(imagePath4), fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }


  void showImagePreview5(String imagePath5, BuildContext context) {
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
              child: Image.file(File(imagePath5), fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }


  void showImagePreview6(String imagePath6, BuildContext context) {
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
              child: Image.file(File(imagePath6), fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }

  void showImagePreview7(String imagePath7, BuildContext context) {
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
              child: Image.file(File(imagePath7), fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }

  //Clear fields
  void clearFields() {

    update();
  }

  fetchData() async {
    isLoading = true;

    _alfaObservationList = [];
    _alfaObservationList = await LocalDbController().fetchLocalAlfaObservationModel();

    update();
  }

//

//Update the UI


}